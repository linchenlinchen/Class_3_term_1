package ManagerServer;

import id.BlockId;
import itf.Block;
import itf.BlockManager;
import itf.Id;
import software.BlockIml;
import software.BlockManagerIml;
import software.FileUtil;

import java.io.Serializable;
import java.rmi.*;
import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.Scanner;

import static ManagerServer.Server.NUMOFBM;
import static java.lang.Thread.sleep;

/*ClassName BlockManagerServer
 *Description This is blockmanagerServer
 *Author 2019/11/22
 *Date 2019/11/22 19:37
 *Version 1.0
 */
public class BlockManagerServer implements Serializable {
    /*attribute*/
    public static Map<String,String> map1 = new HashMap<>();
    public static ArrayList<RemoteBlockManagerIml> rawBlockManagerArrayList = new ArrayList<>();
    /*constructor*/
    protected BlockManagerServer(){
    }

    /*method*/
    /*异常未处理*/
    public static RemoteBlockManagerIml findRBM(String name){
        for (RemoteBlockManagerIml rbm:
             rawBlockManagerArrayList) {
            if(rbm.getBlockManager().getId().getIdStr().equals(name)){
                return rbm;
            }
        }
        return null;
    }

    public static String getCommand(String pattern,Scanner scanner){
        if(pattern.equals("wake")) {
            return pattern;
        }else if(pattern.equals("sleep")){
            return pattern;
        }else {
            System.out.println("Error input, again:");
            String newPattern = scanner.nextLine();
            return getCommand(newPattern,scanner);
        }
    }

    /*未处理异常*/
    public static void main(String[] args) throws Exception {
        init();
        /*获取指令和操作对象名字*/
        while (true) {
            System.out.println("Input BlockManager command wake/sleep:");
            Scanner scanner = new Scanner(System.in);
            String command = scanner.nextLine();
            command = getCommand(command, scanner);
            if(command.equals("wake")){
                System.out.println("As BlockManagerServer, wake up blockManager named :");
                String name = scanner.nextLine();
                wakeUp(name);
            }else{
                System.out.println("As BlockManagerServer, sleep blockManager named :");
                String name = scanner.nextLine();
                down(name);
            }
        }
    }
    /*初始化，生成RawBM并加入列表*/
    static void init() throws Exception{
        /*生成已有BlockManager*/
        BlockManager[] blockManagers = new BlockManager[NUMOFBM];
        for (int i = 0; i < NUMOFBM; i++) {
            java.io.File file = new java.io.File("blockManagers/bm-" + i);
            if (!file.exists()) {
                file.mkdir();
                blockManagers[i] = new BlockManagerIml("bm-" + i);
            } else {
                blockManagers[i] = new BlockManagerIml("bm-" + i);
                java.io.File[] fs = file.listFiles();
                int fs_length = fs.length;
                for (int j = 0; j < fs_length; j++) {
                    String r = fs[j].getPath().replace("\\", "/");
                    String head = r.split("\\.")[0];
                    String tail = r.split("\\.")[1];
                    if (tail.equals("data")) {
                        int s = FileUtil.getSize(fs[++j].getPath());/*++j是为了指向meta文件并且下一次循环可以直接找到下一个data文件*/
                        Id id = new BlockId(Long.parseLong(head.split("/")[(head.split("/")).length - 1]));
                        Block block = new BlockIml(s, blockManagers[i], id);
                        ((BlockIml) block).setData(FileUtil.getBytes(((BlockIml) block).getBlockDataStr()));
                        ((BlockIml) block).setMeta(FileUtil.getBlockMeta(((BlockIml) block).getBlockMetaStr()));
                        ((BlockManagerIml) blockManagers[i]).blocks.add(block);

                    }
                }
            }
        }
        for (int i = 0; i < NUMOFBM; i++) {
            rawBlockManagerArrayList.add(new RemoteBlockManagerIml(blockManagers[i]));
            wakeUp(blockManagers[i].getId().getIdStr());
        }

    }
    static void wakeUp(String name){
        BMAdapter bmAdapter= findRBM(name);
        if(bmAdapter == null){
            System.out.println("未发现该block manager，请核查。");
            return;
        }

        try {
            Registry registry = LocateRegistry.getRegistry("127.0.0.1", 1099);
            registry.rebind("rmi://localhost:1099/" + name, bmAdapter);/*需要序列化*/
        }catch (RemoteException e) {
            System.out.println("创建远程对象发生异常，请确保已经打开注册服务器。");
            return;
        }
        System.out.println("成功启动block manager named： "+name+"。");
    }
    public static boolean down(String name)throws Exception{
        try {
            Registry registry = LocateRegistry.getRegistry("127.0.0.1", 1099);
            registry.unbind("rmi://localhost:1099/" + name);/*需要序列化*/
        }catch (RemoteException e) {
            System.out.println("创建远程对象发生异常！");
            e.printStackTrace();
            return false;
        }catch (NotBoundException e){
            System.out.println("发生异常！");
            e.printStackTrace();
            return false;
        }
        System.out.println("Success make down "+name);
        return true;
    }
}
