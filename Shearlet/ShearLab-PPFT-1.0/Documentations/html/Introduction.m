%% Introduction
%
% Applied harmonic analysts introduced in recent years several approaches
% for directional representations of image data, each one with the intent
% of efficiently representing highly anisotropic image features. Examples
% include curvelets, contourlets, and shearlets. These proposals are
% inspired by elegant results in theoretical harmonic analysis, which study
% functions defined on the continuum plane (i.e. not digital images) and
% address problems of efficiently representing certain types of functions
% and operators. One set of inspiring results concerns the possibility of
% highly compressed representation of `cartoon' images, i.e. functions
% which are piecewise smooth with singularities along smooth curves.
% Another set of results concerns the possibility of a highly compressed
% representation of wave propagation operators. In `continuum theory',
% anisotropic directional transforms can significantly outperform wavelets
% in important ways. 
%
% Accordingly, one hopes that a digital implementation
% of such ideas would also deliver performance benefits over wavelet
% algorithms in real-world settings. In many cases, however, at the time
% this webpage was set-up, there were no publicly available implementations
% of such ideas, or the available implementations were only sketchily
% tested or the available implementations were only vaguely related to the
% continuum transforms they are reputed to represent. Accordingly, we had
% not yet seen a serious exploration of the potential benefit of such
% transforms, carefully comparing the expected benefits with those
% delivered by specific implementations.
% 
% We aim at providing both: 
%
% * A rationally designed shearlet transform implementation. 
% * An comprehensive framework for quantifying performance of parabolic scaling algorithms. 
