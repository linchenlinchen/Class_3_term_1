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
import java.util.Scanner;
import java.util.regex.Pattern;

import static exception.ErrorCode.BUILD_FILE_OF_FILEMETA_FAILED;
import static exception.ErrorCode.getErrorText;

/*ClassName Client
 *Description This is Client
 *Author 2019/11/23
 *Date 2019/11/23 14:09
 *Version 1.0
 */
public class Client {

}
