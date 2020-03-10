package Client;

import ManagerServer.FMAdapter;
import exception.ErrorCode;
import id.FileId;
import itf.File;
import itf.Id;
import software.FileUtil;

import java.io.IOException;
import java.net.InetSocketAddress;
import java.net.Socket;
import java.rmi.NotBoundException;
import java.rmi.RemoteException;
import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;
import java.util.Arrays;
import java.util.Scanner;
import java.util.regex.Pattern;

/*ClassName FMClient
 *Description
 *Author 2019/11/29
 *Date 2019/11/29 14:55
 *Version 1.0
 */
public class FMClient {
    public static void main(String[] args)throws Exception{
        Registry registry = LocateRegistry.getRegistry("127.0.0.1",8888, (host, port) -> {
            Socket socket = new Socket();
            socket.connect(new InetSocketAddress(host, port), 2000);/*超时*/
            socket.setSoTimeout(2000);
            return socket;
        });
        while (true) {
            try {
                System.out.println("输入指令HEX/CAT/WRITE/COPY:");
                Scanner input = new Scanner(System.in);
                String pattern = input.nextLine();
                pattern = getCommand(pattern, input);
                switch (pattern) {
                    case "HEX":
                        System.out.println("请输入FM名：");
                        String fmName2 = input.nextLine();
                        System.out.println("请输入文件名：");
                        String fileName0 = input.nextLine();
                        System.out.println("请输入游标：");
                        String pos2_str = input.nextLine();
                        int pos2 = getInt(pos2_str,input);
                        System.out.println("请输入字节长度：");
                        String length_str = input.nextLine();
                        int length = getInt(length_str, input);
                        alpha_move(registry,fmName2,fileName0,pos2);
                        alpha_hex(registry, fmName2, fileName0, length);
                        break;
                    case "CAT":
                        System.out.println("请输入FM名：");
                        String fmName = input.nextLine();
                        System.out.println("请输入文件名：");
                        String fileName = input.nextLine();
                        System.out.println("请输入游标：");
                        String pos1_str = input.nextLine();
                        int pos1 = getInt(pos1_str,input);
                        System.out.println("请输入字节长度：");
                        String length_str1 = input.nextLine();
                        int length1 = getInt(length_str1, input);
                        alpha_move(registry,fmName,fileName,pos1);
                        alpha_cat_file(registry, fmName, fileName, length1);
                        break;
                    case "WRITE":
                        System.out.println("请输入FM名：");
                        String fmName1 = input.nextLine();
                        System.out.println("请输入文件名：");
                        String fileName1 = input.nextLine();
                        System.out.println("请移动游标：");
                        String pos_str = input.nextLine();
                        int pos = getInt(pos_str, input);
                        System.out.println("请输入数据：");
                        String data_str = input.nextLine();
                        byte[] data = data_str.getBytes();
                        alpha_move(registry,fmName1,fileName1,pos);
                        alpha_write(registry, fmName1, fileName1, pos, data);
                        break;
                    case "COPY":
                        System.out.println("请输入旧FM名：");
                        String old_fmName = input.nextLine();
                        System.out.println("请输入旧的文件名：");
                        String old_fileName = input.nextLine();
                        System.out.println("请输入新FM名：");
                        String new_fmName = input.nextLine();
                        System.out.println("请输入新的文件名：");
                        String new_fileName = input.nextLine();
                        alpha_copy(registry, old_fmName, old_fileName, new_fmName, new_fileName);
                        break;
                    default:
                        break;
                }

            } catch (NotBoundException e) {
                System.out.println("尊敬的客户，你想要获取的内容尚未启用！请稍后再试\nDear customers, the content you want to get has not been enabled yet! Please try again later");
            } catch (RemoteException e) {
                System.out.println("尊敬的客户，远程连接出现错误，请稍后再试试吧\nDear customer, remote connection error, please try again later");
            }
        }
    }
    private static void alpha_move(Registry registry, String fmName, String fileName,int pos)throws Exception{
        FMAdapter fmAdapter = (FMAdapter)registry.lookup("rmi://localhost:8888/"+fmName);
        Id id = new FileId(fileName);
        fmAdapter.movePos(id,pos);
    }

