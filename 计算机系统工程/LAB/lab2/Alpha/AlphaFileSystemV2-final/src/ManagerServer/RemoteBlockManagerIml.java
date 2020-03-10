package ManagerServer;

import itf.Block;
import itf.BlockManager;
import itf.Id;
import software.BlockIml;
import software.FileUtil;
import software.StringOperation;

import java.io.Serializable;
import java.rmi.RemoteException;
import java.rmi.server.UnicastRemoteObject;
import java.util.Arrays;

/*ClassName RemoteBlockManagerIml
 *Description
 *Author 2019/11/27
 *Date 2019/11/27 16:08
 *Version 1.0
 */
public class RemoteBlockManagerIml extends UnicastRemoteObject implements BMAdapter, Serializable {
    /*attribute*/
    private BlockManager blockManager;
    /*constructor*/
    public RemoteBlockManagerIml(BlockManager blockManager) throws RemoteException {
        super();
        this.blockManager = blockManager;
    }
    /*method*/
    @Override
    public BlockManager getBlockManager(){return blockManager;}
    @Override
    public Block getBlock(Id id){
        return blockManager.getBlock(id);
    }
//    @Override
//    public void write(Id id,byte[] data){
//        /*①通过block找到file，通过file修改游标。然后调用write*/
//        getBlock(id)
//    }
//    @Override
//    public Block newEmptyBlock(int blockSize){
//        return blockManager.newEmptyBlock(blockSize);
//    }
//    @Override
//    public Block newBlock(byte[] b){
//        return blockManager.newBlock(b);
//    }
    @Override
    public byte[] read(Id id){
        if(getBlock(id) == null){
            return new byte[0];
        }
        for (String s:
             BlockManagerServer.map1.keySet()) {
            if(s.equals(blockManager.getId().getIdStr()+"/"+id.getIdStr()) &&
                    StringOperation.checksum(BlockManagerServer.map1.get(s).getBytes())== FileUtil.getChecksum(((BlockIml)(blockManager.getBlock(id))).getBlockMetaStr())) {
                return BlockManagerServer.map1.get(s).getBytes();/*bm服务器端使用buffer*/
            }
        }
        byte[] data = getBlock(id).read();
        BlockManagerServer.map1.put(blockManager.getId().getIdStr()+"/"+id.getIdStr(), Arrays.toString(data));/*bm服务器端加入buffer*/
        return data;
    }
}
