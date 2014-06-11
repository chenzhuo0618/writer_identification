/*
 * MATLAB Compiler: 4.18.1 (R2013a)
 * Date: Tue Jun 10 10:38:16 2014
 * Arguments: "-B" "macro_default" "-W" "java:MatlabJet,MatlabJet" "-T" "link:lib" "-d" 
 * "E:\\Jay\\project\\writer_identification\\MatlabJetNT\\src" "-w" 
 * "enable:specified_file_mismatch" "-w" "enable:repeated_file" "-w" 
 * "enable:switch_ignored" "-w" "enable:missing_lib_sentinel" "-w" "enable:demo_license" 
 * "-v" 
 * "class{MatlabJet:E:\\Jay\\project\\writer_identification\\ScattePCA\\test_writer.m,E:\\Jay\\project\\writer_identification\\ScattePCA\\train_writers.m}" 
 */

package MatlabJet;

import com.mathworks.toolbox.javabuilder.*;
import com.mathworks.toolbox.javabuilder.internal.*;

/**
 * <i>INTERNAL USE ONLY</i>
 */
public class MatlabJetMCRFactory
{
   
    
    /** Component's uuid */
    private static final String sComponentId = "MatlabJet_DC0DDC5AC842D5C95FB38312CE2ECC5F";
    
    /** Component name */
    private static final String sComponentName = "MatlabJet";
    
   
    /** Pointer to default component options */
    private static final MWComponentOptions sDefaultComponentOptions = 
        new MWComponentOptions(
            MWCtfExtractLocation.EXTRACT_TO_CACHE, 
            new MWCtfClassLoaderSource(MatlabJetMCRFactory.class)
        );
    
    
    private MatlabJetMCRFactory()
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
            MatlabJetMCRFactory.class, 
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
