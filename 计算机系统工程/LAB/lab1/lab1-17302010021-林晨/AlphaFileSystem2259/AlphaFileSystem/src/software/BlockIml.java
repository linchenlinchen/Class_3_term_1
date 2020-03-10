package software;

import itf.Block;
import itf.BlockManager;
import itf.Id;

/*ClassName BlockIml
 *Description
 *Author 2019/10/16
 *Date 2019/10/16 15:38
 *Version 1.0
 */
public class BlockIml implements Block {
    private final int size;
    private Id indexId;
    private BlockManager bm;
    public BlockIml(int size,BlockManager bm,Id id){
        this.size = size;
        this.bm = bm;
        indexId = id;
        FileUtil.write("blockManagers/"+bm.getId().getIdStr()+"/id.count",Integer.parseInt(FileUtil.getContents("blockManagers/"+bm.getId().getIdStr()+"/id.count"))+1+"");
    }

    /*返回本block对应的data文件名*/
    public String getBlockDataStr(){
        return "blockManagers/"+bm.getId().getIdStr()+"/"+indexId.getIdStr()+".data";
    }

    /*返回本block对应的meta文件名*/
    public String getBlockMetaStr(){
        return "blockManagers/"+bm.getId().getIdStr()+"/"+indexId.getIdStr()+".meta";
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
