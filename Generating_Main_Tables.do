*********************************************************************************************************************
* 		Paper: Does immigration decrease far-right popularity? Evidence from Finnish municipalities	  	  			*
* 		Author: Jakub Lonsky 											  	      	 		  		 	  			*
*		Journal: Journal of Population Economics (2020)																*
* 		Data Source: Statistics Finland's StatFin Database (https://www.stat.fi/tup/statfin/index_en.html)	   	    *  		  		  
*********************************************************************************************************************
clear
global path "/Users/Lonskyj/Desktop/JPOP Pub. 2020/GitHub - Replication fles"
cd "$path"
global Initial04_Immig EU28Sh04 NonEUSh04 AfricaSh04 AsiaSh04 AmericaSh04 OceaniaSh04  
global Initial04_Other Log_Population04 Density04 FemaleShare04 Share65plus04 Unemploy04 Share_tertiary04 SkillRatio04 Income04 Total_CR_03
global YearFE Year_2006-Year_2015
global YearFE2 Year_2006-Year_2010
global Interaction Year2006_Reg1-Year2015_Reg18
global Interaction2 Year2006_Reg1-Year2010_Reg18
global covar_03 Log_Population_03 Density_03 FemaleShare_03 Share65plus_03 Share_tertiary_03 SkillRatio_03 Total_CR_03 Unemploy_03 Income_03


***********
* Table 2 *
***********
clear
use "Main_Data_FINAL.dta"
estpost summarize National ForeigCitSh91 Population_lag Density_lag FemaleShare_lag Share_tertiary_lag Share65plus_lag SkillRatio_lag Total_CR_lag Unemploy_lag Income_lag, listwise

esttab using "Table2.tex", cells("mean sd min max") noobs replace 
eststo clear


***********
* Table 3 *
***********
clear 
use "Tables36_Data_FINAL.dta"

reg ForeigCitSh03_Delta15 National03 $Initial04_Immig $Initial04_Other _RegionID_2-_RegionID_18, vce(robust)
estadd ysumm 
eststo a1

reg EU28_Delta15 National03 $Initial04_Immig $Initial04_Other _RegionID_2-_RegionID_18, vce(robust)
estadd ysumm 
eststo a2

reg NonEU_Delta15 National03 $Initial04_Immig $Initial04_Other _RegionID_2-_RegionID_18, vce(robust)
estadd ysumm 
eststo a3

reg Africa_Delta15 National03 $Initial04_Immig $Initial04_Other _RegionID_2-_RegionID_18, vce(robust)
estadd ysumm 
eststo a4

reg America_Delta15 National03 $Initial04_Immig $Initial04_Other _RegionID_2-_RegionID_18, vce(robust)
estadd ysumm 
eststo a5

reg Asia_Delta15 National03 $Initial04_Immig $Initial04_Other _RegionID_2-_RegionID_18, vce(robust)
estadd ysumm 
eststo a6

reg Oceania_Delta15 National03 $Initial04_Immig $Initial04_Other _RegionID_2-_RegionID_18, vce(robust)
estadd ysumm 
eststo a7

esttab a1 a2 a3 a4 a5 a6 a7 using "Table3.tex", keep(National03) se star("\dagger" 0.10 * 0.05 ** 0.01 *** 0.001) stats(N r2_a ymean ysd, labels("Observations" "Adjusted R-squared" "Mean of dep. variable" "Standard deviation of dep. variable")) replace
eststo clear


***********
* Table 4 *
***********
clear
use "Main_Data_FINAL.dta"
xtset MuniID Year

xtreg National ForeigCitSh03 $YearFE , fe vce(cluster MuniID)
estadd ysumm 
eststo a1

xtreg National ForeigCitSh03 $YearFE Log_Population_lag Density_lag FemaleShare_lag Share_tertiary_lag Share65plus_lag SkillRatio_lag Total_CR_lag Unemploy_lag Income_lag, fe vce(cluster MuniID)
estadd ysumm
eststo a2
 
xtreg National ForeigCitSh03 $YearFE $Interaction Log_Population_lag Density_lag FemaleShare_lag Share_tertiary_lag Share65plus_lag SkillRatio_lag Total_CR_lag Unemploy_lag Income_lag, fe vce(cluster MuniID)
estadd ysumm
eststo a3
 
