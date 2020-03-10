package software;

import exception.ErrorCode;
import id.BlockId;
import id.FileId;
import itf.*;

import java.io.IOException;
import java.util.Scanner;

public class Main {
    final static int DUPLICATION_NUMBER = 2;
    final static int NUMOFBM = 10;
    final static int NUMOFFM = 10;
    public static void main(String[] args) {
        // write your code here
        /*创建两个默认文件夹*/
        java.io.File file1 = new java.io.File("FileManagers");
        java.io.File file2 = new java.io.File("BlockManagers");
        FileManager[] fileManagers = new FileManager[NUMOFFM];
        BlockManager[] blockManagers = new BlockManager[NUMOFBM];
        if (!file1.exists()) {
            file1.mkdir();
        }
        if (!file2.exists()) {
            file2.mkdir();
        }
        /*创建一个数据集*/
        byte[] data = new byte[3000];
        for (int i = 0; i < 3000; i++) {
            data[i] = (((char) ((int) (Math.random() * 74 + 48))) + "").getBytes()[0];
        }

        /*初始化*/
        /*系统有十个fileManagers*/
        for (int i = 0; i < NUMOFFM; i++) {
            java.io.File file = new java.io.File("fileManagers/fm-" + i);
            if (!file.exists()) {
                file.mkdir();
            }
            fileManagers[i] = new FileManagerIml("fm-"+i);
        }
        /*系统有十个blockManagers*/
        for (int i = 0; i < NUMOFBM; i++) {
            java.io.File file = new java.io.File("blockManagers/bm-" + i);
            if (!file.exists()) {
                file.mkdir();
                blockManagers[i] = new BlockManagerIml("bm-"+i);
            }else {
                blockManagers[i] = new BlockManagerIml("bm-"+i);
                java.io.File[] fs = file.listFiles();
                for (int j = 0; j < fs.length; j++) {
                    String r = fs[j].getPath().replace("\\","/");
                    String head = r.split("\\.")[0];
                    String tail = r.split("\\.")[1];
                    if(tail.equals("data")){
                        int s = FileUtil.getSize(fs[++j].getPath());/*++j是为了指向meta文件并且下一次循环可以直接找到下一个data文件*/
                        Id id = new BlockId(Long.parseLong(head.split("/")[(head.split("/")).length-1]));
                        Block block = new BlockIml(s,blockManagers[i],id);
                        ((BlockManagerIml)blockManagers[i]).blocks.add(block);
                    }
                }
            }
        }

        /**/

        Id fileId = new FileId("test2");
        File file = ((FileManagerIml) fileManagers[1]).newFile((FileId) fileId);
        ((FileImpl) file).write(data);
        alpha_cat(file,3000);
        for (int i = 0; i < NUMOFBM; i++) {
            if(((BlockManagerIml)blockManagers[i]).blocks.size()> 0){
                alpha_hex(((BlockManagerIml)blockManagers[i]).blocks.get(0),256);/*假设有256*/
            }
        }
        alpha_write(file,20);
        Id fileId3 = new FileId("test3");
        File file3 = ((FileManagerIml) fileManagers[1]).newFile((FileId)fileId3);
        alpha_copy(file,file3);
    }
    public static void alpha_cat(File file,int length){
        try {
            file.move(0, File.MOVE_HEAD);
            byte[] result = file.read(length);
            for (int i = 0; i < length; i++) {
                System.out.print((char)(result[i]));
            }
            System.out.print("\n");
        }catch (IOException e){
            System.out.println(ErrorCode.getErrorText(9));
        }
    }
    public static void alpha_hex(Block block,int length){
        byte[] result = FileUtil.getBytes("blockManagers/"+block.getBlockManager().getId().getIdStr()+"/"+block.getIndexId().getIdStr()+".data");
        for (int i = 0; i < result.length; i++) {
            System.out.print(Integer.toHexString(result[i]));
        }
        System.out.print("\n");
    }
    public static void alpha_write(File file,int pos){
        System.out.println("Input your data:");
        Scanner scanner = new Scanner(System.in);
        String data = scanner.nextLine();
        file.move(pos,File.MOVE_HEAD);
        file.write(data.getBytes());
    }
    public static void alpha_copy(File file,File newFile){
        try {
            byte[] b = file.read((int) (file.size()));
            newFile.write(b);
        }catch (IOException e){
            System.out.println(ErrorCode.getErrorText(10));
        }
    }
}
