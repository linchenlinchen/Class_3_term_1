package software;

import exception.ErrorCode;
import id.BlockId;
import id.BlockManagerId;
import itf.*;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;

/*ClassName FileImpl
 *Description
 *Author 2019/10/19
 *Date 2019/10/19 11:51
 *Version 1.0
 */
public class FileImpl implements File {
    public static int offsetOfMeta = 3;
    private long pos;
    private long size;
    private int blkSize;
    private Id field;
    private FileManager fm;
    public FileImpl(int blkSize,FileManager fm,Id field) {
        this.blkSize = blkSize;
        this.field = field;
        this.fm = fm;
        size = 0;
        pos = 0;
        java.io.File file = new java.io.File(getFileMetaStr());
        /*如果文件已经存在，就默认该文件已经记录好信息*/
        if(file.exists()){
            this.blkSize = FileUtil.getBlockSizeOfMeta(getFileMetaStr());
            size = FileUtil.getSizeOfMeta(getFileMetaStr());
            pos = FileUtil.getPosOfMeta(getFileMetaStr());
        }
        /*如果文件不存在则创建并初始化*/
        else {
            try {
                file.createNewFile();
            }catch (IOException e){
                ErrorCode.getErrorText(5);
            }
            FileUtil.writeFileMeta(getFileMetaStr(),0,blkSize,0,new byte[0]);
        }
    }

    public String getFileMetaStr(){
        return "FileManagers/"+fm.getFid().getIdStr()+"/"+field.getIdStr()+".meta";
    }
    public String getBlkMngName(String str){
        if(str.contains(",")){
            return str.split(",")[0];
        }
        return null;
    }
    public String getBlkIdStr(String str){
        if(str.contains(",")){
            return str.split(",")[1];
        }
        return null;
    }
    public Block getSomeBlock(int index){
        String content = FileUtil.getContents(getFileMetaStr());
        String[] line = content.split("\n");
        if(index< line.length-offsetOfMeta-1 && index >= 0){
            String aLine = line[offsetOfMeta+1+index];/*+1是因为因为logic block：的一行*/
            String lineData = aLine.split(":")[1];
            return getValidBlk(lineData);
        }
        return null;
    }
    public Block getValidBlk(String lineData){
        String[] sameBlks = lineData.split(";");
        int length = sameBlks.length-1;
        for (int i = 0; i < length; i++) {
            String blkMngName = getBlkMngName(sameBlks[i]);
            Id id = new BlockManagerId(blkMngName);
            String blkIdStr = getBlkIdStr(sameBlks[i]);
            Id id2 = new BlockId(Long.parseLong(blkIdStr));
            String data_path = StringOperation.bindStr_data("blockManagers/"+blkMngName,blkIdStr);
            String meta_path = StringOperation.bindStr_meta("blockManagers/"+blkMngName,blkIdStr);
            java.io.File fileM = new java.io.File(meta_path);
            if(((BlockManagerIml)(BlockManagerIml.getBlockManager(id))).existId(getBlkMngName(sameBlks[i]))
               && fileM.exists()
               && StringOperation.checksum(FileUtil.getBytes(data_path)) == FileUtil.getChecksum(meta_path)){
                BlockManager bm = (BlockManagerIml)(BlockManagerIml.getBlockManager(id));
                return bm.getBlock(id2);
            }
        }
        return null;
    }
    public static int[] randomCommon(int min, int max, int n){
        if (n > (max - min + 1) || max < min) {
            return null;
        }
        int[] result = new int[n];
        int count = 0;
        while(count < n) {
            int num = (int) (Math.random() * (max - min + 1)) + min;
            boolean flag = true;
            for (int j = 0; j < n; j++) {
                if(num == result[j]){
                    flag = false;
                    break;
                }
            }
            if(flag){
                result[count] = num;
                count++;
            }
        }
        return result;
    }
    /*返回在filemeta中第四行开始的索引值*/
    public int getLastedBlockIndex(){
        return (int)((size-1)/blkSize);
    }