xtivreg2 National $YearFE (ForeigCitSh03=CardIV1c), fe cluster(MuniID) ffirst first savefirst savefprefix(first1)
scalar card_0a=e(N)
scalar card_1a=e(widstat)
scalar card_2a=e(archi2p)
estadd scalar fs_1=scalar(card_1a)
estadd scalar fs_2=scalar(card_2a)
estadd ysumm
eststo a4

xtivreg2 National $YearFE Log_Population_lag Density_lag FemaleShare_lag Share65plus_lag Share_tertiary_lag SkillRatio_lag Total_CR_lag Unemploy_lag Income_lag (ForeigCitSh03=CardIV1c), fe cluster(MuniID) ffirst first savefirst savefprefix(first2) 
scalar card_0c=e(N)
scalar card_1c=e(widstat)
scalar card_2c=e(archi2p)
estadd scalar fs_1=scalar(card_1c)
estadd scalar fs_2=scalar(card_2c)
estadd ysumm
eststo a5

xtivreg2 National $YearFE $Interaction Log_Population_lag Density_lag FemaleShare_lag Share65plus_lag Share_tertiary_lag SkillRatio_lag Total_CR_lag Unemploy_lag Income_lag (ForeigCitSh03=CardIV1c), fe cluster(MuniID) ffirst first savefirst savefprefix(first3) 
scalar card_0d=e(N)
scalar card_1d=e(widstat)
scalar card_2d=e(archi2p)
estadd scalar fs_1=scalar(card_1d)
estadd scalar fs_2=scalar(card_2d)
estadd ysumm
eststo a6

esttab a1 a2 a3 a4 a5 a6 using "Table4.tex", keep(ForeigCitSh03) se star("\dagger" 0.10 * 0.05 ** 0.01 *** 0.001) stats(N r2_a ymean ysd fs_1 fs_2, labels("Observations" "Adjusted R-squared" "Mean of dep. variable" "Standard deviation of dep. variable" "Kleibergen-Paap rk Wald F-stat." "Anderson-Rubin chi-sq. test p-val.")) replace
eststo clear
scalar drop _all


***********
* Table 5 *
***********
clear 
use "Table5_Data_FINAL.dta"
xtset MuniID Year_STD

xtivreg2 FD_National $YearFE L_Density L_FemaleShare L_Share65plus L_Share_tertiary L_Log_Population (FD_Immigration_03=IV_Flow_03),fe cluster(MuniID) ffirst first savefirst savefprefix(first1) 
scalar card_0a=e(N)
scalar card_1a=e(widstat)
scalar card_2a=e(archi2p)
estadd scalar fs_1=scalar(card_1a)
estadd scalar fs_2=scalar(card_2a) 
estadd ysumm
eststo a1

xtivreg2 FD_National $YearFE L_Density L_FemaleShare L_Share65plus L_Share_tertiary L_Log_Population L_SkillRatio L_Total_CR  (FD_Immigration_03=IV_Flow_03),fe cluster(MuniID) ffirst first savefirst savefprefix(first2) 
scalar card_0b=e(N)
scalar card_1b=e(widstat)
scalar card_2b=e(archi2p)
estadd scalar fs_1=scalar(card_1b)
estadd scalar fs_2=scalar(card_2b)
estadd ysumm
eststo a2

xtivreg2 FD_National $YearFE L_Density L_FemaleShare L_Share65plus L_Share_tertiary L_Log_Population L_SkillRatio L_Total_CR L_Unemploy L_Income (FD_Immigration_03=IV_Flow_03),fe cluster(MuniID) ffirst first savefirst savefprefix(first3) 
scalar card_0c=e(N)
scalar card_1c=e(widstat)
scalar card_2c=e(archi2p)
estadd scalar fs_1=scalar(card_1c)
estadd scalar fs_2=scalar(card_2c)
estadd ysumm
eststo a3

xtivreg2 FD_National $YearFE L_Density L_FemaleShare L_Share65plus L_Share_tertiary L_Log_Population (FD_Immigration=IV_Flow),fe cluster(MuniID) ffirst first savefirst savefprefix(first4) 
scalar card_0d=e(N)
scalar card_1d=e(widstat)
scalar card_2d=e(archi2p)
estadd scalar fs_1=scalar(card_1d)
estadd scalar fs_2=scalar(card_2d)
estadd ysumm
eststo a4

