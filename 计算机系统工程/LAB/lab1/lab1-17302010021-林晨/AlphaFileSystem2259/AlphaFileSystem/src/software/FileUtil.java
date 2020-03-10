package software;

import exception.ErrorCode;
import itf.Id;
import org.omg.PortableInterceptor.INACTIVE;

import java.io.*;
import java.util.Arrays;

/*ClassName FileUtil
 *Description
 *Author 2019/10/16
 *Date 2019/10/16 16:03
 *Version 1.0
 */
public class FileUtil {
    static String getContents(String path){
        java.io.File file = new java.io.File(path);
        FileReader reader;
        BufferedReader bReader;
        StringBuilder sb = new StringBuilder();
        try {
            reader = new FileReader(file);
            bReader = new BufferedReader(reader);
            String s;
            while ((s = bReader.readLine()) != null) {
                sb.append(s);
                sb.append("\n");
            }
            sb.deleteCharAt(sb.toString().length()-1);
            bReader.close();
        }catch (Exception e){
            System.out.println(ErrorCode.getErrorText(6));
        }
        return sb.toString();
    }

    public static byte[] getBytes(String path){
        return getContents(path).getBytes();
    }
    public static long getL(String path){
        return getBytes(path).length;
    }
    public static String[][] getUnchangedIds(String path,int num){
        String content = getContents(path);
        String[] raw = content.split("\n");
        String[] raw_result = new String[num];
        System.arraycopy(raw,3,raw_result,0,num);
        String[][] result = new String[num][2];
        for (int i = 0; i < num; i++) {
            result[i] = raw_result[i].split(",");
        }
        return result;
    }
    public static long getChecksum(String path){
        String s = getContents(path);
        long checksum = Long.parseLong(s.split("\n")[1].split(":")[1]);
        return checksum;
    }
    public static int getSize(String path){
        String s = getContents(path);
        int size = Integer.parseInt(s.split("\n")[0].split(":")[1]);
        return size;
    }
    public static void write(String path,byte[] contents){
        java.io.File file = new File(path);
        BufferedOutputStream bos = null;
        FileOutputStream fos = null;
        try {
            fos = new FileOutputStream(file);
            bos = new BufferedOutputStream(fos);
            bos.write(contents);
            bos.flush();
            bos.close();
        }catch (IOException e){
            System.out.println(ErrorCode.getErrorText(7));
        }
    }
    public static void write(String path,String contents){
        java.io.File file = new File(path);
        BufferedOutputStream bos = null;
        FileOutputStream fos = null;
        try {
            fos = new FileOutputStream(file);
            bos = new BufferedOutputStream(fos);
            bos.write(contents.getBytes());
            bos.flush();
            bos.close();
        }catch (IOException e){
            System.out.println(ErrorCode.getErrorText(7));
        }
    }
    public static void writeFileMeta(String path, long size, int blkSize,long pos, String ids){
        try {
            BufferedWriter out = new BufferedWriter(new FileWriter(path));
            out.write("size:"+size+"\n");
            out.write("block size:"+blkSize+"\n");
            out.write("pos:"+pos+"\n");
            out.write("logic block:\n");
            out.write(ids);
            out.flush();
            out.close();
        }catch (IOException e){
            System.out.println(ErrorCode.getErrorText(8));
        }
    }
    public static void writeFileMeta(String path, long size, int blkSize,long pos, byte[] ids){
        try {
            BufferedWriter out = new BufferedWriter(new FileWriter(path));
            out.write("size:"+size+"\n");
            out.write("block size:"+blkSize+"\n");
            out.write("pos:"+pos+"\n");
            out.write("logic block:\n");
            for (int i = 0; i < ids.length; i++) {
                out.write(ids[i]);
            }
            out.flush();
            out.close();
        }catch (IOException e){
            System.out.println(ErrorCode.getErrorText(8));
        }
    }
    public static long getSizeOfMeta(String path){
        return Long.parseLong(FileUtil.getContents(path).split("\n")[0].split(":")[1]);
    }
    public static int getBlockSizeOfMeta(String path){
        return Integer.parseInt(FileUtil.getContents(path).split("\n")[1].split(":")[1]);
    }
    public static long getPosOfMeta(String path){
        return Long.parseLong(FileUtil.getContents(path).split("\n")[2].split(":")[1]);
    }
    public static String getLogicOfMeta(String path){
        StringBuilder stringBuilder = new StringBuilder();
        String rslt = getContents(path);
        String[] rsltArr = rslt.split("\n");
        for (int i = FileImpl.offsetOfMeta+1; i < rsltArr.length; i++) {
            stringBuilder.append(rsltArr[i]);
            stringBuilder.append("\n");
        }
        stringBuilder.deleteCharAt(stringBuilder.toString().length()-1);
        return stringBuilder.toString();
    }
//    public static String getBlockPathOfMeta(String path){
//        String[] line = FileUtil.getContents(path).split("\n");
//        int numOfLine = line.length;
//        for (int i = 4; i < numOfLine; i++) {
//            String[] l = line[i].split(";");
//            for (int j = 0; j < Main.DUPLICATION_NUMBER; j++) {
//
//            }
//        }
//    }
    public static byte[] getPartBytes(String path,int end){
        byte[] result = new byte[end];
        System.arraycopy(getBytes(path),0,result,0,end);
        return result;
    }

    static String deleteLastedLine(String content){
        String[] lines = content.split("\n");
        String[] resultArr = new String[lines.length-1];
        System.arraycopy(lines,0,resultArr,0,resultArr.length);
        StringBuilder stringBuilder = new StringBuilder();
        for (String line:
                resultArr) {
            stringBuilder.append(line);
            stringBuilder.append("\n");
        }
        stringBuilder.deleteCharAt(stringBuilder.toString().length()-1);
        return stringBuilder.toString();
    }
}
