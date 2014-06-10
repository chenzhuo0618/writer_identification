/*
 * MATLAB Compiler: 4.18.1 (R2013a)
 * Date: Fri May 30 21:05:28 2014
 * Arguments: "-B" "macro_default" "-W" "java:matlabjet,MatlabJet" "-T" "link:lib" "-d" 
 * "E:\\Jay\\project\\writer_identification\\Scatter_PCA\\matlabjet\\src" "-w" 
 * "enable:specified_file_mismatch" "-w" "enable:repeated_file" "-w" 
 * "enable:switch_ignored" "-w" "enable:missing_lib_sentinel" "-w" "enable:demo_license" 
 * "-v" 
 * "class{MatlabJet:E:\\Jay\\project\\writer_identification\\Scatter_PCA\\test_writer.m,E:\\Jay\\project\\writer_identification\\Scatter_PCA\\train_writers.m}" 
 */

package matlabjet;

import com.mathworks.toolbox.javabuilder.*;
import com.mathworks.toolbox.javabuilder.internal.*;

/**
 * <i>INTERNAL USE ONLY</i>
 */
public class MatlabjetMCRFactory
{
   
    
    /** Component's uuid */
    private static final String sComponentId = "matlabjet_A33D140313DA313CF4D125DC84601A36";
    
    /** Component name */
    private static final String sComponentName = "matlabjet";
    
   
    /** Pointer to default component options */
    private static final MWComponentOptions sDefaultComponentOptions = 
        new MWComponentOptions(
            MWCtfExtractLocation.EXTRACT_TO_CACHE, 
            new MWCtfClassLoaderSource(MatlabjetMCRFactory.class)
        );
    
    
    private MatlabjetMCRFactory()
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
            MatlabjetMCRFactory.class, 
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