xtivreg2 FD_National $YearFE L_Density L_FemaleShare L_Share65plus L_Share_tertiary L_Log_Population L_SkillRatio L_Total_CR (FD_Immigration=IV_Flow),fe cluster(MuniID) ffirst first savefirst savefprefix(first5) 
scalar card_0e=e(N)
scalar card_1e=e(widstat)
scalar card_2e=e(archi2p)
estadd scalar fs_1=scalar(card_1e)
estadd scalar fs_2=scalar(card_2e)
estadd ysumm
eststo a5

xtivreg2 FD_National $YearFE L_Density L_FemaleShare L_Share65plus L_Share_tertiary L_Log_Population L_SkillRatio L_Total_CR L_Unemploy L_Income (FD_Immigration=IV_Flow),fe cluster(MuniID) ffirst first savefirst savefprefix(first6) 
scalar card_0f=e(N)
scalar card_1f=e(widstat)
scalar card_2f=e(archi2p)
estadd scalar fs_1=scalar(card_1f)
estadd scalar fs_2=scalar(card_2f)
estadd ysumm
eststo a6

esttab a1 a2 a3 a4 a5 a6 using "Table5.tex", keep(FD_Immigration FD_Immigration_03) se star("\dagger" 0.10 * 0.05 ** 0.01 *** 0.001) stats(N ymean ysd fs_1, labels("Observations" "Mean of dep. variable" "Standard deviation of dep. variable" "Kleibergen-Paap rk Wald F-stat.")) replace
eststo clear
scalar drop _all


***********
* Table 6 *
***********
clear 
use "Tables36_Data_FINAL.dta"

xi: reg DeltaNation03C DeltaForeign i.RegionID $covar_03, vce(robust)
estadd ysumm
eststo a1

xi: reg DeltaKesk99 DeltaForeign i.RegionID $covar_03, vce(robust)
estadd ysumm
eststo a2

xi: reg DeltaNation03C_Perc DeltaForeign_Perc i.RegionID $covar_03, vce(robust)
estadd ysumm
eststo a3

xi: reg DeltaKesk99_Perc DeltaForeign_Perc i.RegionID $covar_03, vce(robust)
estadd ysumm
eststo a4

esttab a1 a2 a3 a4 using "Table6.tex", keep(DeltaForeign DeltaForeign_Perc) se star("\dagger" 0.10 * 0.05 ** 0.01 *** 0.001) stats(N r2_a ymean, labels("Observations" "Adjusted R-squared" "Mean of dep. variable")) replace
eststo clear


***********
* Table 7 *
***********
clear
use "Table7_Data_FINAL1.dta"
xtset MuniID Year

xtreg Finland_IMMIG1 Fcimmig1 Year_2007-Year_2015, fe vce(cluster MuniID)
estadd ysumm
eststo a1

xtivreg2 Finland_IMMIG1 Year_2007-Year_2015 (Fcimmig1=FlowIV), fe cluster(MuniID) ffirst first savefirst savefprefix(first1)
scalar card_0a=e(N)
scalar card_1a=e(widstat)
scalar card_2a=e(archi2p)
estadd scalar fs_1=scalar(card_1a)
estadd scalar fs_2=scalar(card_2a)
estadd ysumm
eststo a2

clear 
use "Table7_Data_FINAL2.dta"
xtset SubregionID Year

xtreg Finland_IMMIG1_Sub Fcimmig1Sub _IYear_2007-_IYear_2015, fe vce(cluster SubregionID)
estadd ysumm
eststo a3

xtivreg2 Finland_IMMIG1_Sub _IYear_2007-_IYear_2015 (Fcimmig1Sub=FlowIV_Sub), fe cluster(SubregionID) ffirst first savefirst savefprefix(first2)
scalar card_0b=e(N)
scalar card_1b=e(widstat)
scalar card_2b=e(archi2p)
estadd scalar fs_1=scalar(card_1b)
estadd scalar fs_2=scalar(card_2b)
estadd ysumm
eststo a4

