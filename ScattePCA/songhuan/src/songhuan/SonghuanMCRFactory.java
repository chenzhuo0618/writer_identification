/*
 * MATLAB Compiler: 4.18.1 (R2013a)
 * Date: Fri May 30 16:34:22 2014
 * Arguments: "-B" "macro_default" "-W" "java:songhuan,Class1" "-T" "link:lib" "-d" 
 * "E:\\Jay\\project\\writer_identification\\Scatter_PCA\\songhuan\\src" "-w" 
 * "enable:specified_file_mismatch" "-w" "enable:repeated_file" "-w" 
 * "enable:switch_ignored" "-w" "enable:missing_lib_sentinel" "-w" "enable:demo_license" 
 * "-v" 
 * "class{Class1:E:\\Jay\\project\\writer_identification\\Scatter_PCA\\test_writer.m}" 
 */

package songhuan;

import com.mathworks.toolbox.javabuilder.*;
import com.mathworks.toolbox.javabuilder.internal.*;

/**
 * <i>INTERNAL USE ONLY</i>
 */
public class SonghuanMCRFactory
{
   
    
    /** Component's uuid */
    private static final String sComponentId = "songhuan_4DBF5C308A8E3DD7986F26FB428B106B";
    
    /** Component name */
    private static final String sComponentName = "songhuan";
    
   
    /** Pointer to default component options */
    private static final MWComponentOptions sDefaultComponentOptions = 
        new MWComponentOptions(
            MWCtfExtractLocation.EXTRACT_TO_CACHE, 
            new MWCtfClassLoaderSource(SonghuanMCRFactory.class)
        );
    
    
    private SonghuanMCRFactory()
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
            SonghuanMCRFactory.class, 
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
