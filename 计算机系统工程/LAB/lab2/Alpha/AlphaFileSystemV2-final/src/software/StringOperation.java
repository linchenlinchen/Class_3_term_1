package software;

/*ClassName StringOperation
 *Description
 *Author 2019/10/17
 *Date 2019/10/17 14:51
 *Version 1.0
 */
public class StringOperation {
    public static String bindStr_data(String dir,String blockId){
        return dir+"/"+blockId+".data";
    }
    public static String bindStr_meta(String dir,String blockId){
        return dir+"/"+blockId+".meta";
    }
    public static long stol(String string){
        return Long.parseLong(string);
    }
    public static String ltos(long l){
        return l+"";
    }
    public static byte[][] getSegments(byte[] b,int size){
        int length = b.length;
        int num = (b.length-1)/size + 1;
        byte[][] result = new byte[num][size];
        for (int i = 0; i < length; i++) {
            result[i/size][i%size] = b[i];
        }
        return result;
    }
    public static String bindPartialArr(String[] strings,int beg,int len){
        StringBuilder stringBuilder = new StringBuilder();
        for (int i = beg; i < beg+len; i++) {
            stringBuilder.append(strings[i]);
            stringBuilder.append("\n");
        }
        if(stringBuilder.toString().length()-1>=0){
            stringBuilder.deleteCharAt(stringBuilder.toString().length()-1);
        }

        return stringBuilder.toString();
    }
    /*该函数尚且需要调整*/
    public static long checksum(byte[] bs) {
        long h = bs.length;
        for (byte b: bs) {
            long lb = (long) b;
            h = ((h << 1) | (h >>> 63) | ((lb & 0xc3) << 41) | ((lb & 0xa7) << 12)) + lb * 91871341 + 1821349192;
        }
        return h;
    }
}