    public int getRestCount(){
        return (int)(size%blkSize);
    }
    /*传入无需修改的指针前的block在filemeta中的index*/
    public String getLeftMeta(int indexOfBlk){
        String meta = FileUtil.getContents(getFileMetaStr());
        int numOfUnchangedLine = indexOfBlk+offsetOfMeta;
//        long newSize = (indexOfBlk+1)*blkSize;
        String[] metaArr = meta.split("\n");
        String leftMeta = StringOperation.bindPartialArr(metaArr,offsetOfMeta+1,indexOfBlk);
        return leftMeta;
    }

    public void writeFromNewBlock(byte[] new_b,int rest){
        int num = (new_b.length-1)/blkSize + 1;
        int[] ran = randomCommon(0,Main.NUMOFBM-1,Main.DUPLICATION_NUMBER);
        /*假设ran不存在null指针*/
        String[][] idStr = new String[Main.DUPLICATION_NUMBER*num][2];
        byte[][] segments = StringOperation.getSegments(new_b,blkSize);
        for (int i = 0; i < num; i++) {
            for (int j = 0; j < Main.DUPLICATION_NUMBER; j++) {
                Id id1 = BlockManagerIml.blkMngs.get(ran[j]).getId();
                Block t1 = ((BlockManagerIml)(BlockManagerIml.getBlockManager(id1))).newBlock(segments[i]);
                idStr[Main.DUPLICATION_NUMBER*i+j][0] = id1.getIdStr();
                idStr[Main.DUPLICATION_NUMBER*i+j][1] = t1.getIndexId().getIdStr();
            }
        }

        /*前面data已经写完，接下来写修改filemeta的部分*/
        /*第一步，修改size后完全复制到新数组*/
        String[] contents = FileUtil.getContents(getFileMetaStr()).split("\n");
        long oldSize = Long.parseLong(contents[0].split(":")[1]);/**/
        long newSize = oldSize+new_b.length-rest;
        size = newSize;
        contents[0] = "size:"+newSize;

        int beginIndexInArr = contents.length - offsetOfMeta;
        StringBuilder stringBuilder = new StringBuilder();
        for (int i = offsetOfMeta+1; i < contents.length; i++) {
            stringBuilder.append(contents[i]);
            stringBuilder.append("\n");
        }
        for (int i = beginIndexInArr; i < beginIndexInArr+num; i++) {
            stringBuilder.append("b").append(":");
            for (int j = 0; j < Main.DUPLICATION_NUMBER; j++) {
                stringBuilder.append(idStr[(i-beginIndexInArr)*Main.DUPLICATION_NUMBER + j][0]);
                stringBuilder.append(",");
                stringBuilder.append(idStr[(i-beginIndexInArr)*Main.DUPLICATION_NUMBER + j][1]);
                stringBuilder.append(";");
            }
            stringBuilder.append("\n");
        }
        stringBuilder.deleteCharAt(stringBuilder.toString().length()-1);
        FileUtil.writeFileMeta(getFileMetaStr(),size,blkSize,size,stringBuilder.toString());
    }

    @Override
    public Id getFileId() {
        return field;
    }

    @Override
    public FileManager getFileManager() {
        return fm;
    }

    @Override
    public byte[] read(int length) throws IOException {
        java.io.File file = new java.io.File(getFileMetaStr());
        long size;
        int blockSize;
        long poss;

        ArrayList blocks = new ArrayList();
        FileReader reader;
        BufferedReader bReader = null;
        StringBuilder sb = new StringBuilder();
        byte[] raw_result = null;
        reader = new FileReader(file);
        bReader = new BufferedReader(reader);
        size = Long.parseLong(bReader.readLine().split(":")[1]);
        blockSize = Integer.parseInt(bReader.readLine().split(":")[1]);
        poss = Long.parseLong(bReader.readLine().split(":")[1]);/*poss是更加客观的，因为可能这个文件之前写过，然后现在运行程序的，而poss记录的是上一次写后调整的指针位置*/
        pos = poss;/*更新pos*/
        if(size < pos+length)length = (int)(size-pos);/*获取字节大于有的字节*/
        raw_result = new byte[(int)size];
        bReader.readLine();/*无用行*/
        String s;
        StringBuilder ss = new StringBuilder();
        int time = 0;
        while ((s = bReader.readLine())!=null){
            ss.append(s);
            ss.append("\n");
            String data = s.split(":")[1];/*去除“b”*/
            Block block = getValidBlk(data);
            byte[] bs = null;
            if(block!=null) {
                blocks.add(block);/*加入方法创建的arraylist*/
                bs = block.read();
            }

            /*如果为空，出现文件空洞，还应该加入0x00 0x00...尚未实现*/
            for (int i = 0; i < blockSize; i++) {
                if(time*blockSize+i<(int) size){
                    raw_result[time*blockSize+i] = bs[i];
                }else {
                    break;
                }
            }
            /*暂时没有异常处理*/
            time++;
        }
        ss.deleteCharAt(ss.toString().length()-1);
        byte[] result = new byte[length];
        System.arraycopy(raw_result,new Long(pos).intValue(),result,0,length);
        /*移动指针*/
        pos = pos+length;
        FileUtil.writeFileMeta(getFileMetaStr(),size,blockSize,pos,ss.toString());
        return result;
    }

