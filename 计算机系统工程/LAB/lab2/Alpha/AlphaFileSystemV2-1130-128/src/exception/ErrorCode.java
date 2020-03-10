package exception;

import java.util.HashMap;
import java.util.Map;

/*ClassName ErrorCode
 *Description
 *Author 2019/10/17
 *Date 2019/10/17 13:29
 *Version 1.0
 */
public class ErrorCode extends RuntimeException {
    public static final int IO_EXCEPTION = 1;
    public static final int CHECKSUM_CHECK_FAILED = 2;
    public static final int BUILD_DIRECTORY_OF_BM_FAILED = 3;
    public static final int BUILD_FILE_OF_BLOCK_FAILED = 4;
    public static final int BUILD_FILE_OF_FILEMETA_FAILED = 5;
    public static final int GET_CONTENTS_FAILED = 6;
    public static final int WRITE_CONTENTS_FAILED = 7;
    public static final int WRITE_FILEMETA_FAILED = 8;
    public static final int ALPHA_CAT_READ_ERROR = 9;
    public static final int ALPHA_COPY_READ_ERROR = 10;
    public static final int INVALID_SIZE = 11;
    public static final int NOT_FOUND_FILEMANAGER = 12;
    public static final int UNKNOWN = 1000;
    private static final Map<Integer, String> ErrorCodeMap = new HashMap<>();
    private int errorCode;


    static {
        ErrorCodeMap.put(IO_EXCEPTION, "IO exception");
        ErrorCodeMap.put(CHECKSUM_CHECK_FAILED, "block checksum check failed");
        ErrorCodeMap.put(BUILD_DIRECTORY_OF_BM_FAILED,"build directory of block manager failed");
        ErrorCodeMap.put(BUILD_FILE_OF_BLOCK_FAILED,"build file for block failed");
        ErrorCodeMap.put(BUILD_FILE_OF_FILEMETA_FAILED,"build file for file meta failed");
        ErrorCodeMap.put(GET_CONTENTS_FAILED,"get contents failed");
        ErrorCodeMap.put(WRITE_CONTENTS_FAILED,"write contents failed");
        ErrorCodeMap.put(WRITE_FILEMETA_FAILED,"write file meta failed");
        ErrorCodeMap.put(ALPHA_CAT_READ_ERROR,"alpha-cat read error");
        ErrorCodeMap.put(ALPHA_COPY_READ_ERROR,"alpha-copy read error");
        ErrorCodeMap.put(INVALID_SIZE,"error size");
        ErrorCodeMap.put(NOT_FOUND_FILEMANAGER,"can not found file manager");
        ErrorCodeMap.put(UNKNOWN, "unknown");
    }

    public static String getErrorText(int errorCode) {
        return ErrorCodeMap.getOrDefault(errorCode, "invalid");
    }

    public ErrorCode(int errorCode) {
        super(String.format("error code '%d' \"%s\"", errorCode, getErrorText(errorCode)));
        this.errorCode = errorCode;
    }

    public int getErrorCode() {
        return errorCode;
    }
}
