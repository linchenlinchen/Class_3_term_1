package software;

import exception.ErrorCode;
import id.BlockId;
import id.BlockManagerId;
import itf.Block;
import itf.BlockManager;
import itf.Id;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;

/*ClassName BlockManagerIml
 *Description
 *Author 2019/10/16
 *Date 2019/10/16 17:02
 *Version 1.0
 */
public class BlockManagerIml implements BlockManager {
    private static final int DEFAULT_SIZE = 256;
    private Id id;
    public ArrayList<Block> blocks = new ArrayList<>();
    public static ArrayList<BlockManager> blkMngs = new ArrayList<>();

    /*constructor*/
    public BlockManagerIml(String idStr){
        /*默认出现已经存在的idStr只有在上次执行中创建，而同一次并不会出现同名--假设用户这个上面是聪明的*/
        Id id = new BlockManagerId(idStr);
        this.id = id;
        java.io.File id_count = new File(getCountPath());
        try {
            id_count.createNewFile();
            byte[] t = new byte[1];/*初始化*/
            t[0] = '0';
            FileUtil.write(id_count.getPath(),t);
        }catch (IOException e){
            System.out.println(ErrorCode.getErrorText(3));
            System.exit(1);
        }
        blkMngs.add(this);
    }

    public boolean existId(String idStr){
        java.io.File tFile = new File("blockManagers/"+idStr);
        if(tFile.exists()){
            return true;
        }
        return false;
    }
    /*返回bm的id*/
    public Id getId(){
        return id;
    }
    /*获取下一个blockId*/
    public Id getBlockId(){
        String id_count_str = FileUtil.getContents(getCountPath());
        return new BlockId(Long.parseLong(id_count_str));
    }
    public byte[] getBlockData(Block block){
        return FileUtil.getBytes(((BlockIml)block).getBlockDataStr());
    }
    public static BlockManager getBlockManager(Id id){
        for (BlockManager b:
             blkMngs) {
            if(b.getId().getIdStr().equals(id.getIdStr())){
                return b;
            }
        }
        return null;
    }
    /*获取id_count路径名*/
    private String getCountPath(){
        return "blockManagers/"+id.getIdStr()+"/id.count";
    }
    /**/
    private String getBmPath(){
        return "blockManagers/"+id.getIdStr();
    }

    /*根据indexId返回对应blk*/
    @Override
    public Block getBlock(Id indexId) {
        for (Block blk:
             blocks) {
            if(blk.getIndexId().getIdStr().equals(indexId.getIdStr())){
                return blk;
            }
        }
        return null;
    }


    @Override
    public Block newBlock(byte[] b) {
        int size = b.length;
        Block block = newEmptyBlock(size);
        String dataPath = StringOperation.bindStr_data("blockManagers/"+id.getIdStr(), block.getIndexId().getIdStr());
        String metaPath = StringOperation.bindStr_meta("blockManagers/"+id.getIdStr(), block.getIndexId().getIdStr());
        FileUtil.write(dataPath,b);
        byte[] metaContent = ("size:"+StringOperation.ltos(b.length)+"\nchecksum:"+StringOperation.checksum(b)).getBytes();
        FileUtil.write(metaPath,metaContent);
        blocks.add(block);
        return block;
    }

    @Override
    public Block newEmptyBlock(int blockSize) {
        Id blockId = getBlockId();
        Block block = new BlockIml(blockSize,this, blockId);
        String countPath = getCountPath();
        String data = StringOperation.ltos(StringOperation.stol(blockId.getIdStr()) + 1);
        byte[] datas = data.getBytes();
        FileUtil.write(countPath, datas);

        String dataPath = StringOperation.bindStr_data("blockManagers/"+id.getIdStr(), blockId.getIdStr());
        java.io.File dataFile = new File(dataPath);
        String metaPath = StringOperation.bindStr_meta("blockManagers/"+id.getIdStr(), blockId.getIdStr());
        java.io.File metaFile = new File(metaPath);
        try {
            dataFile.createNewFile();
            metaFile.createNewFile();
        }catch (IOException e){
            System.out.println(ErrorCode.getErrorText(4));
            System.exit(1);
        }
        blocks.add(block);
        return block;
    }
}
