package ManagerServer;

import itf.Block;
import itf.BlockManager;
import itf.Id;

import java.rmi.Remote;
import java.rmi.RemoteException;

public interface BMAdapter extends Remote {
    BlockManager getBlockManager() throws RemoteException;
    Block getBlock(Id id) throws RemoteException;
    byte[] read(Id id)throws RemoteException;
}
