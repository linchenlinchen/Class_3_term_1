package software;

import id.FileManagerId;
import itf.File;
import itf.FileManager;
import itf.Id;

import java.util.ArrayList;

/*ClassName FileManagerIml
 *Description
 *Author 2019/10/19
 *Date 2019/10/19 11:53
 *Version 1.0
 */
public class FileManagerIml implements FileManager {
    private Id fileManagerId;
    private static ArrayList<File> files = new ArrayList<>();
    private static ArrayList<FileManager> fileManagers = new ArrayList<>();

    /*constructor*/
    public FileManagerIml(String fmId){
        java.io.File file = new java.io.File("fileManagers/"+fmId);
        fileManagerId = new FileManagerId(fmId);
        fileManagers.add(this);
    }

    @Override
    public Id getFid() {
        return fileManagerId;
    }

    @Override
    public File getFile(Id fileId) {
        int len = files.size();
        for (int i = 0; i < len; i++) {
            if(files.get(i).getFileId().getIdStr().equals(fileId.getIdStr())){
                return files.get(i);
            }
        }
        return null;
    }

    @Override
    public File newFile(Id fileId) {
        if(getFile(fileId) == null){
            File file = new FileImpl(256,this,fileId);
            return file;
        }
        return null;
    }
}
