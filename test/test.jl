# Clinical Trial Utilities
# Copyright © 2019 Vladimir Arnautov aka PharmCat (mail@pharmcat.net)
using Distributions, Random

@testset "  Info:               " begin
    ClinicalTrialUtilities.info()
    ClinicalTrialUtilities.citation()
    ClinicalTrialUtilities.licence()
end

println(" ---------------------------------- ")
println(" ---------   START TEST   --------- ")
println(" ---------------------------------- ")
println(" ---------------------------------- ")


@testset "  ctSampleN Test      " begin
    @test ceil(ClinicalTrialUtilities.ctSampleN(param=:mean, type=:ea, group=:one, alpha=0.05, beta=0.2, sd=1, a=1.5, b=2, k=1)) == 32
    @test ceil(ClinicalTrialUtilities.ctSampleN(param=:mean, type=:ei, group=:one, alpha=0.05, beta=0.2, sd=0.1, diff=0.05, a=2, b=2, k=1)) == 35
    @test ceil(ClinicalTrialUtilities.ctSampleN(param=:mean, type=:ns, group=:one, alpha=0.05, beta=0.2, sd=1, diff=-0.5, a=1.5, b=2, k=1)) == 7
    @test ceil(ClinicalTrialUtilities.ctSampleN(param=:mean, type=:ea, group=:two, alpha=0.05, beta=0.2, sd=10, a=5, b=10, k=1)) == 63
    @test ceil(ClinicalTrialUtilities.ctSampleN(param=:mean, type=:ei, group=:two, alpha=0.05, beta=0.2, sd=10, diff=5, a=5, b=4, k=1)) == 108
    @test ceil(ClinicalTrialUtilities.ctSampleN(param=:mean, type=:ns, group=:two, alpha=0.05, beta=0.2, sd=10, diff=5, a=5, b=5, k=1)) == 50
    @test ceil(ClinicalTrialUtilities.ctSampleN(param=:prop, type=:ea, group=:one, alpha=0.05, beta=0.2, a=0.3, b=0.5)) == 50
    @test ceil(ClinicalTrialUtilities.ctSampleN(param=:prop, type=:ei, group=:one, alpha=0.05, beta=0.2, diff=0.2, a=0.6, b=0.6)) == 52
    @test ceil(ClinicalTrialUtilities.ctSampleN(param=:prop, type=:ns, group=:one, alpha=0.05, beta=0.2, diff=-0.1, a=0.3, b=0.5)) == 18
    @test ceil(ClinicalTrialUtilities.ctSampleN(param=:prop, type=:ea, group=:two, alpha=0.05, beta=0.2, a=0.65, b=0.85)) == 70
    @test ceil(ClinicalTrialUtilities.ctSampleN(param=:prop, type=:ei, group=:two, alpha=0.05, beta=0.2, diff=0.05, a=0.65, b=0.85)) == 136
    @test ceil(ClinicalTrialUtilities.ctSampleN(param=:prop, type=:ns, group=:two, alpha=0.05, beta=0.2, diff=-0.1, a=0.85, b=0.65)) == 25
    @test ceil(ClinicalTrialUtilities.ctSampleN(param=:or, type=:ea,  alpha=0.05, beta=0.2, a=0.4, b=0.25)) == 156
    @test ceil(ClinicalTrialUtilities.ctSampleN(param=:or, type=:ei,  alpha=0.05, beta=0.2, diff=0.5, a=0.25, b=0.25)) == 366
    @test ceil(ClinicalTrialUtilities.ctSampleN(param=:or, type=:ns,  alpha=0.05, beta=0.2, diff=0.2, a=0.4, b=0.25)) == 242
    @test ceil(ClinicalTrialUtilities.ctSampleN(param=:prop, type=:mcnm, a=0.45, b=0.05)) == 23

    @test ClinicalTrialUtilities.ctSampleN(param=:mean, type=:ns, group=:two, alpha=0.05, beta=0.2, diff=1, sd=20, a=1, b=2) ≈ 1236.511446403953 atol=1E-12
    @test ClinicalTrialUtilities.ctSampleN(param=:mean, type=:ns, group=:two, alpha=0.05, beta=0.2, diff=1, sd=20, a=1, b=2, out=:vstr)[1] ≈ 1236.511446403953 atol=1E-12
    @test ClinicalTrialUtilities.ctSampleN(param=:prop, type=:ei, group=:one, alpha=0.1, beta=0.2, diff=0.1, a=0.65, b=0.6, out=:vstr)[1] ≈ 630.6717754175304 atol=1E-12
    str1 = ClinicalTrialUtilities.ctSampleN(param=:mean, type=:ea, group=:two, alpha=0.05, beta=0.2, sd=10, a=5, b=10, k=2, out=:str);
    str2 = ClinicalTrialUtilities.ctSampleN(param=:mean, type=:ea, group=:two, alpha=0.05, beta=0.2, sd=10, a=5, b=10, k=2, out=:vstr)[2];
    @test str1 == str2
end

@testset "  ctSampleN Atomic    " begin
    @test ceil(ClinicalTrialUtilities.ClinicalTrialUtilities.mcnm(0.45, 0.05)) == 23
end

println(" ---------------------------------- ")
@testset "  ctPower Test        " begin
    @test ClinicalTrialUtilities.ctPower(param=:prop, type=:mcnm, a=0.45, b=0.05, n=23, alpha=0.1) ≈ 0.9023805 atol=1E-7