esttab a1 a2 a3 a4 using "Table7.tex", keep(Fcimmig1 Fcimmig1Sub) se star("\dagger" 0.10 * 0.05 ** 0.01 *** 0.001) stats(N ymean fs_1 fs_2, labels("Observations" "Mean of dep. variable" "Kleibergen-Paap rk Wald F-stat." "Anderson-Rubin chi-sq. test p-val.")) replace

eststo clear
scalar drop _all


***********
* Table 8 *
***********
clear
use "Main_Data_FINAL.dta"
xtset MuniID Year

xtivreg2 National $YearFE $Interaction Log_Population_lag Density_lag FemaleShare_lag Share65plus_lag Share_tertiary_lag SkillRatio_lag Total_CR_lag Unemploy_lag Income_lag (ForeigCitSh03=CardIV1c), fe cluster(MuniID) ffirst first savefirst savefprefix(first1) 
scalar card_0a=e(N)
scalar card_1a=e(widstat)
scalar card_2a=e(archi2p)
estadd scalar fs_1=scalar(card_1a)
estadd scalar fs_2=scalar(card_2a)
estadd ysumm
eststo a1

xtivreg2 Vihr_Votes_Sh $YearFE $Interaction Log_Population_lag Density_lag FemaleShare_lag Share65plus_lag Share_tertiary_lag SkillRatio_lag Total_CR_lag Unemploy_lag Income_lag (ForeigCitSh03=CardIV1c), fe cluster(MuniID) ffirst first savefirst savefprefix(first2) 
scalar card_0b=e(N)
scalar card_1b=e(widstat)
scalar card_2b=e(archi2p)
estadd scalar fs_1=scalar(card_1b)
estadd scalar fs_2=scalar(card_2b)
estadd ysumm
eststo a2

xtivreg2 RKP_Votes_Sh $YearFE $Interaction Log_Population_lag Density_lag FemaleShare_lag Share65plus_lag Share_tertiary_lag SkillRatio_lag Total_CR_lag Unemploy_lag Income_lag (ForeigCitSh03=CardIV1c), fe cluster(MuniID) ffirst first savefirst savefprefix(first3) 
scalar card_0c=e(N)
scalar card_1c=e(widstat)
scalar card_2c=e(archi2p)
estadd scalar fs_1=scalar(card_1c)
estadd scalar fs_2=scalar(card_2c)
estadd ysumm
eststo a3

xtivreg2 Kok_Votes_Sh $YearFE $Interaction Log_Population_lag Density_lag FemaleShare_lag Share65plus_lag Share_tertiary_lag SkillRatio_lag Total_CR_lag Unemploy_lag Income_lag (ForeigCitSh03=CardIV1c), fe cluster(MuniID) ffirst first savefirst savefprefix(first4) 
scalar card_0d=e(N)
scalar card_1d=e(widstat)
scalar card_2d=e(archi2p)
estadd scalar fs_1=scalar(card_1d)
estadd scalar fs_2=scalar(card_2d)
estadd ysumm
eststo a4

xtivreg2 Kesk_Votes_Sh $YearFE $Interaction Log_Population_lag Density_lag FemaleShare_lag Share65plus_lag Share_tertiary_lag SkillRatio_lag Total_CR_lag Unemploy_lag Income_lag (ForeigCitSh03=CardIV1c), fe cluster(MuniID) ffirst first savefirst savefprefix(first5) 
scalar card_0e=e(N)
scalar card_1e=e(widstat)
scalar card_2e=e(archi2p)
estadd scalar fs_1=scalar(card_1e)
estadd scalar fs_2=scalar(card_2e)
estadd ysumm
eststo a5

xtivreg2 SDP_Votes_Sh $YearFE $Interaction Log_Population_lag Density_lag FemaleShare_lag Share65plus_lag Share_tertiary_lag SkillRatio_lag Total_CR_lag Unemploy_lag Income_lag (ForeigCitSh03=CardIV1c), fe cluster(MuniID) ffirst first savefirst savefprefix(first6) 
scalar card_0f=e(N)
scalar card_1f=e(widstat)
scalar card_2f=e(archi2p)
estadd scalar fs_1=scalar(card_1f)
estadd scalar fs_2=scalar(card_2f)
estadd ysumm
eststo a6

