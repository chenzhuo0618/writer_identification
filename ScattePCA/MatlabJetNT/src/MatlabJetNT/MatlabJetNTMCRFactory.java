/*
 * MATLAB Compiler: 4.18.1 (R2013a)
 * Date: Tue Jun 10 10:33:00 2014
 * Arguments: "-B" "macro_default" "-W" "java:MatlabJetNT,MatlabJet" "-T" "link:lib" "-d" 
 * "E:\\Jay\\project\\writer_identification\\ScattePCA\\MatlabJetNT\\src" "-w" 
 * "enable:specified_file_mismatch" "-w" "enable:repeated_file" "-w" 
 * "enable:switch_ignored" "-w" "enable:missing_lib_sentinel" "-w" "enable:demo_license" 
 * "-v" 
 * "class{MatlabJet:E:\\Jay\\project\\writer_identification\\ScattePCA\\test_writer.m,E:\\Jay\\project\\writer_identification\\ScattePCA\\train_writers.m}" 
 */

package MatlabJetNT;

import com.mathworks.toolbox.javabuilder.*;
import com.mathworks.toolbox.javabuilder.internal.*;

/**
 * <i>INTERNAL USE ONLY</i>
 */
public class MatlabJetNTMCRFactory
{
   
    
    /** Component's uuid */
    private static final String sComponentId = "MatlabJetNT_7CFE14C6F57DA4DAF8A187E28B0270E3";
    
    /** Component name */
    private static final String sComponentName = "MatlabJetNT";
    
   
    /** Pointer to default component options */
    private static final MWComponentOptions sDefaultComponentOptions = 
        new MWComponentOptions(
            MWCtfExtractLocation.EXTRACT_TO_CACHE, 
            new MWCtfClassLoaderSource(MatlabJetNTMCRFactory.class)
        );
    
    
    private MatlabJetNTMCRFactory()
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
            MatlabJetNTMCRFactory.class, 
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