end
@testset "  ctPower + Atomic    " begin
    @test ClinicalTrialUtilities.oneSampleMeanEqualityP(1.5,2,1,32;alpha=0.05) ≈ 0.8074304194325561 ≈ ClinicalTrialUtilities.ctPower(param=:mean, type=:ea, group=:one, a=1.5, b=2, sd=1,n=32, alpha=0.05)
    @test ClinicalTrialUtilities.oneSampleMeanEquivalenceP(2, 2, 0.1, 0.05, 35; alpha=0.05) ≈ 0.8108839754376387  ≈ ClinicalTrialUtilities.ctPower(param=:mean, type=:ei, group=:one, a=2, b=2, sd=0.1, diff=0.05, n=35, alpha=0.05)
    @test ClinicalTrialUtilities.oneSampleMeanNSP(1.5, 2, 1, -.5, 7; alpha=0.05) ≈ 0.8415707712023641 ≈ ClinicalTrialUtilities.ctPower(param=:mean, type=:ns, group=:one, a=1.5, b=2, sd=1, diff=-0.5, n=7, alpha=0.05)
    @test ClinicalTrialUtilities.twoSampleMeanEqualityP(5, 10, 10, 63; alpha=0.05, k=1) ≈ 0.8013023941055788 ≈ ClinicalTrialUtilities.ctPower(param=:mean, type=:ea, group=:two, a=5, b=10, sd=10, n=63, alpha=0.05)
    @test ClinicalTrialUtilities.twoSampleMeanEquivalenceP(5, 4, 10, 5,  108; alpha=0.05, k=1) ≈ 0.80452354556060  ≈ ClinicalTrialUtilities.ctPower(param=:mean, type=:ei, group=:two, a=5, b=4, sd=10, diff=5, n=108, alpha=0.05)
    @test ClinicalTrialUtilities.twoSampleMeanNSP(5, 5, 10, 5, 50; alpha=0.05, k=1) ≈ 0.8037819415575257 ≈ ClinicalTrialUtilities.ctPower(param=:mean, type=:ns, group=:two, a=5, b=5, sd=10, diff=5, n=50, alpha=0.05)
    @test ClinicalTrialUtilities.oneProportionEqualityP(0.3, 0.5, 50; alpha=0.05) ≈ 0.8074304194325561 ≈ ClinicalTrialUtilities.ctPower(param=:prop, type=:ea, group=:one, a=0.3, b=0.5, n=50, alpha=0.05)
    @test ClinicalTrialUtilities.oneProportionEquivalenceP(0.6, 0.6, 0.2, 52; alpha=0.05) ≈ 0.8060834056011101 ≈ ClinicalTrialUtilities.ctPower(param=:prop, type=:ei, group=:one, a=0.6, b=0.6, diff=0.2, n=52, alpha=0.05)
    @test ClinicalTrialUtilities.oneProportionNSP(0.3, 0.5, -0.1, 18; alpha=0.05) ≈ 0.8161481827204281 ≈ ClinicalTrialUtilities.ctPower(param=:prop, type=:ns, group=:one, a=0.3, b=0.5, diff=-0.1, n=18, alpha=0.05)
    @test ClinicalTrialUtilities.twoProportionEqualityP(0.65, 0.85, 70; alpha=0.05, k=1) ≈ 0.8019139068528 ≈ ClinicalTrialUtilities.ctPower(param=:prop, type=:ea, group=:two, a=0.65, b=0.85, n=70, alpha=0.05)
    @test ClinicalTrialUtilities.twoProportionEquivalenceP(0.65, 0.85, 0.05, 136; alpha=0.05, k=1) ≈ 0.8033294052407269  ≈ ClinicalTrialUtilities.ctPower(param=:prop, type=:ei, group=:two, a=0.65, b=0.85, diff=0.05, n=136, alpha=0.05)
    @test ClinicalTrialUtilities.twoProportionNSP(0.85, 0.65, -0.1, 25; alpha=0.05, k=1) ≈ 0.808599833380679 ≈ ClinicalTrialUtilities.ctPower(param=:prop, type=:ns, group=:two, a=0.85, b=0.65, diff=-0.1, n=25, alpha=0.05)
    @test ClinicalTrialUtilities.orEqualityP(0.4, 0.25, 156; alpha=0.05, k=1) ≈ 0.8020239054864792 ≈ ClinicalTrialUtilities.ctPower(param=:or, type=:ea, a=0.4, b=0.25, n=156, alpha=0.05)
    @test ClinicalTrialUtilities.orEquivalenceP(0.25, 0.25, 0.5, 366; alpha=0.05, k=1, logdiff=true) ≈ 0.8008593380478983  ≈ ClinicalTrialUtilities.ctPower(param=:or, type=:ei, a=0.25, b=0.25, diff=0.5, n=366, alpha=0.05)
    @test ClinicalTrialUtilities.orNSP(0.4, 0.25, 0.2, 242; alpha=0.05, k=1, logdiff=true) ≈ 0.8007200876001626  ≈ ClinicalTrialUtilities.ctPower(param=:or, type=:ns, a=0.4, b=0.25, diff=0.2, n=242, alpha=0.05)

    pow, str = ClinicalTrialUtilities.ctPower(param=:prop, type=:ea, group=:one, a=0.3, b=0.5, n=50, alpha=0.05, out=:vstr)
    @test pow ≈ 0.8074304194325561

    pow, str = ClinicalTrialUtilities.ctPower(param=:mean, type=:ea, group=:two, a=5, b=10, sd=10, n=63, alpha=0.05, out=:vstr)
    @test pow ≈ 0.8013023941055788
    str2 = ClinicalTrialUtilities.ctPower(param=:mean, type=:ea, group=:two, a=5, b=10, sd=10, n=63, alpha=0.05, out=:str)
    @test str == str2

    @test ClinicalTrialUtilities.ctPower(param=:or, type=:ns, a=0.4, b=0.25, diff=0.2, n=242, alpha=0.05, out=:num) ≈ 0.8007200876001626

end

println(" ---------------------------------- ")
@testset "  tfn function        " begin
    @test ClinicalTrialUtilities.tfn(1.0,2.0) ≈  0.07846821 atol=1E-8
    @test ClinicalTrialUtilities.tfn(0.1,10.0) > 0 #Not validated with PowerTOST
    @test ClinicalTrialUtilities.tfn(0.1,10E20) > 0 #Not validated with PowerTOST
end
@testset "  owensTint2 function " begin
    @test round(ClinicalTrialUtilities.owensTint2(1.0, 3.0, 20.0, 3.0), digits=7) ≈ 0.4839414
