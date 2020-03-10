package ManagerServer;

import com.sun.xml.internal.messaging.saaj.util.FinalArrayList;
import exception.ErrorCode;
import id.FileId;
import itf.BlockManager;
import itf.File;
import itf.FileManager;
import itf.Id;
import software.BlockManagerIml;
import software.FileImpl;
import software.FileManagerIml;

import java.io.Serializable;
import java.net.InetSocketAddress;
import java.net.Socket;
import java.rmi.AlreadyBoundException;
import java.rmi.NotBoundException;
import java.rmi.RemoteException;
import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;
import java.rmi.server.UnicastRemoteObject;
import java.util.ArrayList;
import java.util.Scanner;
import static ManagerServer.Server.NUMOFFM;
/*ClassName FileManagerServer
 *Description This is FileManagerServer
 *Author 2019/11/22
 *Date 2019/11/22 19:37
 *Version 1.0
 */
public class FileManagerServer implements Serializable{
    /*存储所以远程的FM*/
    private static ArrayList<RemoteFileManagerImpl> fileManagerArrayList = new FinalArrayList();

    public FileManagerServer(){}

    public static RemoteFileManagerImpl findRFM(String name)throws ErrorCode {
        for (RemoteFileManagerImpl rfm:
             fileManagerArrayList) {
            if(rfm.getFileManager().getFid().getIdStr().equals(name)){
                return rfm;
            }
        }
        throw new ErrorCode(ErrorCode.NOT_FOUND_FILEMANAGER);
    }

    /*从命令行获取服务器指令*/
    public static String getCommand(String pattern, Scanner scanner){
        if(pattern.equals("wake")) {
            return pattern;
        }else if(pattern.equals("sleep")){
            return pattern;
        }else if(pattern.equals("wake bm")){
            return pattern;
        }else if(pattern.equals("sleep bm")){
            return pattern;
        } else {
            System.out.println("Error input, again:");
            String newPattern = scanner.nextLine();
            return getCommand(newPattern,scanner);
        }
    }
    /*生成-启动-唤醒FM并放入绑定端口.对于已经存在的FM不创建目录，对于不存在的FM创建目录*/
    public static boolean wakeUp(String name) throws Exception{
        try {
            FMAdapter fmAdapter = findRFM(name);
            Registry registry = LocateRegistry.getRegistry("127.0.0.1", 8888);
            registry.rebind("rmi://localhost:8888/" + name, fmAdapter);/*需要序列化*/
        }catch (RemoteException e) {
            System.out.println("创建远程对象发生异常！");
            return false;
            //e.printStackTrace();
        } catch (ErrorCode e){
            switch (e.getErrorCode()){
                case ErrorCode.NOT_FOUND_FILEMANAGER:
                    System.out.println(ErrorCode.getErrorText(ErrorCode.NOT_FOUND_FILEMANAGER));
                    return false;
            }
        }
        System.out.println("Success wake up "+name);
        return true;
    }

    public static boolean down(String fmName){
        try {
            Registry registry = LocateRegistry.getRegistry("127.0.0.1", 8888);
            registry.unbind("rmi://localhost:8888/" + fmName);/*需要序列化*/
        }catch (RemoteException e) {
            System.out.println("创建远程对象发生异常！");
//            e.printStackTrace();
            return false;
        }catch (NotBoundException e){
            System.out.println("发生异常,请输入正确的file manager名字！");
//            e.printStackTrace();
            return false;
        }
        System.out.println("Success make down "+fmName);
        return true;
    }

    public static void init()throws Exception{
        FileManager[] fileManagers = new FileManager[NUMOFFM];
        for (int i = 0; i < NUMOFFM; i++) {
            java.io.File file = new java.io.File("fileManagers/fm-" + i);
            if (!file.exists()) {
                file.mkdir();
                fileManagers[i] = new FileManagerIml("fm-" + i);
            } else {
                fileManagers[i] = new FileManagerIml("fm-" + i);
                java.io.File[] fs = file.listFiles();
                int fs_length = fs.length;
                for (int j = 0; j < fs_length; j++) {
                    String r = fs[j].getPath().replace("\\", "/");
                    String head = r.split("\\.")[0];
                    String tail = r.split("\\.")[1];
                    if (tail.equals("meta")) {
                        Id id = new FileId(head.split("/")[(head.split("/")).length - 1]);
                        File alpha_file = new FileImpl(-1, fileManagers[i], id);/*-1表示文件已存在，可以自动读取blksize*/
                    }
                }
            }
        }
        for (int i = 0; i < NUMOFFM; i++) {
            fileManagerArrayList.add(new RemoteFileManagerImpl(fileManagers[i]));
            wakeUp(fileManagers[i].getFid().getIdStr());
        }
    }

    public static void main(String[] args)throws Exception{
        init();
        BlockManagerServer.init();
        /*获取指令和操作对象名字*/
        while (true) {
            System.out.println("Input FileManager command \"wake\"/\"sleep\" or BlockManager command \"wake bm\"/\"sleep bm\":");
            Scanner scanner = new Scanner(System.in);
            String command = scanner.nextLine();
            command = getCommand(command, scanner);
            if(command.equals("wake")){
                System.out.println("As FileManagerServer, wake up FileManager named :");
                String name = scanner.nextLine();
                wakeUp(name);
            }else if(command.equals("sleep")){
                System.out.println("As FileManagerServer, sleep FileManager named :");
                String name = scanner.nextLine();
                down(name);
            }else if(command.equals("wake bm")){
                System.out.println("As FileManagerServer, wake up BlockManager named :");
                String name = scanner.nextLine();
                BlockManagerServer.wakeUp(name);
            }else {
                System.out.println("As FileManagerServer, sleep BlockManager named :");
                String name = scanner.nextLine();
                BlockManagerServer.down(name);
            }
        }
    }


}