    @Override
    public void write(byte[] b) {
        /*需要变动的block在本file中是第几个*/
        long oldPos = pos;
        int beginBlkNum = new Long((pos)/blkSize).intValue();
        int rest = new Long((pos)%blkSize).intValue();
        if(rest!=0){
            /*获得pos所在的block和内部数据*/
            Block lastedBlock = getSomeBlock(beginBlkNum);
//            BlockManager lastedBlockManger = lastedBlock.getBlockManager();
            byte[] lastedBlockBytes = ((BlockIml)lastedBlock).read();
            byte[] lastedBlockBytesD = new byte[rest];
            System.arraycopy(lastedBlockBytes,0,lastedBlockBytesD,0,rest);
            byte[] new_b = new byte[lastedBlockBytesD.length+b.length];
            FileUtil.writeFileMeta(getFileMetaStr(),beginBlkNum*blkSize,blkSize,beginBlkNum*blkSize,getLeftMeta(beginBlkNum));

            System.arraycopy(lastedBlockBytesD,0,new_b,0,lastedBlockBytesD.length);
            System.arraycopy(b,0,new_b,lastedBlockBytesD.length,b.length);
            writeFromNewBlock(new_b,rest);
        }else {
            writeFromNewBlock(b,0);
        }
    }

    @Override
    public long pos() {
        return pos;
    }

    @Override
    public long move(long offset, int where) {
        switch (where){
            case MOVE_CURR:
                long tempPos = (pos+offset);
                if(tempPos>=0 && tempPos<=size){
                    pos = tempPos;
                }else if(tempPos>size){
                    pos = size;/*先将指针移动到文件尾*/
                    byte[] append = new byte[(int)(tempPos-size)];/*创建附加的*/
                    write(append);/*write写入空洞*/
                }else {
                    pos = 0;/*超出负方向范围，设置为0*/
                }
                break;
            case MOVE_HEAD:
                if(offset>=0 && offset<=size){
                    pos = offset;
                }else if(offset > size){
                    pos = size;
                    byte[] append = new byte[(int)(offset-size)];
                    write(append);
                }else {
                    pos = 0;
                }
                break;
            case MOVE_TAIL:
                if(offset<=0 && offset >= -size){
                    pos = size-offset;
                }else if(offset > 0){
                    pos = size;
                    byte[] append = new byte[(int)(offset)];
                    write(append);
                }else {
                    pos = 0;
                }
                break;
                default:break;
        }
        FileUtil.writeFileMeta(getFileMetaStr(),size,blkSize,pos,FileUtil.getLogicOfMeta(getFileMetaStr()));
        return pos;
    }

    @Override
    public void close() {
    }

    @Override
    public long size() {
        return size;
    }

    @Override
    public void setSize(long newSize) {
        long distance = newSize - size;
        byte[] bs = new byte[(int)distance];
        for (int i = 0; i < bs.length; i++) {
            bs[i] = '0';
        }
        FileUtil.writeFileMeta(getFileMetaStr(),newSize,blkSize,newSize,bs);
        this.size = newSize;
        pos = newSize;
    }
}