end
@testset "  owensQo function    " begin
    @test ClinicalTrialUtilities.owensQo(1 ,2.0,1.0,1.0;a=0.0) ≈ 0.321429    atol=1E-6
    @test ClinicalTrialUtilities.owensQo(2 ,1.0,0.5,0.2;a=0.0) ≈ 0.006781741 atol=1E-9
    @test ClinicalTrialUtilities.owensQo(4 ,2.0,1.0,1.0;a=0.0) ≈ 0.03739024  atol=1E-8
    @test ClinicalTrialUtilities.owensQo(7 ,2.0,1.0,1.0;a=0.0) ≈ 0.001888241 atol=1E-9
    @test ClinicalTrialUtilities.owensQo(3 ,2.0,1.0,Inf;a=0.0) ≈ 0.7436299   atol=1E-7
end
@testset "  owensQ  function    " begin
    @test ClinicalTrialUtilities.owensQ(4 ,100.0,40.0,0.0,Inf) ≈ 0.9584071  atol=1E-7
    @test ClinicalTrialUtilities.owensQ(1 ,1.0,1.0,0.0,Inf)    ≈ 0.42202    atol=1E-5
    @test ClinicalTrialUtilities.owensQ(4 ,100.0,30.0,0.0,0.8) ≈ 0.02702275 atol=1E-8
    @test ClinicalTrialUtilities.owensQ(1,100.0,40.0,0.0,1.0)  ≈ 0.3718607  atol=1E-7
    @test ClinicalTrialUtilities.owensQ(4 ,100.0,40.0,0.0,Inf) ≈ 0.9584071  atol=1E-7
    @test ClinicalTrialUtilities.owensQ(1 ,1.0,1.0,0.0,Inf)    ≈ 0.42202    atol=1E-5
    @test ClinicalTrialUtilities.owensQ(4 ,100.0,30.0,0.0,0.8) ≈ 0.02702275 atol=1E-8
    @test ClinicalTrialUtilities.owensQ(1,100.0,40.0,0.0,1.0)  ≈ 0.3718607  atol=1E-7
end
@testset "  powerTOSTOwenQ      " begin
    @test ClinicalTrialUtilities.powerTOSTOwenQ(0.05,0.1,0.4,0.05,0.11,23) ≈ 0.00147511 atol=1E-8
end
@testset "  approxPowerTOST     " begin
    @test ClinicalTrialUtilities.approxPowerTOST(0.05,0.4,0.9,0.05,0.11,23) ≈ 1.076964e-06 atol=1E-12
    @test ClinicalTrialUtilities.approxPowerTOST(0.05,1.0,1.0,0.5,0.2,100) == 0
end
@testset "  approx2PowerTOST    " begin
    @test ClinicalTrialUtilities.approx2PowerTOST(0.05,0.1,1.0,0.5,0.2,1000) ≈ 0.4413917 atol=1E-7
end
@testset "  owensT              " begin
    @test owensT(1.0,Inf)   ≈ 0.07932763  atol=1E-8
    @test owensT(-1.0,Inf)  ≈ 0.07932763  atol=1E-8
    @test owensT(1.0,-Inf)  ≈ -0.07932763 atol=1E-8
    @test owensT(-1.0,-Inf) ≈ -0.07932763 atol=1E-8
    @test owensT(1.0, 0.5)  ≈ 0.0430647   atol=1E-8
    @test owensT(1.0,2.0)   ≈ 0.07846819  atol=1E-8
    @test owensT(Inf, 1.0)   == 0
end

println(" ---------------------------------- ")
@testset "  designProp          " begin
    dff, bkni, seq = ClinicalTrialUtilities.designProp(:parallel)
    @test dff(30) ≈ 28 && bkni ≈ 1.0 && seq ≈ 2
    dff, bkni, seq = ClinicalTrialUtilities.designProp(:d2x2)
    @test dff(31) ≈ 29 && bkni ≈ 0.5 && seq ≈ 2
    dff, bkni, seq = ClinicalTrialUtilities.designProp(:d2x2x4)
    @test dff(31) ≈ 89 && bkni ≈ 0.25 && seq ≈ 2
    dff, bkni, seq = ClinicalTrialUtilities.designProp(:d2x4x4)
    @test dff(31) ≈ 89 && bkni ≈ 0.0625 && seq ≈ 4
    dff, bkni, seq = ClinicalTrialUtilities.designProp(:d2x2x3)
    @test dff(31) ≈ 59 && bkni ≈ 0.375 && seq ≈ 2
    dff, bkni, seq = ClinicalTrialUtilities.designProp(:d2x3x3)
    @test dff(31) ≈ 59 && bkni ≈ 1/6 && seq ≈ 3

    ClinicalTrialUtilities.sd2cv(ClinicalTrialUtilities.cv2sd(0.2)) ≈ 0.2
    ClinicalTrialUtilities.ms2cv(ClinicalTrialUtilities.cv2ms(0.2)) ≈ 0.2
end

