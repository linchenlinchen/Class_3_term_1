package ManagerServer;

import itf.File;
import itf.FileManager;
import itf.Id;
import software.FileImpl;
import software.FileUtil;

import java.io.IOException;
import java.io.Serializable;
import java.rmi.RemoteException;
import java.rmi.server.UnicastRemoteObject;

/*ClassName RemoteFileManager
 *Description
 *Author 2019/11/27
 *Date 2019/11/27 16:08
 *Version 1.0
 */
public class RemoteFileManagerImpl extends UnicastRemoteObject implements FMAdapter, Serializable {
    /*attribute*/
    private FileManager fileManager;
    /*constructor*/
    public RemoteFileManagerImpl(FileManager fileManager) throws RemoteException {
        super();
        this.fileManager = fileManager;
    }
    /*method*/
    @Override
    public FileManager getFileManager(){return fileManager;}
    @Override
    public File getFile(Id id){
        return getFileManager().getFile(id);
    }
    @Override
    public void movePos(Id id,int pos){
        if(getFile(id) == null){
            newFile(id);
        }
        getFile(id).move(pos,File.MOVE_HEAD);
    }
    @Override
    public void write(Id id,byte[] data){
        getFile(id).write(data);
    }
    @Override
    /*待改进*/
    public byte[] read(Id id,int length){
        try {
            byte[] data = getFile(id).read(length);
            return data;
        }catch (IOException e){

        }
        return null;
    }
    @Override
    public void newFile(Id id){
        getFileManager().newFile(id);
    }

}
