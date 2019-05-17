# ClinicalTrialUtilities
 Clinical Trial Power and Sample Size calculation and simulations. Also can be used for confidence intervals estimation.

Version:0.1.8

2019 &copy; Vladimir Arnautov

[![Build Status](https://travis-ci.com/PharmCat/ClinicalTrialUtilities.jl.svg?branch=master)](https://travis-ci.com/PharmCat/ClinicalTrialUtilities.jl)
[![Build status](https://ci.appveyor.com/api/projects/status/35f8b5vq259sbssg?svg=true)](https://ci.appveyor.com/project/PharmCat/clinicaltrialutilities-jl)
[![codecov](https://codecov.io/gh/PharmCat/ClinicalTrialUtilities.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/PharmCat/ClinicalTrialUtilities.jl)
[![Coverage Status](https://coveralls.io/repos/github/PharmCat/ClinicalTrialUtilities.jl/badge.svg?branch=master)](https://coveralls.io/github/PharmCat/ClinicalTrialUtilities.jl?branch=master)
### Dependencies:

 - Distributions
 - QuadGK
 - SpecialFunctions
 - Random
 - Roots

### Install:
```
using Pkg
Pkg.add("ClinicalTrialUtilities");
```
or
```
using Pkg
Pkg.clone("https://github.com/PharmCat/ClinicalTrialUtilities.jl.git");
```
### Functions:

Sample size calculation:

ctSampleN(;param, type, group, alpha, beta, diff, sd, a, b, k, out)

Clinical trial power estimation:

Iterative sample size calculation for Bioequivalence trials:

beSampleN(;theta0, theta1, theta2, cv, alpha, beta, logscale, method, design, out)

ctPower(;param, type, group, alpha, n, diff, sd, a, b, k, out)

Power calculation for TOST (for Bioequivalence trials):

bePower(;theta0, theta1, theta2, cv, n, alpha, logscale, method,  design)

Owen's T function:

owensT(h, a)

Owen's Q function (a,b always should be >= 0):

owensQ(nu, t, delta, a, b)

### Usage

**NB! Hypothesis types:**

- ea - Equality: two-sided;
- ei - Equivalencens: two one-sided hypothesis;
- ns - Non-Inferiority / Superiority: one-sided hypothesis, for some cases you should use two-sided hypothesis for  Non-Inferiority/Superiority, you can use alpha/2 for this;


#### sampleSize
```
using ClinicalTrialUtilities
ctSampleN(param=[:mean|:prop|:or], type=[:ea|:ei|:ns|:mcnm], group=[:one|:two], alpha=0.05, beta=0.2, diff=0, sd=0, a=0, b=0, k=1, out=[:num|:str|:vstr|:print])

```
**param (Parameter type):**
- mean - Means;
- prop - Proportions;
- or - Odd Ratio;

**type (Hypothesis type):**
- ea - Equality;
- ei - Equivalencens;
- ns - Non-Inferiority / Superiority (!one-sided hypothesis!);
- mcnm - McNemar's Equality test;

**group (group num):**
- one - One sample;
- two - Two sample, result is for one group, second group size = n * k;

**alpha** - Alpha (o < alpha < 1)  (default=0.05);

**beta** - Beta (o < beta < 1) (default=0.2); power = 1 - beta;

**diff** - difference/equivalence margin/non-inferiority/superiority margin;

**sd** - Standard deviation (σ, for Means only);

**a** - Null Hypothesis mean (μ0), Group A;

**b** - True mean (μ) for one sample / Group B for two sample design;

**k** - Na/Nb (after sample size estimation second group size: Na=k*Nb, only for two sample design) (default=1);

**out** - output type:
- num   - numeric (default);
- str   - String variable with text output;
- vstr  - numeric and String variable;
- print - print to console;

#### ctPower
```
using ClinicalTrialUtilities
ctPower(param=[:mean|:prop|:or], type=[:ea|:ei|:ns|:mcnm], group=[:one|:two], alpha=0.05, logdiff=true, n=0, diff=0,  sd=0, a=0, b=0, k=1, out=[:num|:str|:vstr|:print])
```

**param (Parameter type):**
- mean - Means;
- prop - Proportions;
- or - Odd Ratio;

**type (Hypothesis type):**
- ea - Equality;
- ei - Equivalence;
- ns - Non-Inferiority / Superiority;
- mcnm - McNemar's Equality test;

**group (group num):**
- one - one sample;
- two - Two sample;

**alpha** - Alpha (0<alpha<1)  (default=0.05);

**n** - Subjects number;

**diff** - difference/equivalence margin/non-inferiority/superiority margin;

**sd** - Standard deviation (σ, for Means only);

**a** - Null Hypothesis mean (μ0), Group A;

**b** - True mean (μ) for one sample / Group B for two sample design;

**k** - Na/Nb (after sample size estimation second group size: Na=k*Nb, only for two sample design) (default=1);

**out** - output type:
- num   - numeric (default);
- str   - String variable with text output;
- vstr  - numeric and String variable;
- print - print to console;

#### powerTOST

```
using ClinicalTrialUtilities
powerTOST(alpha=0.05, logscale=[true|false], theta1=0.8, theta2=1.25, theta0=0.95, cv=0.0, n=36, method=":owenq|:nct|:shifted", design=":parallel|:d2x2|:d2x2x3|:d2x2x4|:d2x4x4|:d2x3x3", out=[:num|:str|:vstr|:print])
```
**logscale** - theta1, theta2, theta0: if true - make log transformation (default true);

**alpha** - Alpha (0 < alpha < 1)  (default=0.05);

**theta1** - Lower Level (default=0.8);

**theta2** - Upper level (default=1.25);

**theta0** - T/R Ratio (default=0.95);

**cv** - coefficient of variation;

**n** - subject number;

**method** - calculating method: Owen's Q Function | NonCentral T, Shifted;
- owenq (default)
- nct
- shifted

**design** - trial design;
- parralel
- d2x2 (default)
- d2x2x4
- d2x4x4
- d2x3x3

#### beSampleN

Using for bioequivalence study.

```
using ClinicalTrialUtilities
beSampleN(alpha=0.05, logscale=[true|false], theta1=0.8, theta2=1.25, theta0=0.95, cv=0, method=[:owenq|:nct|:shifted], design=[:parallel|:d2x2|:d2x2x3|:d2x2x4|:d2x4x4|:d2x3x3], out=[:num|:str|:vstr|:print])
```
**logscale** - theta1, theta2, theta0: if true - make log transformation (default true);

**alpha** - Alpha (o < alpha < 1)  (default=0.05);

**beta** - Beta (o < beta < 1) (default=0.2); power = 1 - beta;

**theta1** - Lower Level (default=0.8);

**theta2** - Upper level (default=1.25);

**theta0** - T/R Ratio (default=0.95);

**cv** - coefficient of variation;

**method** - calculating method: Owen's Q Function | NonCentral T | Shifted;
- owenq (default)
- nct
- shifted

**design** - trial design;
- parralel
- d2x2 (default)
- d2x2x4
- d2x4x4
- d2x3x3

**out** - output type:
- num   - numeric (default);
- str   - String variable with text output;
- vstr  - numeric and String variable;
- print - print to console;

### Examples:

```
#Sample size for one proportion equality
ctSampleN(param=:prop, type=:ea, group=:one, a=0.3, b=0.5)

#Equivalence for two means
ctSampleN(param=:mean, type=:ei, group=:two, diff=0.3, sd=1, a=0.3, b=0.5)

#Odd ratio non-inferiority
ctSampleN(param=:or, type=:ns, diff=-0.1, a=0.3, b=0.5, k=2)

#Odd ratio equality
ctSampleN(param=:or, type=:ea, a=0.3, b=0.5, k=2)

#Bioequivalence power for 2x2 design, default method - OwensQ
bePower(alpha=0.05, logscale=true, theta1=0.8, theta2=1.25, theta0=0.95, cv=0.2, n=20, design=:d2x2, method=:owenq)

#Same
bePower(alpha=0.05, cv=0.2, n=20, design=:d2x2)

#Bioequivalence power for cv 14%, 21 subjects, default OwensQ method, logscale false
bePower(alpha=0.1, logscale=false, theta1=-0.1, theta2=0.1, theta0=0, cv=0.14, n=21)

#Bioequivalence power for cv 14%, 21 subjects, shifted method, logscale false
bePower(alpha=0.1, logscale=false, theta1=-0.1, theta2=0.1, theta0=0, cv=0.14, n=21, method=:shifted)

#Simple notations
bePower(cv=0.4, n=35, design=:d2x4x4)
bePower(cv=0.14, n=21)

#Bioequivalence sample size
beSampleN(alpha=0.05,  theta1=0.8, theta2=1.25, theta0=0.95, cv=0.15, method=:owenq)
beSampleN(cv=0.20, method=:nct)
beSampleN(cv=0.347, design=:parallel,  out=:print)
beSampleN(cv=0.40)

n, p, s = beSampleN(cv=0.347, design=:d2x2x4, method=:nct, out=:vstr)
```

### Confidence Interval Submodule

Description here:

https://github.com/PharmCat/ClinicalTrialUtilities.jl/blob/dev/doc/CI.md

### Simulations

Description here:

https://github.com/PharmCat/ClinicalTrialUtilities.jl/blob/master/doc/SIM.md