println(" ---------------------------------- ")
@testset "  PowerTOST Test      " begin
    #parallel
    @test ClinicalTrialUtilities.bePower(alpha=0.05, logscale=true, theta1=0.8, theta2=1.25, theta0=0.95, cv=0.3, n=31, design=:parallel, method=:owenq) ≈ 0.2949476 atol=1E-7
    @test ClinicalTrialUtilities.bePower(alpha=0.05, logscale=true, theta1=0.8, theta2=1.25, theta0=0.95, cv=0.3, n=32, design=:parallel, method=:owenq) ≈ 0.3166927 atol=1E-7
    #2x2
    @test ClinicalTrialUtilities.bePower(alpha=0.05, logscale=true, theta1=0.8, theta2=1.25, theta0=0.95, cv=0.2, n=20, design=:d2x2, method=:owenq)         ≈ 0.8346802 atol=1E-7
    @test ClinicalTrialUtilities.bePower(alpha=0.05, logscale=true, theta1=0.8, theta2=1.25, theta0=0.95, cv=0.2, n=10, design=:d2x2, method=:nct)           ≈ 0.4316618 atol=1E-7
    @test ClinicalTrialUtilities.bePower(alpha=0.1, logscale=false, theta1=-0.1, theta2=0.1, theta0=0.0, cv=0.14, n=21, design=:d2x2, method=:shifted)       ≈ 0.6626132 atol=1E-7
    @test ClinicalTrialUtilities.bePower(alpha=0.05, logscale=false, theta1=-0.1, theta2=0.1, theta0=0.0, cv=0.14, n=30, design=:d2x2, method=:nct)          ≈ 0.7079951 atol=1E-7
    @test ClinicalTrialUtilities.bePower(alpha=0.0000001, logscale=false, theta1=-0.1, theta2=0.1, theta0=0.0, cv=1.0, n=10000, design=:d2x2, method=:owenq) ≈ 0.9380914 atol=1E-7
    @test ClinicalTrialUtilities.bePower(alpha=0.0001, logscale=false, theta1=-0.1, theta2=0.1, theta0=0.0, cv=1.0, n=3500, design=:d2x2, method=:owenq)     ≈ 0.3545904 atol=1E-7
    @test ClinicalTrialUtilities.bePower(alpha=0.00000005, logscale=false, theta1=-0.1, theta2=0.1, theta0=0.0, cv=1.5, n=20000, design=:d2x2, method=:owenq) ≈ 0.8197361 atol=1E-7
    @test ClinicalTrialUtilities.bePower(alpha=0.1, logscale=false, theta1=-0.1, theta2=0.1, theta0=0.0, cv=0.14, n=4, design=:d2x2, method=:shifted) ≈ 0.0
    @test ClinicalTrialUtilities.bePower(alpha=0.1, logscale=false, theta1=-0.1, theta2=0.1, theta0=0.0, cv=0.02, n=3, design=:d2x2, method=:shifted) ≈ 0.7738659 atol=1E-7
    #
    @test ClinicalTrialUtilities.bePower(alpha=0.05, logscale=true, theta1=0.8, theta2=1.25, theta0=0.95, cv=0.2, n=27, design=:d2x2, method=:owenq) ≈ 0.9264365737448076
    @test ClinicalTrialUtilities.bePower(alpha=0.05, logscale=true, theta1=0.8, theta2=1.25, theta0=0.95, cv=0.2, n=29, design=:d2x2, method=:owenq) ≈ 0.941900827163551
    @test ClinicalTrialUtilities.bePower(alpha=0.05, logscale=true, theta1=0.8, theta2=1.25, theta0=0.95, cv=0.2, n=31, design=:d2x2, method=:owenq) ≈ 0.9542152686694777

    #2x2x4
    @test ClinicalTrialUtilities.bePower(alpha=0.05, logscale=true, theta1=0.8, theta2=1.25, theta0=0.95, cv=0.4, n=35, design=:d2x2x4) ≈ 0.829747  atol=1E-6
    @test ClinicalTrialUtilities.bePower(alpha=0.05, logscale=true, theta1=0.8, theta2=1.25, theta0=0.95, cv=1, n=35, design=:d2x2x4) ≈ 0.014249535210231756  atol=1E-6
    #2x4x4
    @test ClinicalTrialUtilities.bePower(alpha=0.05, logscale=true, theta1=0.8, theta2=1.25, theta0=0.95, cv=0.4, n=35, design=:d2x4x4) ≈ 0.8291076  atol=1E-7
    @test ClinicalTrialUtilities.bePower(alpha=0.05, logscale=true, theta1=0.8, theta2=1.25, theta0=0.95, cv=0.4, n=34, design=:d2x4x4) ≈ 0.8180596  atol=1E-7
    @test ClinicalTrialUtilities.bePower(alpha=0.05, logscale=true, theta1=0.8, theta2=1.25, theta0=0.95, cv=0.4, n=33, design=:d2x4x4) ≈ 0.8069565  atol=1E-7
    #2x3x3
    @test ClinicalTrialUtilities.bePower(alpha=0.05, logscale=true, theta1=0.8, theta2=1.25, theta0=0.95, cv=0.4, n=32, design=:d2x3x3) ≈ 0.5976873  atol=1E-7
    @test ClinicalTrialUtilities.bePower(alpha=0.05, logscale=true, theta1=0.8, theta2=1.25, theta0=0.95, cv=0.4, n=31, design=:d2x3x3) ≈ 0.579468  atol=1E-6
    @test ClinicalTrialUtilities.bePower(alpha=0.05, logscale=true, theta1=0.8, theta2=1.25, theta0=0.95, cv=0.4, n=30, design=:d2x3x3) ≈ 0.5614358  atol=1E-7
