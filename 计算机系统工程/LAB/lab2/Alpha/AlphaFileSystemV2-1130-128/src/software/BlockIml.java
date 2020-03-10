package software;

import itf.Block;
import itf.BlockManager;
import itf.Id;

import java.io.Serializable;

/*ClassName BlockIml
 *Description
 *Author 2019/10/16
 *Date 2019/10/16 15:38
 *Version 1.0
 */
public class BlockIml implements Block , Serializable {
    private final int size;
    private Id indexId;
    private byte[] data;
    private String[] meta = new String[2];
    private BlockManager bm;
    public BlockIml(int size,BlockManager bm,Id id){
        this.size = size;
        this.bm = bm;
        indexId = id;
        data = new byte[size];
        meta[0] = "blockManagers/"+bm.getId().getIdStr()+"/id.count";
        meta[1] = Integer.parseInt(FileUtil.getContents("blockManagers/"+bm.getId().getIdStr()+"/id.count"))+1+"";
        FileUtil.write(meta[0],meta[1]);
    }

    /*返回本block对应的data文件名*/
    public String getBlockDataStr(){
        return "blockManagers/"+bm.getId().getIdStr()+"/"+indexId.getIdStr()+".data";
    }
    /*返回本block对应的data内容*/
    public byte[] getData(){return data;}

    /*返回本block对应的meta文件名*/
    public String getBlockMetaStr(){
        return "blockManagers/"+bm.getId().getIdStr()+"/"+indexId.getIdStr()+".meta";
    }
    /*返回本block对应*/
    public String[] getMeta(){return meta;}


    public void setData(byte[] data){
        this.data = data;
        FileUtil.write(getBlockDataStr(),data);
    }
    public void setMeta(String[] meta){
        this.meta = meta;
        FileUtil.write(getBlockMetaStr(),meta[0]+"\n"+meta[1]);
    }
    @Override
    public Id getIndexId() {
        return indexId;
    }

    @Override
    public BlockManager getBlockManager() {
        return bm;
    }

    @Override
    public byte[] read() {
        return FileUtil.getBytes(getBlockDataStr());
    }

    @Override
    public int blockSize() {
        return size;
    }


}
