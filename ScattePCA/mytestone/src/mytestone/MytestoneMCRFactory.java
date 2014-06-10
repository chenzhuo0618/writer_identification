/*
 * MATLAB Compiler: 4.18.1 (R2013a)
 * Date: Fri May 30 15:33:02 2014
 * Arguments: "-B" "macro_default" "-W" "java:mytestone,Class1" "-T" "link:lib" "-d" 
 * "E:\\Jay\\project\\writer_identification\\Scatter_PCA\\mytestone\\src" "-w" 
 * "enable:specified_file_mismatch" "-w" "enable:repeated_file" "-w" 
 * "enable:switch_ignored" "-w" "enable:missing_lib_sentinel" "-w" "enable:demo_license" 
 * "-v" 
 * "class{Class1:E:\\Jay\\project\\writer_identification\\Scatter_PCA\\test_writer.m,E:\\Jay\\project\\writer_identification\\Scatter_PCA\\train_writers.m}" 
 */

package mytestone;

import com.mathworks.toolbox.javabuilder.*;
import com.mathworks.toolbox.javabuilder.internal.*;

/**
 * <i>INTERNAL USE ONLY</i>
 */
public class MytestoneMCRFactory
{
   
    
    /** Component's uuid */
    private static final String sComponentId = "mytestone_E8703B1A7B3E19F9C9947E79D8336778";
    
    /** Component name */
    private static final String sComponentName = "mytestone";
    
   
    /** Pointer to default component options */
    private static final MWComponentOptions sDefaultComponentOptions = 
        new MWComponentOptions(
            MWCtfExtractLocation.EXTRACT_TO_CACHE, 
            new MWCtfClassLoaderSource(MytestoneMCRFactory.class)
        );
    
    
    private MytestoneMCRFactory()
    {
        // Never called.
    }
    
    public static MWMCR newInstance(MWComponentOptions componentOptions) throws MWException
    {
        if (null == componentOptions.getCtfSource()) {
            componentOptions = new MWComponentOptions(componentOptions);
            componentOptions.setCtfSource(sDefaultComponentOptions.getCtfSource());
        }
        return MWMCR.newInstance(
            componentOptions, 
            MytestoneMCRFactory.class, 
            sComponentName, 
            sComponentId,
            new int[]{8,1,0}
        );
    }
    
    public static MWMCR newInstance() throws MWException
    {
        return newInstance(sDefaultComponentOptions);
    }
}
