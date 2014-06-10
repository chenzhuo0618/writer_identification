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

import java.util.concurrent.Callable;
import com.mathworks.toolbox.javabuilder.internal.MWMCR;
import com.mathworks.toolbox.javabuilder.MWException;
import com.mathworks.toolbox.javabuilder.MWComponentOptions;

/**
 * <i>INTERNAL USE ONLY</i>
 */
public class MatlabJetSharedMCRFactory
{
    /// The singleton MWMCR instance for this component
    private static volatile MWMCR sSharedMCR = null;
    
    /// A shutdown task (Runnable) that disposes of the shared MWMCR instance
    // (initially do nothing, since sSharedMCR is lazily created)
    private static volatile Runnable sShutdownTask = new Runnable() { public void run () {} };
    
    private MatlabJetSharedMCRFactory () {
        // Never called.
    }
    
    private static MWMCR getInstance (Callable<MWMCR> createInstance) throws MWException {
        synchronized(MatlabJetSharedMCRFactory.class) {
            if (null == sSharedMCR) {
                try {
                    sSharedMCR = createInstance.call();
                } catch (Exception e) {
                    assert(e instanceof MWException);
                    throw (MWException)e;
                }                
                sShutdownTask = MWMCR.scheduleShutdownTask(new Runnable() {
                    public void run () {
                        synchronized(MatlabJetSharedMCRFactory.class) {
                            assert( null != MatlabJetSharedMCRFactory.sSharedMCR );
                            MatlabJetSharedMCRFactory.sSharedMCR.dispose();
                            MatlabJetSharedMCRFactory.sSharedMCR = null;
                        }
                    }
                });
            }
            sSharedMCR.use();
            return sSharedMCR;
        }
    }
    
    public static MWMCR newInstance () throws MWException {
        return getInstance(new Callable<MWMCR>() {
            public MWMCR call () throws Exception {
                return MatlabJetMCRFactory.newInstance();
            }
        });
    }
    
    public static MWMCR newInstance (final MWComponentOptions componentOptions) throws MWException {
        return getInstance(new Callable<MWMCR>() {
            public MWMCR call () throws Exception {
                return MatlabJetMCRFactory.newInstance(componentOptions);
            }
        });
    }

    /// Releases the shared MWMCR instance and cancels its associated shutdown task.  Subsequent calls to 
    ///  newInstance will create another MWMCR.  It is necessary to call this method if this class
    ///  is to be properly unloaded prior to JVM shutdown.  It is not necessary to call this method if 
    ///  this class does not need to be unloaded before normal JVM shutdown.
    public static void releaseSharedMCR () {
        sShutdownTask.run();
    }
}