end
println(" ---------------------------------- ")
@testset "  Errors              " begin

    en = 0
    try
        ClinicalTrialUtilities.designProp(:ddd)
    catch e
        if isa(e, ClinicalTrialUtilities.CTUException) en = e.n end
    end
    @test en ≈ 1031
    en = 0
    try
        ClinicalTrialUtilities.bePower(alpha=0.05, logscale=true, theta1=0.8, theta2=1.25, theta0=0.95, cv=0.2, n=0,  method=:mvt)
    catch e
        if isa(e, ClinicalTrialUtilities.CTUException) en = e.n end
    end
    @test en ≈ 1021

    en = 0
    try
        ClinicalTrialUtilities.bePower(alpha=0.05, logscale=true, theta1=0.8, theta2=1.25, theta0=0.95, cv=0, n=10,  method=:mvt)
    catch e
        if isa(e, ClinicalTrialUtilities.CTUException) en = e.n end
    end
    @test en ≈ 1022

    en = 0
    try
        ClinicalTrialUtilities.bePower(alpha=1.05, logscale=true, theta1=0.8, theta2=1.25, theta0=0.95, cv=0.2, n=10,  method=:mvt)
    catch e
        if isa(e, ClinicalTrialUtilities.CTUException) en = e.n end
    end
    @test en ≈ 1023
    en = 0
    try
        ClinicalTrialUtilities.bePower(alpha=0.05, logscale=true, theta1=0.8, theta2=1.25, theta0=0.95, cv=0.2, n=2,  method=:mvt)
    catch e
        if isa(e, ClinicalTrialUtilities.CTUException) en = e.n end
    end
    @test en ≈ 1024
    en = 0
    try
        ClinicalTrialUtilities.bePower(alpha=0.05, logscale=true, theta1=0.8, theta2=1.25, theta0=0.95, cv=0.2, n=20,  method=:mmvt)
    catch e
        if isa(e, ClinicalTrialUtilities.CTUException) en = e.n end
    end
    @test en ≈ 1025
    en = 0
    try
        ClinicalTrialUtilities.bePower(alpha=0.05, logscale=true, theta1=0.8, theta2=1.25, theta0=0.95, cv=0.2, n=20, design=:d2x2, method=:mvt)
    catch e
        if isa(e, ClinicalTrialUtilities.CTUException) en = e.n end
    end
    @test en ≈ 1000

    en = 0
    try
        ClinicalTrialUtilities.ctSampleN(param=:mean, type=:ea, group=:one, alpha=2, beta=0.2, diff=1, sd=1, a=1, b=1, k=1)
    catch e
        if isa(e, ClinicalTrialUtilities.CTUException) en = e.n end
    end
    @test en ≈ 1201
    en = 0
    try
        ClinicalTrialUtilities.ctSampleN(param=:mean, type=:ei, group=:one, alpha=0.5, beta=0.2, diff=0, sd=1, a=1, b=1, k=1)
    catch e
        if isa(e, ClinicalTrialUtilities.CTUException) en = e.n end
    end
    @test en ≈ 1202
    en = 0
    try
        ClinicalTrialUtilities.ctSampleN(param=:prop, type=:ea, group=:oone, alpha=0.05, beta=0.2, diff=1, a=0.5, b=0.5, k=1)
    catch e
        if isa(e, ClinicalTrialUtilities.CTUException) en = e.n end
    end
    @test en ≈ 1203
    en = 0
    try
        ClinicalTrialUtilities.ctSampleN(param=:mean, type=:ns, group=:one, alpha=0.5, beta=0.2, diff=1, sd=0, a=1, b=1, k=1)
    catch e
        if isa(e, ClinicalTrialUtilities.CTUException) en = e.n end
    end
    @test en ≈ 1204
    en = 0
    try
        ClinicalTrialUtilities.ctSampleN(param=:mean, type=:ea, group=:one, alpha=0.05, beta=0.2, diff=1, sd=1, a=0, b=0, k=0)
    catch e
        if isa(e, ClinicalTrialUtilities.CTUException) en = e.n end
    end
    @test en ≈ 1205

    en = 0
    try
        ClinicalTrialUtilities.CI.oneProp(38, 100, alpha=0.05, method=:err)
    catch e
        if isa(e, ClinicalTrialUtilities.CTUException) en = e.n end
    end
    @test en ≈ 1301

    @test !ClinicalTrialUtilities.ctSampleN(param=:mean, type=:ea, group=:oone, alpha=0.5, beta=0.2, diff=1, sd=1, a=1, b=1, k=1)
    @test !ClinicalTrialUtilities.ctSampleN(param=:mean, type=:eea, group=:one, alpha=0.5, beta=0.2, diff=1, sd=1, a=1, b=1, k=1)
    @test !ClinicalTrialUtilities.ctSampleN(param=:mean, type=:eea, group=:two, alpha=0.5, beta=0.2, diff=1, sd=1, a=1, b=1, k=1)
    @test !ClinicalTrialUtilities.ctSampleN(param=:pprop, type=:eea, group=:one, alpha=0.5, beta=0.2, diff=1, sd=1, a=1, b=1, k=1)
    @test !ClinicalTrialUtilities.ctSampleN(param=:prop, type=:eea, group=:one, alpha=0.05, beta=0.2, diff=1, a=0.5, b=0.5, k=1)
    @test !ClinicalTrialUtilities.ctSampleN(param=:prop, type=:eea, group=:two, alpha=0.05, beta=0.2, diff=1, a=0.5, b=0.5, k=1)

    @test !ClinicalTrialUtilities.ctSampleN(param=:prop, type=:ea, group=:one, alpha=0.05, beta=0.2, diff=1, sd=1, a=-1, b=0, k=1)
    @test !ClinicalTrialUtilities.ctSampleN(param=:prop, type=:ei, group=:one, alpha=0.05, beta=0.2, diff=1, sd=1, a=0.4, b=2, k=1)
    @test !ClinicalTrialUtilities.ctSampleN(param=:or, type=:eea, group=:oone,  diff=1, a=0.5, b=0.5, k=1)
end

