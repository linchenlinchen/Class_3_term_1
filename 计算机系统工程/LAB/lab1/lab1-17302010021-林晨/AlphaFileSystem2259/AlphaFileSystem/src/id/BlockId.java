package id;

import itf.Id;

/*ClassName BlockId
 *Description
 *Author 2019/10/17
 *Date 2019/10/17 11:20
 *Version 1.0
 */
public class BlockId implements Id {
    private long indexId;
    public BlockId(long indexId){
        this.indexId = indexId;
    }
    @Override
    public String getIdStr(){
        return indexId+"";
    }
}