    private static void alpha_cat_file(Registry registry, String fmName, String fileName, int length)throws Exception{
        FMAdapter fmAdapter = (FMAdapter)registry.lookup("rmi://localhost:8888/"+fmName);
        Id id = new FileId(fileName);
        byte[] result = fmAdapter.read(id,length);
        for (int i = 0; i < result.length; i++) {
            System.out.print(((char)result[i]));
        }
        System.out.println();
    }

    private static void alpha_hex(Registry registry, String fmName, String fileName, int length)throws Exception{
        FMAdapter fmAdapter = (FMAdapter)registry.lookup("rmi://localhost:8888/"+fmName);
        Id id = new FileId(fileName);
        byte[] result = fmAdapter.read(id,length);
        for (byte b : result) {
            System.out.print(Integer.toHexString(b));
        }
        System.out.println();
    }

    private static void alpha_write(Registry registry, String fmName, String fileName, int pos, byte[] data){
        try {
            FMAdapter fmAdapter = (FMAdapter) registry.lookup("rmi://localhost:8888/" + fmName);
            Id id = new FileId(fileName);
            fmAdapter.newFile(id);
            fmAdapter.movePos(id,pos);
            fmAdapter.write(id,data);
        }catch (NotBoundException | NumberFormatException e){
            System.out.println(ErrorCode.getErrorText(ErrorCode.INPUT_ERROR) + "或者" + ErrorCode.getErrorText(ErrorCode.FILE_BROKEN));
        }catch (RemoteException e){
            System.out.println(ErrorCode.getErrorText(ErrorCode.REMOTE_CONNECT_ERROR));
        }
    }

    private static void alpha_copy(Registry registry, String fmName, String fileName, String newFMName, String newFName)throws Exception {
        try {
            FMAdapter fmAdapter = (FMAdapter) registry.lookup("rmi://localhost:8888/" + fmName);
            FMAdapter fmAdapter_new = (FMAdapter) registry.lookup("rmi://localhost:8888/" + newFMName);

            Id id = new FileId(fileName);
            File file = fmAdapter.getFile(id);
            fmAdapter.movePos(id,0);
            byte[] data = fmAdapter.read(id,((int)(file.size())) );

            Id newId = new FileId(newFName);
            fmAdapter_new.newFile(newId);
            fmAdapter_new.write(newId,data);
        } catch (IOException e) {
            System.out.println(ErrorCode.getErrorText(10));
        }catch (NullPointerException e){
            System.out.println("你需要先创建文件才能拷贝。请重试");
        }
    }

    private static boolean isInteger(String str) {
        if(str.equals(""))
            return false;
        Pattern pattern = Pattern.compile("^[-+]?[\\d]*$");
        return pattern.matcher(str).matches();
    }

    private static String getCommand(String pattern, Scanner scanner){
        if("CAT".equals(pattern)|| "HEX".equals(pattern) || "WRITE".equals(pattern) || "COPY".equals(pattern) || "MOVE".equals(pattern)) {
            return pattern;
        }else {
            System.out.println("输入错误，请重试:");
            String newPattern = scanner.nextLine();
            return getCommand(newPattern,scanner);
        }
    }

    private static int getInt(String pattern, Scanner scanner){
        if(isInteger(pattern)){
            return Integer.parseInt(pattern);
        }else {
            System.out.println("请输入数字，请重试：");
            String newPattern  = scanner.nextLine();
            return getInt(newPattern,scanner);
        }
    }
    private void io(){
        FileUtil.writeFileMetaRandom("fileManagers/on", 10, 1,10,new byte[0]);
    }
}