xtivreg2 KD_Votes_Sh $YearFE $Interaction Log_Population_lag Density_lag FemaleShare_lag Share65plus_lag Share_tertiary_lag SkillRatio_lag Total_CR_lag Unemploy_lag Income_lag (ForeigCitSh03=CardIV1c), fe cluster(MuniID) ffirst first savefirst savefprefix(first7) 
scalar card_0g=e(N)
scalar card_1g=e(widstat)
scalar card_2g=e(archi2p)
estadd scalar fs_1=scalar(card_1g)
estadd scalar fs_2=scalar(card_2g)
estadd ysumm
eststo a7

esttab a1 a2 a3 a4 a5 a6 a7 using "Table8.tex", keep(ForeigCitSh03) se star("\dagger" 0.10 * 0.05 ** 0.01 *** 0.001) stats(N ymean ysd fs_1, labels("Observations" "Mean of dep. variable" "Standard deviation of dep. variable" "Kleibergen-Paap rk Wald F-stat.")) replace
eststo clear
scalar drop _all


***********
* Table 9 *
***********
clear
use "Main_Data_FINAL.dta"
xtset MuniID Year

xtivreg2 Turnout $YearFE $Interaction Log_Population_lag Density_lag FemaleShare_lag Share65plus_lag Share_tertiary_lag SkillRatio_lag Total_CR_lag Unemploy_lag Income_lag (ForeigCitSh03=CardIV1c), fe cluster(MuniID) ffirst first savefirst savefprefix(first1) 
scalar card_0a=e(N)
scalar card_1a=e(widstat)
scalar card_2a=e(archi2p)
estadd scalar fs_1=scalar(card_1a)
estadd scalar fs_2=scalar(card_2a)
estadd ysumm
eststo a1

xtivreg2 Protest_Votes_Sh $YearFE $Interaction Log_Population_lag Density_lag FemaleShare_lag Share65plus_lag Share_tertiary_lag SkillRatio_lag Total_CR_lag Unemploy_lag Income_lag (ForeigCitSh03=CardIV1c), fe cluster(MuniID) ffirst first savefirst savefprefix(first2) 
scalar card_0b=e(N)
scalar card_1b=e(widstat)
scalar card_2b=e(archi2p)
estadd scalar fs_1=scalar(card_1b)
estadd scalar fs_2=scalar(card_2b)
estadd ysumm
eststo a2

esttab a1 a2 using "Table9.tex", keep(ForeigCitSh03) se star("\dagger" 0.10 * 0.05 ** 0.01 *** 0.001) stats(N ymean ysd fs_1, labels("Observations" "Mean of dep. variable" "Standard deviation of dep. variable" "Kleibergen-Paap rk Wald F-stat.")) replace
eststo clear
scalar drop _all


************
* Table 10 *
************
clear
use "Main_Data_FINAL.dta"
xtset MuniID Year
matrix A = J(2,8,.)

gen LowPopul = 1 - HighPopul
gen ForeigCitSh03H = ForeigCitSh03 * HighPopul
gen ForeigCitSh03L = ForeigCitSh03 * LowPopul
gen CardIV1c_H = CardIV1c * HighPopul
gen CardIV1c_L = CardIV1c * LowPopul
xtivreg2 National $YearFE Log_Population_lag Density_lag FemaleShare_lag Share65plus_lag Share_tertiary_lag SkillRatio_lag Total_CR_lag Unemploy_lag Income_lag (ForeigCitSh03H ForeigCitSh03L = CardIV1c_H CardIV1c_L),fe cluster(MuniID) ffirst first savefirst savefprefix(first1) 
testparm ForeigCitSh03H ForeigCitSh03L, equal 
mat A[1,1]= r(p)
mat A[2,1]= r(chi2)
scalar card_0a=e(N)
scalar card_1a=e(widstat)
scalar card_2a=e(archi2p)
estadd scalar fs_1=scalar(card_1a)
estadd scalar fs_2=scalar(card_2a)
estadd ysumm
eststo a1
drop ForeigCitSh03H ForeigCitSh03L CardIV1c_H CardIV1c_L

