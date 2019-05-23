# Clinical Trial Utilities
# Version: 0.1.8
# Author: Vladimir Arnautov aka PharmCat
# Copyright © 2019 Vladimir Arnautov aka PharmCat (mail@pharmcat.net)
# OwensQ/PowerTOST functions rewrited from https://github.com/Detlew/PowerTOST by Detlew Labes, Helmut Schuetz, Benjamin Lang
# Licence: GNU Affero General Public License v3.0
# Reference:
# Calculation based on Chow S, Shao J, Wang H. 2008. Sample Size Calculations in Clinical Research. 2nd Ed. Chapman & Hall/CRC Biostatistics Series.
# Connor R. J. 1987. Sample size for testing differences in proportions for the paired-sample design. Biometrics 43(1):207-211. page 209.
# Owen, D B (1965) "A Special Case of a Bivariate Non-central t-Distribution" Biometrika Vol. 52, pp.437-446.
# FORTRAN code by J. Burkhardt, license GNU LGPL
# D.B. Owen "Tables for computing bivariate normal Probabilities" The Annals of Mathematical Statistics, Vol. 27 (4) Dec. 1956, pp. 1075-1090
# matlab code  by J. Burkhardt license GNU LGPL
# If you want to check and get R code you can find some here: http://powerandsamplesize.com/Calculators/
__precompile__(true)
module ClinicalTrialUtilities
using Distributions
#using Rmath #should be rewrited
using QuadGK
#using SpecialFunctions
import SpecialFunctions.lgamma

#Exceptions
struct CTUException <: Exception
    n::Int
    var::String
end

Base.showerror(io::IO, e::CTUException) = print("CTU Exception code: ", e.n, " Message: ", e.var);
const ZDIST = Normal()
const VERSION = "0.1.8"
#Exceptions

struct ConfInt
    lower::Float64
    upper::Float64
    estimate::Float64
end

export CTUException, ConfInt

#Owen function calc: owensQ, owensQo, ifun1, owensTint2, owensT, tfn
include("OwensQ.jl")
#powerTOST calc: powerTOST, powerTOSTint, powerTOSTOwenQ, approxPowerTOST, power1TOST, approx2PowerTOST, cv2se, designProp
include("PowerTOST.jl")
#Sample sise and Power atomic functions
include("PowerSampleSize.jl")
#Main sample size and power functions: sampleSize, ctPower, beSampleN
include("SampleSize.jl")
#Confidence interval calculation
include("CI.jl")
#Simulations
include("SIM.jl")
#info function
include("Info.jl")

#Sample size
export ctSampleN
export beSampleN
#Power
export ctPower
export bePower
#Utils
export ci2cv
#Other
export owensQ
export owensT

export SIM
export CI



#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------



end # module end
