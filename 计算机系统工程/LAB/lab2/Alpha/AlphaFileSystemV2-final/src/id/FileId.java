package id;

import itf.Id;

import java.io.Serializable;

/*ClassName FileId
 *Description
 *Author 2019/10/17
 *Date 2019/10/17 11:24
 *Version 1.0
 */
public class FileId implements Id , Serializable {
    private String field;
    public FileId(String field){
        this.field = field;
    }
    @Override
    public String getIdStr() {
        return field;
    }
}
