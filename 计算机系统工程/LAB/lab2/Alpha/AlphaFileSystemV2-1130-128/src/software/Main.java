package software;

import Client.Client;
import exception.ErrorCode;
import id.BlockId;
import id.FileId;
import itf.*;

import java.io.IOException;
import java.util.Scanner;

public class Main {
    public static void main(String[] args){
        /*创建一个数据集*/
        byte[] data = new byte[3000];
        for (int i = 0; i < 3000; i++) {
            data[i] = (((char) ((int) (Math.random() * 74 + 48))) + "").getBytes()[0];
        }
        Client client = new Client();
    }

//    /*test*/
//
//        Id fileId1 = new FileId("test1");
//        File file01 = ((FileManagerIml) fileManagers[1]).newFile((FileId) fileId1);
//        ((FileImpl) file01).write(data);
//        Id fileId2 = new FileId("test2");
//        File file02 = ((FileManagerIml) fileManagers[1]).newFile((FileId) fileId2);
//        ((FileImpl) file02).write(data);
//        alpha_cat(file,3000);
//        for (int i = 0; i < NUMOFBM; i++) {
//            if(((BlockManagerIml)blockManagers[i]).blocks.size()> 0){
//                alpha_hex(((BlockManagerIml)blockManagers[i]).blocks.get(0),256);/*假设有256*/
//            }
//        }
//        alpha_write(file,20);
//        Id fileId3 = new FileId("test3");
//        File file3 = ((FileManagerIml) fileManagers[1]).newFile((FileId)fileId3);
//        alpha_copy(file,file3);
    //}
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