gen LowPopDens = 1 - HighPopDens
gen ForeigCitSh03H = ForeigCitSh03 * HighPopDens
gen ForeigCitSh03L = ForeigCitSh03 * LowPopDens
gen CardIV1c_H = CardIV1c * HighPopDens
gen CardIV1c_L = CardIV1c * LowPopDens
xtivreg2 National $YearFE Log_Population_lag Density_lag FemaleShare_lag Share65plus_lag Share_tertiary_lag SkillRatio_lag Total_CR_lag Unemploy_lag Income_lag (ForeigCitSh03H ForeigCitSh03L = CardIV1c_H CardIV1c_L),fe cluster(MuniID) ffirst first savefirst savefprefix(first2) 
testparm ForeigCitSh03H ForeigCitSh03L, equal 
mat A[1,2]= r(p)
mat A[2,2]= r(chi2)
scalar card_0b=e(N)
scalar card_1b=e(widstat)
scalar card_2b=e(archi2p)
estadd scalar fs_1=scalar(card_1b)
estadd scalar fs_2=scalar(card_2b)
estadd ysumm
eststo a2
drop ForeigCitSh03H ForeigCitSh03L CardIV1c_H CardIV1c_L

gen LowImmig = 1 - HighImmig
gen ForeigCitSh03H = ForeigCitSh03 * HighImmig
gen ForeigCitSh03L = ForeigCitSh03 * LowImmig
gen CardIV1c_H = CardIV1c * HighImmig
gen CardIV1c_L = CardIV1c * LowImmig
xtivreg2 National $YearFE Log_Population_lag Density_lag FemaleShare_lag Share65plus_lag Share_tertiary_lag SkillRatio_lag Total_CR_lag Unemploy_lag Income_lag (ForeigCitSh03H ForeigCitSh03L = CardIV1c_H CardIV1c_L),fe cluster(MuniID) ffirst first savefirst savefprefix(first3) 
testparm ForeigCitSh03H ForeigCitSh03L, equal 
mat A[1,3]= r(p)
mat A[2,3]= r(chi2)
scalar card_0c=e(N)
scalar card_1c=e(widstat)
scalar card_2c=e(archi2p)
estadd scalar fs_1=scalar(card_1c)
estadd scalar fs_2=scalar(card_2c)
estadd ysumm
eststo a3
drop ForeigCitSh03H ForeigCitSh03L CardIV1c_H CardIV1c_L

gen LowFinns = 1 - HighFinns
gen ForeigCitSh03H = ForeigCitSh03 * HighFinns
gen ForeigCitSh03L = ForeigCitSh03 * LowFinns
gen CardIV1c_H = CardIV1c * HighFinns
gen CardIV1c_L = CardIV1c * LowFinns
xtivreg2 National $YearFE Log_Population_lag Density_lag FemaleShare_lag Share65plus_lag Share_tertiary_lag SkillRatio_lag Total_CR_lag Unemploy_lag Income_lag (ForeigCitSh03H ForeigCitSh03L = CardIV1c_H CardIV1c_L),fe cluster(MuniID) ffirst first savefirst savefprefix(first4) 
testparm ForeigCitSh03H ForeigCitSh03L, equal 
mat A[1,4]= r(p)
mat A[2,4]= r(chi2)
scalar card_0d=e(N)
scalar card_1d=e(widstat)
scalar card_2d=e(archi2p)
estadd scalar fs_1=scalar(card_1d)
estadd scalar fs_2=scalar(card_2d)
estadd ysumm
eststo a4
drop ForeigCitSh03H ForeigCitSh03L CardIV1c_H CardIV1c_L

gen LowEdu = 1 - HighEdu
gen ForeigCitSh03H = ForeigCitSh03 * HighEdu
gen ForeigCitSh03L = ForeigCitSh03 * LowEdu
gen CardIV1c_H = CardIV1c * HighEdu
gen CardIV1c_L = CardIV1c * LowEdu
xtivreg2 National $YearFE Log_Population_lag Density_lag FemaleShare_lag Share65plus_lag Share_tertiary_lag SkillRatio_lag Total_CR_lag Unemploy_lag Income_lag (ForeigCitSh03H ForeigCitSh03L = CardIV1c_H CardIV1c_L),fe cluster(MuniID) ffirst first savefirst savefprefix(first5) 
testparm ForeigCitSh03H ForeigCitSh03L, equal 
mat A[1,5]= r(p)
mat A[2,5]= r(chi2)
scalar card_0e=e(N)
scalar card_1e=e(widstat)
scalar card_2e=e(archi2p)
estadd scalar fs_1=scalar(card_1e)
estadd scalar fs_2=scalar(card_2e)
estadd ysumm
eststo a5
drop ForeigCitSh03H ForeigCitSh03L CardIV1c_H CardIV1c_L

