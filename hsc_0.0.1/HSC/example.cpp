//******************************************************************************
// HSC - Histogram of Shearlet Coefficients.
// Copyright (C) 2010-2011 by William Robson Schwartz.
//
// This program is free software: you can redistribute it and/or modify it under
// the terms of the GNU Lesser General Public License as published by the Free
// Software Foundation, either version 3 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
// details.
//
// You should have received a copy of the GNU Lesser General Public License
// along with this program. If not, see <http://www.gnu.org/licenses/lgpl.html>
//******************************************************************************

#include <stdio.h>
#include "headers.h"
#include "HSC.h"


int main(int argc, char* argv[]) {
Vector<float> *feat;
IplImage *img;
HSC hsc;

	/* set parameters */
	hsc.SetParameter("LapFilter", "Burt");			// filter for pyramid decomposition
	hsc.SetParameter("norient", "8");				// number of orientations
	hsc.SetParameter("maskSize", "4");				// convolution mask size
	hsc.SetParameter("nlevels", "1");				// number of decomposition levels
	hsc.SetParameter("useCell", "true");			// split block into four cells 
	hsc.SetParameter("normalization", "global");	// normalization type

	/* initialize feature extraction method */
	hsc.InitializeExtractionMethod();

	/* feature extraction */
	img = cvLoadImage("peppers.pgm");				// load image
	hsc.AddNewImage(img);							// add image to extraction
	feat = hsc.ExtractFeatures(256, 256, 256, 256);	// extract feature descriptors considering block sizes of 256x256 pixels

	/* save results */
	feat->Write("features.feat");

	return 0;
}