/*
 * MATLAB Compiler: 4.17 (R2012a)
 * Date: Mon Jun  9 18:37:09 2014
 * Arguments: "-B" "macro_default" "-W" "java:MatlabJet,MatlabJet" "-T" "link:lib" "-d" 
 * "/home/sn0w/scatterpca/MatlabJet2/src" "-w" "enable:specified_file_mismatch" "-w" 
 * "enable:repeated_file" "-w" "enable:switch_ignored" "-w" "enable:missing_lib_sentinel" 
 * "-w" "enable:demo_license" "-S" "-v" 
 * "class{MatlabJet:/home/sn0w/scatterpca/test_writer.m,/home/sn0w/scatterpca/train_writers.m}" 
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
    private static final String sComponentId = "MatlabJet_F64AA6B912A50F1F1EFF499490B51185";
    
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
            new int[]{7,17,0}
        );
    }
    
    public static MWMCR newInstance() throws MWException
    {
        return newInstance(sDefaultComponentOptions);
    }
}
