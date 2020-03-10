package id;

import itf.Id;

import java.io.Serializable;

/*ClassName BlockId
 *Description
 *Author 2019/10/17
 *Date 2019/10/17 11:20
 *Version 1.0
 */
public class BlockId implements Id, Serializable {
    private long indexId;
    public BlockId(long indexId){
        this.indexId = indexId;
    }
    @Override
    public String getIdStr(){
        return indexId+"";
    }
}
