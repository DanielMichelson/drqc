/* --------------------------------------------------------------------
Copyright (C) 2019 The Crown (i.e. Her Majesty the Queen in Right of Canada)

This file is an add-on to RAVE.

RAVE is free software: you can redistribute it and/or modify
it under the terms of the GNU Lesser General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

RAVE is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License
along with RAVE.  If not, see <http://www.gnu.org/licenses/>.
------------------------------------------------------------------------*/
/**
 * Description: 
 * @file dr_qc.h
 * @author Daniel Michelson, Environment and Climate Change Canada
 * @date 2019-04-11
 */
#ifndef DR_QC_H
#define DR_QC_H
#include <math.h>
#include "rave_object.h"
#include "rave_attribute.h"
#include "polarscan.h"
#include "polarscanparam.h"
#define MY_ABS(x)    ((x) < 0 ? -(x) : (x))
#define MY_MIN(a, b) ((a) < (b) ? (a) : (b))
#define MAX_RHOHV 0.999     /* RHOHV must be <1 to avoid blowing up DR */
#define DR_OFFSET -33.13757158016619  /* Best DR -one step with MAX_RHOHV */
#define DR_GAIN 0.12995126109869093
#define DR_UNDETECT 0.0     /* undetect depolarization value */
#define DR_NODATA DR_OFFSET /* bogus nodata depolarization value */


/**
 * Calculates depolarization ratio.
 * @param[in] double - ZDR value on the decibel scale
 * @param[in] double - RHOHV value, should be between 0 and MAX_RHOHV
 * @param[in] double - ZDR offset value on the decibel scale
 * @return double - depolarization ratio value on the decibel scale
 */
double drCalculate(double ZDR, double RHOHV, double zdr_offset);

/**
 * 
 */
int drDeriveParameter(PolarScan_t *scan, double zdr_offset);

/**
 * Runs a speckle and inverse speckle filter over parameter (assumed to be DBZH)
 * and derived DR. Within the filter kernel, the majority value of:
 * weather = (dBZ < threshold and DR < threshold) or dBZ >= threshold
 * non-meteorological = dBZ < threshold and DR >= threshold
 * mostly clear = UNDETECT
 * is the winner. This means that for a 5 ray x 5 bin kernel, 9 or more of any 
 * of these categories wins and the centre bin is filtered accordingly.
 */
int drSpeckleFilter(PolarScan_t *scan, char* param_name, int kernelx, int kernely, double dbz_thresh, double dr_thresh);


#endif