package ManagerServer;

/*ClassName RegisterServer
 *Description
 *Author 2019/11/24
 *Date 2019/11/24 14:24
 *Version 1.0
 */

import java.rmi.RemoteException;
import java.rmi.registry.LocateRegistry;
import java.util.concurrent.CountDownLatch;

/*ClassName RegisterServer
 *Description
 *Author 2019/11/23
 *Date 2019/11/23 20:59
 *Version 1.0
 */
public class RegisterServer {
    public static void main(String[] args) throws InterruptedException{
        try {
            System.setProperty("sun.rmi.transport.tcp.responseTimeout", "2000");
            System.setProperty("sun.rmi.transport.tcp.readTimeout", "2000");
            System.setProperty("sun.rmi.transport.connectionTimeout", "2000");
            System.setProperty("sun.rmi.transport.proxy.connectTimeout", "2000");
            System.setProperty("sun.rmi.transport.tcp.handshakeTimeout", "2000");
            LocateRegistry.createRegistry(8888); //Registry使用8000端口
            System.setProperty("java.rmi.server.hostname","127.0.0.1");
            //System.setProperty("sum.rmi.transport.tcp.responseTimeout","500");
        } catch (RemoteException e) {
            e.printStackTrace();
        }
        CountDownLatch latch=new CountDownLatch(1);
        latch.await();  //挂起主线程，否则应用会退出
    }
}

