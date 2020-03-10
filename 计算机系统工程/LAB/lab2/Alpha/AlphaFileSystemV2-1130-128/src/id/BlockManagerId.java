package id;

import itf.Id;

import java.io.Serializable;

/*ClassName BlockManagerId
 *Description
 *Author 2019/10/17
 *Date 2019/10/17 11:21
 *Version 1.0
 */
public class BlockManagerId implements Id, Serializable {
    private String id;
    public BlockManagerId(String id){
        this.id = id;
    }
    @Override
    public String getIdStr(){
        return id;
    }
}
