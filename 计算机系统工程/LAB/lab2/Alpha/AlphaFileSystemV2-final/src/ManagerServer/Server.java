package ManagerServer;

import id.BlockId;
import id.FileId;
import itf.*;
import software.*;

import java.util.ArrayList;

/*ClassName Server
 *Description
 *Author 2019/11/23
 *Date 2019/11/23 18:38
 *Version 1.0
 */
public class Server {
    public final static int DUPLICATION_NUMBER = 2;
    public final static int NUMOFBM = 10;
    public final static int NUMOFFM = 10;
//    ArrayList<FileManagerServer> fileManagerServerArrayList = new ArrayList<>();
//    ArrayList<BlockManagerServer> blockManagerServerArrayList = new ArrayList<>();
//
//    public static void main(String[] args) {
//        // write your code here
//        /*创建两个默认文件夹*/
//        java.io.File file1 = new java.io.File("FileManagers");
//        java.io.File file2 = new java.io.File("BlockManagers");
//        FileManager[] fileManagers = new FileManager[NUMOFFM];
//        BlockManager[] blockManagers = new BlockManager[NUMOFBM];
//        if (!file1.exists()) {
//            file1.mkdir();
//        }
//        if (!file2.exists()) {
//            file2.mkdir();
//        }
//        /*创建一个数据集*/
//        byte[] data = new byte[3000];
//        for (int i = 0; i < 3000; i++) {
//            data[i] = (((char) ((int) (Math.random() * 74 + 48))) + "").getBytes()[0];
//        }
//
//        /*初始化*/
//        /*系统有十个blockManagers*/
//        for (int i = 0; i < NUMOFBM; i++) {
//            java.io.File file = new java.io.File("blockManagers/bm-" + i);
//            if (!file.exists()) {
//                file.mkdir();
//                blockManagers[i] = new BlockManagerIml("bm-" + i);
//            } else {
//                blockManagers[i] = new BlockManagerIml("bm-" + i);
//                java.io.File[] fs = file.listFiles();
//                int fs_length = fs.length;
//                for (int j = 0; j < fs_length; j++) {
//                    String r = fs[j].getPath().replace("\\", "/");
//                    String head = r.split("\\.")[0];
//                    String tail = r.split("\\.")[1];
//                    if (tail.equals("data")) {
//                        int s = FileUtil.getSize(fs[++j].getPath());/*++j是为了指向meta文件并且下一次循环可以直接找到下一个data文件*/
//                        Id id = new BlockId(Long.parseLong(head.split("/")[(head.split("/")).length - 1]));
//                        Block block = new BlockIml(s, blockManagers[i], id);
//                        ((BlockIml) block).setData(FileUtil.getBytes(((BlockIml) block).getBlockDataStr()));
//                        ((BlockIml) block).setMeta(FileUtil.getBlockMeta(((BlockIml) block).getBlockMetaStr()));
//                        ((BlockManagerIml) blockManagers[i]).blocks.add(block);
//                    }
//                }
//            }
//        }
//        /*系统有十个fileManagers*/
//        for (int i = 0; i < NUMOFFM; i++) {
//            java.io.File file = new java.io.File("fileManagers/fm-" + i);
//            if (!file.exists()) {
//                file.mkdir();
//                fileManagers[i] = new FileManagerIml("fm-" + i);
//            } else {
//                fileManagers[i] = new FileManagerIml("fm-" + i);
//                java.io.File[] fs = file.listFiles();
//                int fs_length = fs.length;
//                for (int j = 0; j < fs_length; j++) {
//                    String r = fs[j].getPath().replace("\\", "/");
//                    String head = r.split("\\.")[0];
//                    String tail = r.split("\\.")[1];
//                    if (tail.equals("meta")) {
//                        Id id = new FileId(head.split("/")[(head.split("/")).length - 1]);
//                        File alpha_file = new FileImpl(-1, fileManagers[i], id);/*-1表示文件已存在，可以自动读取blksize*/
//                    }
//                }
//            }
//        }
//
//        /*test*/
//
//        Id fileId1 = new FileId("test1");
//        File file01 = ((FileManagerIml) fileManagers[1]).newFile((FileId) fileId1);
//        ((FileImpl) file01).write(data);
//        Id fileId2 = new FileId("test2");
//        File file02 = ((FileManagerIml) fileManagers[1]).newFile((FileId) fileId2);
//        ((FileImpl) file02).write(data);
//    }
//    public void pushFMS(FileManagerServer fileManagerServer){
//        fileManagerServerArrayList.add(fileManagerServer);
//    }
//    public void removeFMS(Id id){
//        for (FileManagerServer fms:
//             fileManagerServerArrayList) {
//            if(id.getIdStr().equals(fms.getFileManager().getFid().getIdStr())){
//                fileManagerServerArrayList.remove(fms);
//            }
//        }
//    }
//    public boolean hasFMS(Id id){
//        for (FileManagerServer fms:
//                fileManagerServerArrayList) {
//            if(id.getIdStr().equals(fms.getFileManager().getFid().getIdStr())){
//                return true;
//            }
//        }
//        return false;
//    }
//    public FileManagerServer getFMS(Id id){
//        for (FileManagerServer fms:
//                fileManagerServerArrayList) {
//            if(id.getIdStr().equals(fms.getFileManager().getFid().getIdStr())){
//                return fms;
//            }
//        }
//        /*需要异常处理*/
//        return null;
//    }
//
//    public void pushBMS(BlockManagerServer blockManagerServer){
//        blockManagerServerArrayList.add(blockManagerServer);
//    }
//    public void removeBMS(Id id){
//        for (BlockManagerServer bms:
//             blockManagerServerArrayList) {
//            if(id.getIdStr().equals(bms.getBlockManager().getId().getIdStr())){
//                blockManagerServerArrayList.remove(bms);
//            }
//        }
//    }
//    public boolean hasBMS(Id id){
//        for (BlockManagerServer bms:
//                blockManagerServerArrayList) {
//            if(id.getIdStr().equals(bms.getBlockManager().getId().getIdStr())){
//                return true;
//            }
//        }
//        return false;
//    }
//    public BlockManagerServer getBMS(Id id){
//        for (BlockManagerServer bms:
//                blockManagerServerArrayList) {
//            if(id.getIdStr().equals(bms.getBlockManager().getId().getIdStr())){
//                return bms;
//            }
//        }
//        /*需要异常处理*/
//        return null;
//    }
}