println(" ---------------------------------- ")
@testset "  beSampleN Test      " begin
    n, p = ClinicalTrialUtilities.beSampleN(;theta0=0.95, theta1=0.8, theta2=1.25, cv=0.2, alpha=0.05, beta=0.2, logscale=true, method=:owenq)
    @test n == 20 && round(p, digits=7) == 0.8346802
    n, p = ClinicalTrialUtilities.beSampleN(;theta0=0.95, theta1=0.8, theta2=1.25, cv=0.3, alpha=0.05, beta=0.2, logscale=true, method=:owenq)
    @test n == 40 && round(p, digits=7) == 0.8158453
    n, p = ClinicalTrialUtilities.beSampleN(;theta0=1.0, theta1=0.8, theta2=1.25, cv=0.3, alpha=0.05, beta=0.1, logscale=true, method=:owenq)
    @test n == 40 && round(p, digits=7) == 0.9095603
    n, p = ClinicalTrialUtilities.beSampleN(;theta0=1.05, theta1=0.8, theta2=1.25, cv=0.4, alpha=0.05, beta=0.15, logscale=true, method=:nct)
    @test n == 74 && round(p, digits=7) == 0.8558178
    n, p = ClinicalTrialUtilities.beSampleN(;theta0=1.05, theta1=0.9, theta2=1.25, cv=0.4, alpha=0.05, beta=0.15, logscale=true, method=:nct)
    @test n == 108 && round(p, digits=7) == 0.8506248
    n, p = ClinicalTrialUtilities.beSampleN(;theta0=1.05, theta1=0.8, theta2=1.2, cv=0.5, alpha=0.05, beta=0.2, logscale=true, method=:nct)
    @test n == 158 && round(p, digits=7) == 0.8039191
    n, p = ClinicalTrialUtilities.beSampleN(;theta0=1.05, theta1=0.8, theta2=1.25, cv=0.8, alpha=0.05, beta=0.2, logscale=true, method=:shifted)
    @test n == 210 && round(p, digits=7) == 0.8012471
    n, p = ClinicalTrialUtilities.beSampleN(;theta0=0.0, theta1=-0.2, theta2=0.2, cv=0.5, alpha=0.05, beta=0.2, logscale=false, method=:owenq)
    @test n == 110 && round(p, digits=7) == 0.8074124
    n, p = ClinicalTrialUtilities.beSampleN(;theta0=0.0, theta1=-0.2, theta2=0.2, cv=2.0, alpha=0.05, beta=0.2, logscale=false, method=:owenq)
    @test n == 1716 && round(p, digits=7) == 0.8005618
    n, p = ClinicalTrialUtilities.beSampleN(;theta0=0.0, theta1=-0.2, theta2=0.2, cv=2.0, alpha=0.001, beta=0.2, logscale=false, method=:owenq)
    @test n == 3828 && round(p, digits=7) == 0.8001454
    n, p = ClinicalTrialUtilities.beSampleN(;theta0=0, theta1=-0.2, theta2=0.2, cv=2, alpha=0.01, beta=0.01, logscale=false, method=:owenq)
    @test n == 4810 && round(p, digits=7) == 0.9900151
    n, p = ClinicalTrialUtilities.beSampleN(cv=0.347)
    @test n == 52 && round(p, digits=7) == 0.8136415

    n, p = ClinicalTrialUtilities.beSampleN(;theta0=1.05, theta1=0.9, theta2=1.25, cv=0.0001, alpha=0.05, beta=0.15, logscale=true, method=:nct, design=:parallel)
    @test n == 4 && p ≈ 1.0
    n, p = ClinicalTrialUtilities.beSampleN(;theta0=1.0, theta1=0.95, theta2=1.5, cv=0.8, alpha=0.0000001, beta=0.0001, logscale=true, method=:shifted, design=:d2x2x4)
    @test n == 10002 && p ≈ 0.9818179411719451

    st = ClinicalTrialUtilities.beSampleN(cv=0.347, out=:str)

    n, p, s = ClinicalTrialUtilities.beSampleN(cv=0.347, out=:vstr)
    @test n == 52 && round(p, digits=7) == 0.8136415
    @test st == s

    n, p = ClinicalTrialUtilities.beSampleN(;theta0=1.05, theta1=0.8, theta2=1.25, cv=0.8, alpha=0.05, beta=0.2, logscale=true, method=:shifted, design=:d2x2x4)
    @test n == 106 && p ≈ 0.8060551186037984

    n, p = ClinicalTrialUtilities.beSampleN(;theta0=0.95, theta1=0.8, theta2=1.25, cv=0.35, alpha=0.1, beta=0.1, logscale=true, method=:shifted, design=:parallel)
    @test n == 106 && p ≈ 0.9013894463164578
end

