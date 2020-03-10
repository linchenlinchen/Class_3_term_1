package id;

import itf.Id;

import java.io.Serializable;

/*ClassName FileManagerId
 *Description
 *Author 2019/10/17
 *Date 2019/10/17 11:26
 *Version 1.0
 */
public class FileManagerId implements Id , Serializable {
    private String fId;
    public FileManagerId(String fId){
        this.fId = fId;
    }
    @Override
    public String getIdStr() {
        return fId;
    }
}