gen LowSkill = 1 - HighSkill
gen ForeigCitSh03H = ForeigCitSh03 * HighSkill
gen ForeigCitSh03L = ForeigCitSh03 * LowSkill
gen CardIV1c_H = CardIV1c * HighSkill
gen CardIV1c_L = CardIV1c * LowSkill
xtivreg2 National $YearFE Log_Population_lag Density_lag FemaleShare_lag Share65plus_lag Share_tertiary_lag SkillRatio_lag Total_CR_lag Unemploy_lag Income_lag (ForeigCitSh03H ForeigCitSh03L = CardIV1c_H CardIV1c_L),fe cluster(MuniID) ffirst first savefirst savefprefix(first6) 
testparm ForeigCitSh03H ForeigCitSh03L, equal 
mat A[1,6]= r(p)
mat A[2,6]= r(chi2)
scalar card_0f=e(N)
scalar card_1f=e(widstat)
scalar card_2f=e(archi2p)
estadd scalar fs_1=scalar(card_1f)
estadd scalar fs_2=scalar(card_2f)
estadd ysumm
eststo a6
drop ForeigCitSh03H ForeigCitSh03L CardIV1c_H CardIV1c_L

gen LowIncome = 1 - HighIncome
gen ForeigCitSh03H = ForeigCitSh03 * HighIncome
gen ForeigCitSh03L = ForeigCitSh03 * LowIncome
gen CardIV1c_H = CardIV1c * HighIncome
gen CardIV1c_L = CardIV1c * LowIncome
xtivreg2 National $YearFE Log_Population_lag Density_lag FemaleShare_lag Share65plus_lag Share_tertiary_lag SkillRatio_lag Total_CR_lag Unemploy_lag Income_lag (ForeigCitSh03H ForeigCitSh03L = CardIV1c_H CardIV1c_L),fe cluster(MuniID) ffirst first savefirst savefprefix(first7) 
testparm ForeigCitSh03H ForeigCitSh03L, equal 
mat A[1,7]= r(p)
mat A[2,7]= r(chi2)
scalar card_0g=e(N)
scalar card_1g=e(widstat)
scalar card_2g=e(archi2p)
estadd scalar fs_1=scalar(card_1g)
estadd scalar fs_2=scalar(card_2g)
estadd ysumm
eststo a7
drop ForeigCitSh03H ForeigCitSh03L CardIV1c_H CardIV1c_L

gen LowUnempl = 1 - HighUnempl
gen ForeigCitSh03H = ForeigCitSh03 * HighUnempl
gen ForeigCitSh03L = ForeigCitSh03 * LowUnempl
gen CardIV1c_H = CardIV1c * HighUnempl
gen CardIV1c_L = CardIV1c * LowUnempl
xtivreg2 National $YearFE Log_Population_lag Density_lag FemaleShare_lag Share65plus_lag Share_tertiary_lag SkillRatio_lag Total_CR_lag Unemploy_lag Income_lag (ForeigCitSh03H ForeigCitSh03L = CardIV1c_H CardIV1c_L),fe cluster(MuniID) ffirst first savefirst savefprefix(first8) 
testparm ForeigCitSh03H ForeigCitSh03L, equal 
mat A[1,8]= r(p)
mat A[2,8]= r(chi2)
scalar card_0h=e(N)
scalar card_1h=e(widstat)
scalar card_2h=e(archi2p)
estadd scalar fs_1=scalar(card_1h)
estadd scalar fs_2=scalar(card_2h)
estadd ysumm
eststo a8
drop ForeigCitSh03H ForeigCitSh03L CardIV1c_H CardIV1c_L

esttab a1 a2 a3 a4 a5 a6 a7 a8 using "Table10.tex", keep(ForeigCitSh03H ForeigCitSh03L) se star("\dagger" 0.10 * 0.05 ** 0.01 *** 0.001) stats(N ymean ysd fs_1, labels("Observations" "Adjusted R-squared" "Mean of dep. variable" "Standard deviation of dep. variable" "Kleibergen-Paap rk Wald F-stat.")) replace
matrix list A
matrix drop A
eststo clear
scalar drop _all
drop _all