println(" ---------------------------------- ")
@testset "  CI Test             " begin

    ci = ClinicalTrialUtilities.CI.oneProp(38, 100, alpha=0.05, method=:wald)
    @test ci.lower    ≈ 0.284866005121432 atol=1E-15
    @test ci.upper    ≈ 0.47513399487856794 atol=1E-15
    @test ci.estimate ≈ 0.38 atol=1E-16

    ci = ClinicalTrialUtilities.CI.oneProp(38, 100, alpha=0.05, method=:wilson)
    @test ci.lower    ≈ 0.2909759925247873 atol=1E-16
    @test ci.upper    ≈ 0.47790244704488943 atol=1E-15
    @test ci.estimate ≈ 0.38443921978483836 atol=1E-15

    ci = ClinicalTrialUtilities.CI.oneProp(38, 100, alpha=0.05, method=:cp)
    @test ci.lower    ≈ 0.284767476141479 atol=1E-15
    @test ci.upper    ≈ 0.482539305750806 atol=1E-15
    @test ci.estimate ≈ 0.38

    ci = ClinicalTrialUtilities.CI.oneProp(100, 100, alpha=0.05, method=:cp)
    @test ci.lower    ≈ 0.9637833073548235 atol=1E-15
    @test ci.upper    ≈ 1.0 atol=1E-15
    @test ci.estimate ≈ 1.0

    ci = ClinicalTrialUtilities.CI.oneProp(38, 100, alpha=0.05, method=:soc)
    @test ci.lower    ≈ 0.289191701883923 atol=1E-15
    @test ci.upper    ≈ 0.477559239340346 atol=1E-15
    @test ci.estimate ≈ 0.38

    ci = ClinicalTrialUtilities.CI.oneProp(38, 100, alpha=0.05, method=:blaker)
    @test ci.lower    ≈ 0.2881875 atol=1E-7
    @test ci.upper    ≈ 0.4798293 atol=1E-7
    @test ci.estimate ≈ 0.38

    ci = ClinicalTrialUtilities.CI.oneProp(38, 100, alpha=0.05, method=:arcsine)
    @test ci.lower    ≈ 0.2877714314998773 atol=1E-16
    @test ci.upper    ≈ 0.47682358116201534 atol=1E-16
    @test ci.estimate ≈ 0.38

    #----

    ci = ClinicalTrialUtilities.CI.twoProp(30, 100, 40, 90; alpha=0.05, type=:or, method=:mn)
    @test ci.lower    ≈ 0.2951669 atol=1E-7
    @test ci.upper    ≈ 0.9722965 atol=1E-7
    @test ci.estimate ≈ 0.5357142 atol=1E-7

    ci = ClinicalTrialUtilities.CI.twoProp(100, 100, 90, 90; alpha=0.05, type=:or, method=:mn)
    @test ci.lower    ≈ 0.0
    @test ci.upper    ≈ Inf
    #@test ci.estimate == NaN

    ci = ClinicalTrialUtilities.CI.twoProp(0, 100, 90, 90; alpha=0.05, type=:or, method=:mn)
    @test ci.lower    ≈ 0.0
    @test ci.upper    ≈ 0.0004144169697670039  atol=1E-7
    @test ci.estimate ≈ 0.0

    ci = ClinicalTrialUtilities.CI.twoProp(100, 100, 0, 90; alpha=0.05, type=:or, method=:mn)
    @test ci.lower    ≈ 2411.6137253788347 atol=1E-7
    @test ci.upper    ≈ Inf
    @test ci.estimate ≈ Inf

    ci = ClinicalTrialUtilities.CI.twoProp(30, 100, 40, 90; alpha=0.05, type=:or, method=:awoolf)
    @test ci.lower    ≈ 0.2982066 atol=1E-7
    @test ci.upper    ≈ 0.9758363 atol=1E-7
    @test ci.estimate ≈ 0.5394449 atol=1E-7

    ci = ClinicalTrialUtilities.CI.twoProp(30, 100, 40, 90; alpha=0.05, type=:or, method=:woolf)
    @test ci.lower    ≈ 0.29504200273798975 atol=1E-7
    @test ci.upper    ≈ 0.9727082695179062 atol=1E-7
    @test ci.estimate ≈ 0.5357142857142857 atol=1E-7

    #----

    ci = ClinicalTrialUtilities.CI.twoProp(30, 100, 40, 90; alpha=0.05, type=:diff, method=:nhs)
    @test ci.lower    ≈ -0.275381800 atol=1E-9
    @test ci.upper    ≈ -0.007158419 atol=1E-9
    @test ci.estimate ≈ -0.1444444   atol=1E-7

    ci = ClinicalTrialUtilities.CI.twoProp(30, 100, 40, 90; alpha=0.05, type=:diff, method=:ac)
    @test ci.lower    ≈ -0.276944506 atol=1E-9
    @test ci.upper    ≈ -0.006516705 atol=1E-9
    @test ci.estimate ≈ -0.1444444   atol=1E-7

    @test ClinicalTrialUtilities.CI.mnzstat(0.4,100,0.3,90,0.05) ≈ 0.5197817 atol=1E-7

    ci = ClinicalTrialUtilities.CI.twoProp(30, 100, 40, 90; alpha=0.05, type=:diff, method=:mn)
    @test ci.lower    ≈ -0.278129080 atol=1E-9
    @test ci.upper    ≈ -0.006708301 atol=1E-9
    @test ci.estimate ≈ -0.1444444   atol=1E-7

    ci = ClinicalTrialUtilities.CI.twoProp(30, 100, 40, 90; alpha=0.05, type=:diff, method=:mee)
    @test ci.lower    ≈ -0.27778778455 atol=1E-9
    @test ci.upper    ≈ -0.00707120778 atol=1E-9
    @test ci.estimate ≈ -0.14444444444 atol=1E-7

    ci = ClinicalTrialUtilities.CI.twoProp(30, 100, 40, 90; alpha=0.05, type=:diff, method=:mee2)
    @test ci.lower    ≈ -0.27778778455 atol=1E-9
    @test ci.upper    ≈ -0.00707120778 atol=1E-9
    @test ci.estimate ≈ -0.14444444444 atol=1E-7

    ci = ClinicalTrialUtilities.CI.twoProp(30, 100, 40, 90; alpha=0.05, type=:diff, method=:wald)
    @test ci.lower    ≈ -0.28084842238 atol=1E-9
    @test ci.upper    ≈ -0.00804046650 atol=1E-9
    @test ci.estimate ≈ -0.14444444444 atol=1E-7

    ci = ClinicalTrialUtilities.CI.twoProp(30, 100, 40, 90; alpha=0.05, type=:diff, method=:waldcc)
    @test ci.lower    ≈ -0.29140397794 atol=1E-9
    @test ci.upper    ≈  0.00251508905 atol=1E-9
    @test ci.estimate ≈ -0.14444444444 atol=1E-7

    ci = ClinicalTrialUtilities.CI.twoProp(30, 100, 40, 90; alpha=0.05, type=:rr, method=:cli)
    @test ci.lower    ≈ 0.4663950 atol=1E-7
    @test ci.upper    ≈ 0.9860541 atol=1E-7
    @test ci.estimate ≈ 0.675     atol=1E-4

    ci = ClinicalTrialUtilities.CI.twoProp(30, 100, 40, 90; alpha=0.05, type=:rr, method=:mover)
    @test ci.lower    ≈ 0.4634443 atol=1E-7
    @test ci.upper    ≈ 0.9808807 atol=1E-7
    @test ci.estimate ≈ 0.675     atol=1E-4

    ci = ClinicalTrialUtilities.CI.twoProp(30, 100, 40, 90; alpha=0.05, type=:rr, method=:mover)
    @test ci.lower    ≈ 0.4634443 atol=1E-7
    @test ci.upper    ≈ 0.9808807 atol=1E-7
    @test ci.estimate ≈ 0.675     atol=1E-4

    #----

    ci = ClinicalTrialUtilities.CI.twoMeans(30, 10, 30, 40, 12, 35, alpha=0.05, type=:diff, method=:ev)
    @test ci.lower    ≈ -11.6549655 atol=1E-7
    @test ci.upper    ≈ -8.3450344 atol=1E-7
    @test ci.estimate ≈ -10.0     atol=1E-4

    ci = ClinicalTrialUtilities.CI.twoMeans(30, 10, 30, 40, 12, 35, alpha=0.05, type=:diff, method=:uv)
    @test ci.lower    ≈ -11.6433893 atol=1E-7
    @test ci.upper    ≈ -8.3566106 atol=1E-7
    @test ci.estimate ≈ -10.0     atol=1E-4
    ci = ClinicalTrialUtilities.CI.twoMeans(30.5, 12.6, 23, 34, 21.7, 39, alpha=0.05, type=:diff, method=:uv)
    @test ci.lower    ≈ -5.6050900 atol=1E-7
    @test ci.upper    ≈ -1.3949099 atol=1E-7
    @test ci.estimate ≈ -3.5     atol=1E-4

    ci = ClinicalTrialUtilities.CI.oneMean(30,10,30,0.05; method=:norm)
    @test ci.lower    ≈ 28.86841 atol=1E-5
    @test ci.upper    ≈ 31.13159 atol=1E-5
    ci = ClinicalTrialUtilities.CI.oneMean(30,10,30,0.05; method=:tdist)
    @test ci.lower    ≈ 28.81919 atol=1E-5
    @test ci.upper    ≈ 31.18081 atol=1E-5

    #Source Validation
    #---------------------------------------------------------------------------
    #doi:10.1002/(sici)1097-0258(19980430)17:8<857::aid-sim777>3.0.co;2-e
    ci = ClinicalTrialUtilities.CI.oneProp(81, 263, alpha=0.05, method=:wilson)
    @test ci.lower    ≈ 0.2553 atol=1E-4
    @test ci.upper    ≈ 0.3662 atol=1E-4
    ci = ClinicalTrialUtilities.CI.oneProp(15, 148, alpha=0.05, method=:wilson)
    @test ci.lower    ≈ 0.0624 atol=1E-4
    @test ci.upper    ≈ 0.1605 atol=1E-4
    ci = ClinicalTrialUtilities.CI.oneProp(0, 20, alpha=0.05, method=:wilson)
    @test ci.lower    ≈ 0.0000 atol=1E-4
    @test ci.upper    ≈ 0.1611 atol=1E-4
    ci = ClinicalTrialUtilities.CI.oneProp(1, 29, alpha=0.05, method=:wilson)
    @test ci.lower    ≈ 0.0061 atol=1E-4
    @test ci.upper    ≈ 0.1718 atol=1E-4

    ci = ClinicalTrialUtilities.CI.oneProp(0, 20, alpha=0.05, method=:wilsoncc)
    @test ci.lower    ≈ 0.0000 atol=1E-4
    @test ci.upper    ≈ 0.2005 atol=1E-4

    ci = ClinicalTrialUtilities.CI.oneProp(1, 29, alpha=0.05, method=:wilsoncc)
    @test ci.lower    ≈ 0.0018 atol=1E-4
    @test ci.upper    ≈ 0.1963 atol=1E-4

    #exact (CP)
    ci = ClinicalTrialUtilities.CI.oneProp(0, 20, alpha=0.05, method=:cp)
    @test ci.lower    ≈ 0.0000 atol=1E-4
    @test ci.upper    ≈ 0.1684 atol=1E-4

    #Recommended confidence intervals for two independent binomial proportions DOI: 10.1177/0962280211415469
    ci = ClinicalTrialUtilities.CI.twoProp(7, 34, 1, 34; alpha=0.05, type=:diff, method=:nhs)
    @test ci.lower    ≈ 0.019 atol=1E-3
    @test ci.upper    ≈ 0.34 atol=1E-2

    #https://www.researchgate.net/publication/328407614_Score_intervals_for_the_difference_of_two_binomial_proportions
    ci = ClinicalTrialUtilities.CI.twoProp(4, 5, 2, 5; alpha=0.05, type=:diff, method=:mn)
    @test ci.lower    ≈ -0.228 atol=1E-3
    @test ci.upper    ≈ 0.794 atol=1E-3
    #https://www.lexjansen.com/wuss/2016/127_Final_Paper_PDF.pdf
    #Constructing Confidence Intervals for the Differences of Binomial Proportions in SAS® Will Garner, Gilead Sciences, Inc., Foster City, CA
    ci = ClinicalTrialUtilities.CI.twoProp(56, 70, 48, 80; alpha=0.05, type=:diff, method=:mn)
    @test ci.lower    ≈  0.0528 atol=1E-4
    @test ci.upper    ≈  0.3382 atol=1E-4
    ci = ClinicalTrialUtilities.CI.twoProp(56, 70, 48, 80; alpha=0.05, type=:diff, method=:mee)
    @test ci.lower    ≈  0.0533 atol=1E-4
    @test ci.upper    ≈  0.3377 atol=1E-4
    ci = ClinicalTrialUtilities.CI.twoProp(56, 70, 48, 80; alpha=0.05, type=:diff, method=:nhscc)
    @test ci.lower    ≈  0.0428 atol=1E-4
    @test ci.upper    ≈  0.3422 atol=1E-4

    #CI Test for random sample
    m1  = rand(Normal(), 100)
    m2  = rand(Normal(), 100)
    ci1 = ClinicalTrialUtilities.CI.meanDiffUV(m1, m2, 0.05)
    ci2 = ClinicalTrialUtilities.CI.meanDiffUV(mean(m1), var(m1), length(m1), mean(m2), var(m2), length(m2), 0.05)
    @test ci1 == ci2
    ci1 = ClinicalTrialUtilities.CI.meanDiffEV(m1, m2, 0.05)
    ci2 = ClinicalTrialUtilities.CI.meanDiffEV(mean(m1), var(m1), length(m1), mean(m2), var(m2), length(m2), 0.05)
    @test ci1 == ci2
