package test.software; 

import org.junit.Test; 
import org.junit.Before; 
import org.junit.After;
import software.FileUtil;
import software.StringOperation;

/** 
* StringOperation Tester. 
* 
* @author <Authors name> 
* @since <pre>十月 20, 2019</pre> 
* @version 1.0 
*/ 
public class StringOperationTest { 

@Before
public void before() throws Exception { 
} 

@After
public void after() throws Exception { 
} 

/** 
* 
* Method: bindStr_data(String dir, String blockId) 
* 
*/ 
@Test
public void testBindStr_data() throws Exception { 
//TODO: Test goes here... 
} 

/** 
* 
* Method: bindStr_meta(String dir, String blockId) 
* 
*/ 
@Test
public void testBindStr_meta() throws Exception { 
//TODO: Test goes here... 
} 

/** 
* 
* Method: stol(String string) 
* 
*/ 
@Test
public void testStol() throws Exception { 
//TODO: Test goes here... 
} 

/** 
* 
* Method: ltos(long l) 
* 
*/ 
@Test
public void testLtos() throws Exception { 
//TODO: Test goes here... 
} 

/** 
* 
* Method: checksum(byte[] bs) 
* 
*/ 
@Test
public void testChecksum() throws Exception { 
//TODO: Test goes here...
    byte[] temp = FileUtil.getBytes("bm-2/1.data");
    long r = StringOperation.checksum(temp);
    System.out.println(r);
} 


} 
