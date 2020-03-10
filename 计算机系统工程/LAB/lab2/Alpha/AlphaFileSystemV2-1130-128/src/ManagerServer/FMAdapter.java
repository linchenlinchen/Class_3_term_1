package ManagerServer;

import itf.File;
import itf.FileManager;
import itf.Id;

import java.rmi.Remote;
import java.rmi.RemoteException;

public interface FMAdapter extends Remote {
    FileManager getFileManager()throws RemoteException;
    File getFile(Id id)throws RemoteException;
    void movePos(Id id,int pos) throws RemoteException;
    void write(Id id,byte[] data)throws RemoteException;
    byte[] read(Id id,int length)throws RemoteException;
    void newFile(Id id) throws RemoteException;
}