************
* Table 11 *
************
clear
use "Table11_Data_FINAL.dta"
xtset MuniID Year

xtivreg2 Total_Tax_Rev_PC $YearFE2 $Interaction2 Log_Population_lag Density_lag FemaleShare_lag Share65plus_lag Share_tertiary_lag SkillRatio_lag Unemploy_lag Income_lag (ForeigCitSh03=CardIV1c), fe cluster(MuniID) ffirst first savefirst savefprefix(first1) 
scalar card_0a=e(N)
scalar card_1a=e(widstat)
scalar card_2a=e(archi2p)
estadd scalar fs_1=scalar(card_1a)
estadd scalar fs_2=scalar(card_2a)
estadd ysumm
eststo a1

xtivreg2 Muni_Income_Tax_PC $YearFE2 $Interaction2 Log_Population_lag Density_lag FemaleShare_lag Share65plus_lag Share_tertiary_lag SkillRatio_lag Unemploy_lag Income_lag (ForeigCitSh03=CardIV1c), fe cluster(MuniID) ffirst first savefirst savefprefix(first2) 
scalar card_0b=e(N)
scalar card_1b=e(widstat)
scalar card_2b=e(archi2p)
estadd scalar fs_1=scalar(card_1b)
estadd scalar fs_2=scalar(card_2b)
estadd ysumm
eststo a2

xtivreg2 Property_Tax_PC $YearFE2 $Interaction2 Log_Population_lag Density_lag FemaleShare_lag Share65plus_lag Share_tertiary_lag SkillRatio_lag Unemploy_lag Income_lag (ForeigCitSh03=CardIV1c), fe cluster(MuniID) ffirst first savefirst savefprefix(first3) 
scalar card_0c=e(N)
scalar card_1c=e(widstat)
scalar card_2c=e(archi2p)
estadd scalar fs_1=scalar(card_1c)
estadd scalar fs_2=scalar(card_2c)
estadd ysumm
eststo a3

xtivreg2 Corporate_Inc_Tax_PC $YearFE2 $Interaction2 Log_Population_lag Density_lag FemaleShare_lag Share65plus_lag Share_tertiary_lag SkillRatio_lag Unemploy_lag Income_lag (ForeigCitSh03=CardIV1c), fe cluster(MuniID) ffirst first savefirst savefprefix(first4) 
scalar card_0d=e(N)
scalar card_1d=e(widstat)
scalar card_2d=e(archi2p)
estadd scalar fs_1=scalar(card_1d)
estadd scalar fs_2=scalar(card_2d)
estadd ysumm
eststo a4

xtivreg2 Social_HC_Spend_PC $YearFE2 $Interaction2 Log_Population_lag Density_lag FemaleShare_lag Share65plus_lag Share_tertiary_lag SkillRatio_lag Unemploy_lag Income_lag (ForeigCitSh03=CardIV1c), fe cluster(MuniID) ffirst first savefirst savefprefix(first5) 
scalar card_0e=e(N)
scalar card_1e=e(widstat)
scalar card_2e=e(archi2p)
estadd scalar fs_1=scalar(card_1e)
estadd scalar fs_2=scalar(card_2e)
estadd ysumm
eststo a5

xtivreg2 Edu_Culture_Spend_PC $YearFE2 $Interaction2 Log_Population_lag Density_lag FemaleShare_lag Share65plus_lag Share_tertiary_lag SkillRatio_lag Unemploy_lag Income_lag (ForeigCitSh03=CardIV1c), fe cluster(MuniID) ffirst first savefirst savefprefix(first6) 
scalar card_0f=e(N)
scalar card_1f=e(widstat)
scalar card_2f=e(archi2p)
estadd scalar fs_1=scalar(card_1f)
estadd scalar fs_2=scalar(card_2f)
estadd ysumm
eststo a6

esttab a1 a2 a3 a4 a5 a6 using "Table11.tex", keep(ForeigCitSh03) se star("\dagger" 0.10 * 0.05 ** 0.01 *** 0.001) stats(N ymean ysd fs_1, labels("Observations" "Mean of dep. variable" "Standard deviation of dep. variable" "Kleibergen-Paap rk Wald F-stat.")) replace
eststo clear
scalar drop _all



