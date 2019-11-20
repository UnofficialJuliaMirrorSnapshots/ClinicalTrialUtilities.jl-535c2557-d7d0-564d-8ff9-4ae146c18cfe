println(" ---------------------------------- ")
@testset "  CI Test               " begin
    # ONE PROPORTION
    ci = ClinicalTrialUtilities.propci(38, 100, alpha=0.05, method=:wald)
    @test ci.lower    ≈ 0.284866005121432 atol=1E-6
    @test ci.upper    ≈ 0.47513399487856794 atol=1E-6
    @test ci.estimate ≈ 0.38 atol=1E-6

    ci = ClinicalTrialUtilities.propci(38, 100, alpha=0.05, method=:waldcc)
    @test ci.lower    ≈ 0.27986600512143206 atol=1E-6
    @test ci.upper    ≈ 0.48013399487856795 atol=1E-6
    @test ci.estimate ≈ 0.38 atol=1E-6

    ci = ClinicalTrialUtilities.propci(38, 100, alpha=0.05, method=:wilson)
    @test ci.lower    ≈ 0.2909759925247873 atol=1E-6
    @test ci.upper    ≈ 0.47790244704488943 atol=1E-6
    @test ci.estimate ≈ 0.38443921978483836 atol=1E-6

    ci = ClinicalTrialUtilities.propci(38, 100, alpha=0.05, method=:cp)
    @test ci.lower    ≈ 0.284767476141479 atol=1E-6
    @test ci.upper    ≈ 0.482539305750806 atol=1E-6
    @test ci.estimate ≈ 0.38

    ci = ClinicalTrialUtilities.propci(100, 100, alpha=0.05, method=:cp)
    @test ci.lower    ≈ 0.9637833073548235 atol=1E-6
    @test ci.upper    ≈ 1.0 atol=1E-6
    @test ci.estimate ≈ 1.0

    ci = ClinicalTrialUtilities.propci(38, 100, alpha=0.05, method=:soc)
    @test ci.lower    ≈ 0.289191701883923 atol=1E-6
    @test ci.upper    ≈ 0.477559239340346 atol=1E-6
    @test ci.estimate ≈ 0.38

    ci = ClinicalTrialUtilities.propci(38, 100, alpha=0.05, method=:blaker)
    @test ci.lower    ≈ 0.2881875 atol=1E-6
    @test ci.upper    ≈ 0.4798293 atol=1E-6
    @test ci.estimate ≈ 0.38

    ci = ClinicalTrialUtilities.propci(38, 100, alpha=0.05, method=:arcsine)
    @test ci.lower    ≈ 0.2877714314998773 atol=1E-6
    @test ci.upper    ≈ 0.47682358116201534 atol=1E-6
    @test ci.estimate ≈ 0.38

    #---- twoProp
    #-- mn

    ci = ClinicalTrialUtilities.twoprop(30, 100, 40, 90; alpha=0.05, type=:or, method=:mn)
    @test ci.lower    ≈ 0.29537414 atol=1E-6
    @test ci.upper    ≈ 0.97166697 atol=1E-6
    @test ci.estimate ≈ 0.53571428 atol=1E-6

    ci = ClinicalTrialUtilities.twoprop(100, 100, 90, 90; alpha=0.05, type=:or, method=:mn)
    @test ci.lower    ≈ 0.0
    @test ci.upper    ≈ Inf
    #@test ci.estimate == NaN

    ci = ClinicalTrialUtilities.twoprop(0, 100, 90, 90; alpha=0.05, type=:or, method=:mn)
    @test ci.lower    ≈ 0.0
    @test ci.upper    ≈ 0.00041425995552740226  atol=1E-6
    @test ci.estimate ≈ 0.0

    ci = ClinicalTrialUtilities.twoprop(100, 100, 0, 90; alpha=0.05, type=:or, method=:mn)
    @test ci.lower    ≈ 2413.9431770847045 atol=1E-6
    @test ci.upper    ≈ Inf
    @test ci.estimate ≈ Inf

    #-- mn2

    ci = ClinicalTrialUtilities.twoprop(30, 100, 40, 90; alpha=0.05, type=:or, method=:mn2)
    @test ci.lower    ≈ 0.2951669 atol=1E-6
    @test ci.upper    ≈ 0.9722965 atol=1E-6
    @test ci.estimate ≈ 0.5357142 atol=1E-6

    ci = ClinicalTrialUtilities.twoprop(100, 100, 90, 90; alpha=0.05, type=:or, method=:mn2)
    @test ci.lower    ≈ 0.0
    @test ci.upper    ≈ Inf
    #@test ci.estimate == NaN

    ci = ClinicalTrialUtilities.twoprop(0, 100, 90, 90; alpha=0.05, type=:or, method=:mn2)
    @test ci.lower    ≈ 0.0
    @test ci.upper    ≈ 0.0004144169697670039  atol=1E-6
    @test ci.estimate ≈ 0.0

    ci = ClinicalTrialUtilities.twoprop(100, 100, 0, 90; alpha=0.05, type=:or, method=:mn2)
    @test ci.lower    ≈ 2411.6137253788347 atol=1E-6
    @test ci.upper    ≈ Inf
    @test ci.estimate ≈ Inf

    ci = ClinicalTrialUtilities.twoprop(30, 100, 40, 90; alpha=0.05, type=:or, method=:awoolf)
    @test ci.lower    ≈ 0.2982066 atol=1E-6
    @test ci.upper    ≈ 0.9758363 atol=1E-6
    @test ci.estimate ≈ 0.5394449 atol=1E-6

    ci = ClinicalTrialUtilities.twoprop(30, 100, 40, 90; alpha=0.05, type=:or, method=:woolf)
    @test ci.lower    ≈ 0.29504200273798975 atol=1E-6
    @test ci.upper    ≈ 0.9727082695179062 atol=1E-6
    @test ci.estimate ≈ 0.5357142857142857 atol=1E-6

    ci = ClinicalTrialUtilities.twoprop(30, 100, 40, 90; alpha=0.05, type=:or, method=:mover)
    @test ci.lower    ≈ 0.2963748435372293 atol=1E-6
    @test ci.upper    ≈ 0.9689058534780502 atol=1E-6
    @test ci.estimate ≈ 0.5357142857142857 atol=1E-6

    #----

    ci = ClinicalTrialUtilities.twoprop(30, 100, 40, 90; alpha=0.05, type=:diff, method=:nhs)
    @test ci.lower    ≈ -0.275381800 atol=1E-6
    @test ci.upper    ≈ -0.007158419 atol=1E-6
    @test ci.estimate ≈ -0.1444444   atol=1E-6

    ci = ClinicalTrialUtilities.twoprop(30, 100, 40, 90; alpha=0.05, type=:diff, method=:ac)
    @test ci.lower    ≈ -0.276944506 atol=1E-6
    @test ci.upper    ≈ -0.006516705 atol=1E-6
    @test ci.estimate ≈ -0.1444444   atol=1E-6

    ci = ClinicalTrialUtilities.twoprop(30, 100, 40, 90; alpha=0.05, type=:diff, method=:mn)
    @test ci.lower    ≈ -0.2781290897168457 atol=1E-6
    @test ci.upper    ≈ -0.006708341755865329 atol=1E-6
    @test ci.estimate ≈ -0.1444444   atol=1E-6

    ci = ClinicalTrialUtilities.twoprop(30, 100, 40, 90; alpha=0.05, type=:diff, method=:mee)
    @test ci.lower    ≈ -0.27778775409226936 atol=1E-6
    @test ci.upper    ≈ -0.007071205228197489 atol=1E-6
    @test ci.estimate ≈ -0.14444444444 atol=1E-6

    ci = ClinicalTrialUtilities.twoprop(30, 100, 40, 90; alpha=0.05, type=:diff, method=:mee2)
    #Roots 0.7.4 CTU 0.1.7
    @test ci.lower    ≈ -0.27778778455 atol=1E-5 #Chang atol for validation
    @test ci.upper    ≈ -0.00707120778 atol=1E-5
    @test ci.estimate ≈ -0.14444444444 atol=1E-7

    ci = ClinicalTrialUtilities.twoprop(30, 100, 40, 90; alpha=0.05, type=:diff, method=:wald)
    @test ci.lower    ≈ -0.28084842238 atol=1E-6
    @test ci.upper    ≈ -0.00804046650 atol=1E-6
    @test ci.estimate ≈ -0.14444444444 atol=1E-6

    ci = ClinicalTrialUtilities.twoprop(30, 100, 40, 90; alpha=0.05, type=:diff, method=:waldcc)
    @test ci.lower    ≈ -0.29140397794 atol=1E-6
    @test ci.upper    ≈  0.00251508905 atol=1E-6
    @test ci.estimate ≈ -0.14444444444 atol=1E-6

    #---- RR
    #-- mn

    ci = ClinicalTrialUtilities.twoprop(30, 100, 40, 90; alpha=0.05, type=:rr, method=:mn)
    @test ci.lower    ≈ 0.46636099123297575 atol=1E-6
    @test ci.upper    ≈ 0.9799258384796817 atol=1E-6
    @test ci.estimate ≈ 0.675 atol=1E-6

    ci = ClinicalTrialUtilities.twoprop(100, 100, 90, 90; alpha=0.05, type=:rr, method=:mn)
    @test ci.lower    ≈ 0.0
    @test ci.upper    ≈ Inf
    #@test ci.estimate == NaN

    ci = ClinicalTrialUtilities.twoprop(0, 100, 90, 90; alpha=0.05, type=:rr, method=:mn)
    @test ci.lower    ≈ 0.0
    @test ci.upper    ≈ 0.018137090385952483  atol=1E-6
    @test ci.estimate ≈ 0.0

    ci = ClinicalTrialUtilities.twoprop(100, 100, 0, 90; alpha=0.05, type=:rr, method=:mn)
    @test ci.lower    ≈ 44.8498645475395 atol=1E-6
    @test ci.upper    ≈ Inf
    @test ci.estimate ≈ Inf

    #-- cli

    ci = ClinicalTrialUtilities.twoprop(30, 100, 40, 90; alpha=0.05, type=:rr, method=:cli)
    @test ci.lower    ≈ 0.4663950 atol=1E-6
    @test ci.upper    ≈ 0.9860541 atol=1E-6
    @test ci.estimate ≈ 0.675     atol=1E-4

    ci = ClinicalTrialUtilities.twoprop(30, 100, 40, 90; alpha=0.05, type=:rr, method=:mover)
    @test ci.lower    ≈ 0.4634443 atol=1E-6
    @test ci.upper    ≈ 0.9808807 atol=1E-6
    @test ci.estimate ≈ 0.675     atol=1E-4

    ci = ClinicalTrialUtilities.twoprop(30, 100, 40, 90; alpha=0.05, type=:rr, method=:mover)
    @test ci.lower    ≈ 0.4634443 atol=1E-6
    @test ci.upper    ≈ 0.9808807 atol=1E-6
    @test ci.estimate ≈ 0.675     atol=1E-4
    #katz
    ci = ClinicalTrialUtilities.twoprop(30, 100, 40, 90; alpha=0.05, type=:rr, method=:katz)
    @test ci.lower    ≈ 0.4624671 atol=1E-6
    @test ci.upper    ≈ 0.9852050 atol=1E-6
    @test ci.estimate ≈ 0.675     atol=1E-4

    #----

    ci = ClinicalTrialUtilities.diffmeanci(30, 10, 30, 40, 12, 35, alpha=0.05, method=:ev)
    @test ci.lower    ≈ -11.6549655 atol=1E-6
    @test ci.upper    ≈ -8.3450344 atol=1E-6
    @test ci.estimate ≈ -10.0     atol=1E-4

    ci = ClinicalTrialUtilities.diffmeanci(30, 10, 30, 40, 12, 35, alpha=0.05, method=:uv)
    @test ci.lower    ≈ -11.6433893 atol=1E-6
    @test ci.upper    ≈ -8.3566106 atol=1E-6
    @test ci.estimate ≈ -10.0     atol=1E-4
    ci = ClinicalTrialUtilities.diffmeanci(30.5, 12.6, 23, 34, 21.7, 39, alpha=0.05, method=:uv)
    @test ci.lower    ≈ -5.6050900 atol=1E-6
    @test ci.upper    ≈ -1.3949099 atol=1E-6
    @test ci.estimate ≈ -3.5     atol=1E-4

    ci = ClinicalTrialUtilities.meanci(30,10,30, alpha = 0.05, method=:norm)
    @test ci.lower    ≈ 28.86841 atol=1E-5
    @test ci.upper    ≈ 31.13159 atol=1E-5
    ci = ClinicalTrialUtilities.meanci(30,10,30, alpha = 0.05, method=:tdist)
    @test ci.lower    ≈ 28.81919 atol=1E-5
    @test ci.upper    ≈ 31.18081 atol=1E-5

    #Source Validation
    #---------------------------------------------------------------------------
    #doi:10.1002/(sici)1097-0258(19980430)17:8<857::aid-sim777>3.0.co;2-e
    ci = ClinicalTrialUtilities.propci(81, 263, alpha=0.05, method=:wilson)
    @test ci.lower    ≈ 0.2553 atol=1E-4
    @test ci.upper    ≈ 0.3662 atol=1E-4
    ci = ClinicalTrialUtilities.propci(15, 148, alpha=0.05, method=:wilson)
    @test ci.lower    ≈ 0.0624 atol=1E-4
    @test ci.upper    ≈ 0.1605 atol=1E-4
    ci = ClinicalTrialUtilities.propci(0, 20, alpha=0.05, method=:wilson)
    @test ci.lower    ≈ 0.0000 atol=1E-4
    @test ci.upper    ≈ 0.1611 atol=1E-4
    ci = ClinicalTrialUtilities.propci(1, 29, alpha=0.05, method=:wilson)
    @test ci.lower    ≈ 0.0061 atol=1E-4
    @test ci.upper    ≈ 0.1718 atol=1E-4

    ci = ClinicalTrialUtilities.propci(0, 20, alpha=0.05, method=:wilsoncc)
    @test ci.lower    ≈ 0.0000 atol=1E-4
    @test ci.upper    ≈ 0.2005 atol=1E-4

    ci = ClinicalTrialUtilities.propci(1, 29, alpha=0.05, method=:wilsoncc)
    @test ci.lower    ≈ 0.0018 atol=1E-4
    @test ci.upper    ≈ 0.1963 atol=1E-4

    #exact (CP)
    ci = ClinicalTrialUtilities.propci(0, 20, alpha=0.05, method=:cp)
    @test ci.lower    ≈ 0.0000 atol=1E-4
    @test ci.upper    ≈ 0.1684 atol=1E-4

    #Recommended confidence intervals for two independent binomial proportions DOI: 10.1177/0962280211415469
    ci = ClinicalTrialUtilities.twoprop(7, 34, 1, 34; alpha=0.05, type=:diff, method=:nhs)
    @test ci.lower    ≈ 0.019 atol=1E-3
    @test ci.upper    ≈ 0.34 atol=1E-2

    #https://www.researchgate.net/publication/328407614_Score_intervals_for_the_difference_of_two_binomial_proportions
    ci = ClinicalTrialUtilities.twoprop(4, 5, 2, 5; alpha=0.05, type=:diff, method=:mn)
    @test ci.lower    ≈ -0.228 atol=1E-3
    @test ci.upper    ≈ 0.794 atol=1E-3
    #https://www.lexjansen.com/wuss/2016/127_Final_Paper_PDF.pdf
    #Constructing Confidence Intervals for the Differences of Binomial Proportions in SAS® Will Garner, Gilead Sciences, Inc., Foster City, CA
    ci = ClinicalTrialUtilities.twoprop(56, 70, 48, 80; alpha=0.05, type=:diff, method=:mn)
    @test ci.lower    ≈  0.0528 atol=1E-4
    @test ci.upper    ≈  0.3382 atol=1E-4
    ci = ClinicalTrialUtilities.twoprop(56, 70, 48, 80; alpha=0.05, type=:diff, method=:mee)
    @test ci.lower    ≈  0.0533 atol=1E-4
    @test ci.upper    ≈  0.3377 atol=1E-4
    ci = ClinicalTrialUtilities.twoprop(56, 70, 48, 80; alpha=0.05, type=:diff, method=:nhscc)
    @test ci.lower    ≈  0.0428 atol=1E-4
    @test ci.upper    ≈  0.3422 atol=1E-4

    #https://rdrr.io/cran/ORCI/man/Woolf.CI.html
    ci = ClinicalTrialUtilities.twoprop(2, 14, 1, 11; alpha=0.05, type=:or,method=:woolf)
    @test ci.lower    ≈  0.1310604 atol=1E-7
    @test ci.upper    ≈  21.1946394 atol=1E-7

    #CI Test for random sample
    m1  = rand(Normal(), 100)
    m2  = rand(Normal(), 100)
    ci1 = ClinicalTrialUtilities.meanDiffUV(m1, m2, 0.05)
    ci2 = ClinicalTrialUtilities.meanDiffUV(mean(m1), var(m1), length(m1), mean(m2), var(m2), length(m2), 0.05)
    @test ci1 == ci2
    ci1 = ClinicalTrialUtilities.meanDiffEV(m1, m2, 0.05)
    ci2 = ClinicalTrialUtilities.meanDiffEV(mean(m1), var(m1), length(m1), mean(m2), var(m2), length(m2), 0.05)
    @test ci1 == ci2

    #CMH
    #http://www.metafor-project.org/doku.php/analyses:rothman2008
    data = DataFrame(a = Int[], b = Int[], c = Int[], d = Int[])
    push!(data, (8, 98, 5, 115))
    push!(data, (22, 76, 16, 69))
    ci = ClinicalTrialUtilities.cmh(data, alpha = 0.1)
    @test ci.estimate ≈  0.03490026933691816 atol=1E-4
    @test ci.lower    ≈  -0.01757497925425447 atol=1E-4
    @test ci.upper    ≈  0.08737551792809078 atol=1E-4

    ci = ClinicalTrialUtilities.cmh(data, alpha = 0.1, type = :or, logscale = true)
    @test ci.estimate ≈  0.33871867108844556 atol=1E-7 #0.3387187
    @test ci.lower    ≈  -0.1730848826896063 atol=1E-7 #-0.1730849
    @test ci.upper    ≈  0.8505222248664974 atol=1E-7  #0.8505222

    ci = ClinicalTrialUtilities.cmh(data, alpha = 0.1, type = :rr, logscale = true)
    @test ci.estimate ≈  0.28183148420493526 atol=1E-7
    @test ci.lower    ≈  -0.14415538594969263 atol=1E-7
    @test ci.upper    ≈  0.7078183543595631 atol=1E-7
end
