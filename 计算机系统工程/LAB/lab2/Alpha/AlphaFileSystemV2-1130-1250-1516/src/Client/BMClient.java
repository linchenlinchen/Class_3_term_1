package Client;

import ManagerServer.BMAdapter;
import ManagerServer.FMAdapter;
import exception.ErrorCode;
import id.BlockId;
import id.FileId;
import itf.Block;
import itf.File;
import itf.Id;

import java.io.IOException;
import java.net.InetSocketAddress;
import java.net.Socket;
import java.rmi.NotBoundException;
import java.rmi.RemoteException;
import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;
import java.util.Scanner;
import java.util.regex.Pattern;

import static exception.ErrorCode.BUILD_FILE_OF_FILEMETA_FAILED;
import static exception.ErrorCode.getErrorText;

/*ClassName BMClient
 *Description
 *Author 2019/11/29
 *Date 2019/11/29 14:55
 *Version 1.0
 */
public class BMClient {
    public static Map<String,String> map2 = new HashMap<>();
    public static void main(String[] args)throws Exception{
        Registry registry = LocateRegistry.getRegistry("127.0.0.1",1099, (host, port) -> {
            Socket socket = new Socket();
            socket.connect(new InetSocketAddress(host, port), 2000);/*超时*/
            return socket;
        });
            while (true) {
                try {
                    System.out.println("输入指令HEX/CAT:");
                    Scanner input = new Scanner(System.in);
                    String pattern = input.nextLine();
                    pattern = getCommand(pattern, input);
                    switch (pattern) {
                        case "HEX":
                            System.out.println("请输入BM名：");
                            String bmName = input.nextLine();
                            System.out.println("请输入块号：");
                            String blockIndex_str = input.nextLine();
                            int blockIndex = getInt(blockIndex_str, input);
                            System.out.println("请输入字节长度：");
                            String length_str = input.nextLine();
                            int length = getInt(length_str, input);
                            alpha_hex(registry, bmName, blockIndex, length);
                            break;
                        case "CAT":
                            System.out.println("请输入BM名：");
                            String bmName1 = input.nextLine();
                            System.out.println("请输入块名：");
                            String blk = input.nextLine();
                            long blkIndex = getInt(blk,input);
                            alpha_cat_block(registry, bmName1, blkIndex);
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

    public static String getCommand(String pattern, Scanner scanner){
        if("CAT".equals(pattern)|| "HEX".equals(pattern)) {
            return pattern;
        }else {
            System.out.println("输入错误，请重试:");
            String newPattern = scanner.nextLine();
            return getCommand(newPattern,scanner);
        }
    }

    public static int getInt(String pattern, Scanner scanner){
        if(isInteger(pattern)){
            return Integer.parseInt(pattern);
        }else {
            System.out.println("请输入数字，请重试：");
            String newPattern  = scanner.nextLine();
            return getInt(newPattern,scanner);
        }
    }

    public static void alpha_cat_block(Registry registry,String bmName,long blkName)throws Exception{
        BMAdapter bmAdapter = (BMAdapter)registry.lookup("rmi://localhost:1099/"+bmName);
        for (String s:
             map2.keySet()) {
            if(s.equals(bmName+"/"+blkName)){
                System.out.print(map2.get(s));
                System.out.println();
                return;
            }
        }
        /*如果没有在bm buffer*/
        Id id = new BlockId(blkName);
        byte[] result = bmAdapter.read(id);
        map2.put(bmName+"/"+blkName, Arrays.toString(result));
        if(result.length == 0){
            System.out.println("您寻找的block可能不存在或者没有内容。");
        }
        for (int i = 0; i < result.length; i++) {
            System.out.print((char)result[i]);
        }
        System.out.println();
    }

    public static void alpha_hex(Registry registry,String BMName,int blockIndex,int length)throws Exception{
        BMAdapter bmAdapter = (BMAdapter) registry.lookup("rmi://localhost:1099/"+BMName);
        for (String s:
                map2.keySet()) {
            if(s.equals(BMName+"/"+blockIndex)){
                byte[] data = map2.get(s).getBytes();
                for (int i = 0; i < data.length; i++) {
                    System.out.print(Integer.toHexString(data[i]));
                }
                System.out.println();
                return;
            }
        }
        Id id = new BlockId(blockIndex);
        byte[] data = bmAdapter.read(id);
        map2.put(BMName+"/"+blockIndex, Arrays.toString(data));
        if(data.length == 0){
            System.out.println("您寻找的block可能不存在或者没有内容");
        }
        length = length>data.length?data.length:length;
        for (int i = 0; i < length; i++) {
            System.out.print(Integer.toHexString(data[i]));
        }
        System.out.println();
    }

    private static boolean isInteger(String str) {
        Pattern pattern = Pattern.compile("^[-\\+]?[\\d]*$");
        return pattern.matcher(str).matches();
    }
}
