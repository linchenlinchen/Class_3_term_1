package itf;

public interface FileManager {
    Id getFid();
    File getFile(Id fileId);
    File newFile(Id fileId);
}
