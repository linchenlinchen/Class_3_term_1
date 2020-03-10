package itf;

public interface BlockManager {
    Id getId();
    Block getBlock(Id indexId);
    Block newBlock(byte[] b);
    default Block newEmptyBlock(int blockSize) {
    return newBlock(new byte[blockSize]);
    }
}
