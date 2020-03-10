package test.software; 

import org.junit.Test; 
import org.junit.Before; 
import org.junit.After;
import software.FileUtil;

/** 
* FileUtil Tester. 
* 
* @author <Authors name> 
* @since <pre>十月 17, 2019</pre> 
* @version 1.0 
*/ 
public class FileUtilTest { 

@Before
public void before() throws Exception { 
} 

@After
public void after() throws Exception { 
} 

/** 
* 
* Method: getContents(String path) 
* 
*/ 
@Test
public void testGetContents() throws Exception { 
//TODO: Test goes here... 
}
@Test
public void testGetBytes(){
    String path = "bm-2/1.data";
    System.out.println(FileUtil.getL(path));

}
@Test
public void testWrite(){
    FileUtil.write("bm-1/id_count",new byte[]{'0'});
}
} 