end

println(" ---------------------------------- ")
@testset "  Simulations         " begin

    @test ClinicalTrialUtilities.SIM.bePower(alpha=0.05, logscale=true, theta1=0.8, theta2=1.25, theta0=0.95, cv=0.2, n=20, simnum=4, seed=1111) ≈ 0.8346
    @test ClinicalTrialUtilities.SIM.bePower(alpha=0.1, logscale=true, theta1=0.8, theta2=1.25, theta0=0.95, cv=0.2, n=29, simnum=4, seed=1111) ≈ 0.9744

    #!
    ClinicalTrialUtilities.SIM.bePower(alpha=0.1, logscale=false, theta1=0.8, theta2=1.25, theta0=0.95, cv=0.2, n=29, simnum=4, seed=1111)

    @test ClinicalTrialUtilities.SIM.ctPropPower(0.5, 100, 0.5, 100, 0.6; alpha=0.05, type=:or, method=:mn, seed=123, simnum=4) ≈ 0.4131

    #@test ClinicalTrialUtilities.orNSP(0.5, 0.4, 0.8, 100; alpha=0.05, k=1, logdiff=false) ≈ 0.710550974559294
    @test ClinicalTrialUtilities.SIM.ctPropPower(0.5, 100, 0.4, 100, 0.8; alpha=0.1, type=:or, method=:mn, seed=123, simnum=4) ≈ 0.6988

    @test ClinicalTrialUtilities.SIM.ctMeansPowerFS(1.0, 1.0, 10, 1.0, 1.0, 10, -0.3; alpha=0.1, method=:ev,  seed=1235, simnum=4) ≈ 0.1584
    @test ClinicalTrialUtilities.SIM.ctMeansPower(1.0, 1.0, 10, 1.0, 1.0, 10, -0.3; alpha=0.1,  seed=1235, simnum=4) ≈ 0.1662

    T = ClinicalTrialUtilities.SIM.ctPropSampleN(0.6, 0.6,-0.15; alpha=0.1, type=:diff, method=:nhs, seed=1234, simnum=4)
    @test T[1] == 129
    @test T[2] ≈ 0.795


end

println(" ---------------------------------- ")
@testset "  Tpl                 " begin

end