
clear
clear matrix

set mem 4g

set more off


*cd "Change to Directory Name where you have put administrative data"
cd "Insert Directory"

use "washington_administrative_testing.dta", clear

label variable low_score "BAC"


histogram low_score,  frequency discrete  title("BAC Histogram") scheme(s2mono) lwidth(vvvthin) fcolor(gray) lcolor(gray) xline(.08) xline(.15)
graph save figure1.gph, replace
graph export figure1.eps, replace

histogram low_score if low_score>=.05 & low_score<=.11, frequency discrete scheme(s2mono) title(".08 Threshold") fcolor(gray) lcolor(gray) xlabel(.05(.01).11) xline(.08) lwidth(none)
graph save hist_1.gph, replace
histogram low_score if low_score>=.12 & low_score<=.18, frequency discrete scheme(s2mono) title(".15 Threshold") fcolor(gray) lcolor(gray) xlabel(.12(.01).18) xline(.15) lwidth(none)
graph save hist_2.gph, replace

graph combine hist_1.gph hist_2.gph, scheme(s2mono) col(1) title("Observation Counts at Thresholds")
graph export app_figure2.eps, replace




histogram diff if abs(diff)<.1,  frequency discrete scheme(s2mono)
graph save app_figure1.gph, replace
graph export app_figure1.eps, replace


drop if low_score>.20
gen fitted=.
reg recidiv low_score if low_score>=.03 & low_score<.08
predict xb_1 if low_score>=.03 & low_score<.08, xb 
replace fitted=xb_1 if low_score>=.03 & low_score<.08


reg recidiv low_score if low_score>=.08 & low_score<=.15
predict xb_2 if low_score>=.08 & low_score<.15, xb 
replace fitted=xb_2 if low_score>=.08 & low_score<=.15

reg recidiv low_score if low_score>=.151 
predict xb_3 if low_score>=.151, xb
replace fitted=xb_3 if low_score>=.151 
drop xb_*

gen fitted_acc=.
reg acc low_score if low_score>=.03 & low_score<.08
predict xb_1 if low_score>=.03 & low_score<.08, xb 
replace fitted_acc=xb_1 if low_score>=.03 & low_score<.08

reg acc low_score if low_score>.08 & low_score<.151
predict xb_2 if low_score>=.08 & low_score<.151, xb 
replace fitted_acc=xb_2 if low_score>=.08 & low_score<.151

reg acc low_score if low_score>.151 
predict xb_3 if low_score>.151, xb
replace fitted_acc=xb_3 if low_score>.151 

drop xb_*

gen fitted_prior=.
reg prior low_score if low_score>=.03 & low_score<.08
predict xb_1 if low_score>=.03 & low_score<.08, xb 
replace fitted_prior=xb_1 if low_score>=.03 & low_score<.08

reg prior low_score if low_score>.08 & low_score<.151
predict xb_2 if low_score>=.08 & low_score<.151, xb 
replace fitted_prior=xb_2 if low_score>=.08 & low_score<.151

reg prior low_score if low_score>=.151 
predict xb_3 if low_score>=.151, xb
replace fitted_prior=xb_3 if low_score>=.151 
drop xb_*
gen fitted_white=.
reg white low_score if low_score>=.03 & low_score<.08
predict xb_1 if low_score>=.03 & low_score<.08, xb 
replace fitted_white=xb_1 if low_score>=.03 & low_score<.08

reg white low_score if low_score>.08 & low_score<=.151
predict xb_2 if low_score>=.08 & low_score<.151, xb 
replace fitted_white=xb_2 if low_score>=.08 & low_score<.151

reg white low_score if low_score>=.151 
predict xb_3 if low_score>=.151, xb
replace fitted_white=xb_3 if low_score>=.151

drop xb_*
gen fitted_male=.
reg male low_score if low_score>=.03 & low_score<.08
predict xb_1 if low_score>=.03 & low_score<.08, xb 
replace fitted_male=xb_1 if low_score>=.03 & low_score<.08

reg male low_score if low_score>.08 & low_score<.151
predict xb_2 if low_score>=.08 & low_score<.151, xb 
replace fitted_male=xb_2 if low_score>=.08 & low_score<.151

reg male low_score if low_score>=.151 
predict xb_3 if low_score>=.151, xb
replace fitted_male=xb_3 if low_score>=.151 

drop xb_*
gen fitted_test=.
reg pbt_test low_score if low_score>=.03 & low_score<.08
predict xb_1 if low_score>=.03 & low_score<.08, xb 
replace fitted_test=xb_1 if low_score>=.03 & low_score<.08

reg pbt_test low_score if low_score>=.08 & low_score<.151
predict xb_2 if low_score>=.08 & low_score<.151, xb 
replace fitted_test=xb_2 if low_score>=.08 & low_score<.151

reg pbt_test low_score if low_score>=.151 
predict xb_3 if low_score>=.151, xb
replace fitted_test=xb_3 if low_score>=.151 

drop xb_*
gen fitted_pbt=.
reg PBTResult low_score if low_score>=.03 & low_score<.08
predict xb_1 if low_score>=.03 & low_score<.08, xb 
replace fitted_pbt=xb_1 if low_score>=.03 & low_score<.08

reg PBTResult low_score if low_score>=.08 & low_score<.151
predict xb_2 if low_score>=.08 & low_score<.151, xb 
replace fitted_pbt=xb_2 if low_score>=.08 & low_score<.151

reg PBTResult low_score if low_score>=.151 
predict xb_3 if low_score>=.151, xb
replace fitted_pbt=xb_3 if low_score>=.151 

drop xb_*
gen fitted_age=.
reg age low_score if low_score>=.03 & low_score<.08
predict xb_1 if low_score>=.03 & low_score<.08, xb 
replace fitted_age=xb_1 if low_score>=.03 & low_score<.08

reg age low_score if low_score>=.08 & low_score<.151
predict xb_2 if low_score>=.08 & low_score<.151, xb 
replace fitted_age=xb_2 if low_score>=.08 & low_score<.151

reg age low_score if low_score>=.151 
predict xb_3 if low_score>=.151, xb
replace fitted_age=xb_3 if low_score>=.151 

replace low_score=low_score_mod/1000




collapse (sum) obs (mean) underage missing fitted fitted_acc fitted_age fitted_male fitted_prior fitted_white fitted_pbt fitted_test pbt_test PBTResult acc prior total_stops acc_recid age male white hisp black indian recidivism total_dui total_acc recid_nodui recid_agg recid_dui, by(low_score



label variable recidiv "Recidivism"
label variable low_score "BAC"
label variable white "White"
label variable male "Male"
label variable prior "Prior Stops"
label variable total_stops "Police Experience"
label variable acc "Accident Involved"

destring PBTResult, replace


scatter total_acc low_score if low_score<.20 & low_score>.03, xline(.079) xline(.151) ylabel(0.0(0.1)0.2) title("")
scatter total_dui low_score if low_score<.20 & low_score>.03, xline(.079) xline(.151) ylabel(0.05(0.1)0.2)
scatter acc_recid low_score if low_score<.20 & low_score>.03, xline(.079) xline(.151) 

twoway (scatter fitted low_score if low_score>=.08 & low_score<=.15, scheme(s2mono) lcolor(black) msize(0) xscale(range(.03 .20)) xlabel(.05(.05).20)  lcolor(black) connect(1)) (scatter fitted low_score if low_score>.15 & low_score<=.20,lcolor(black) msize(0) xscale(range(.03 .20)) xlabel(.05(.05).20) connect(1)) (scatter fitted low_score if low_score<.079 & low_score>=.03, lcolor(black) msize(0) xscale(range(.03 .20)) xlabel(.05(.05).20) connect(1)) (scatter recidiv low_score if low_score<.20 & low_score>=.03, msymbol(Oh) mfcolor(none) xline(.079) xline(.1505)  title("All Potential Offenders") legend(label(1 "Fitted" ) label(4 "Recidivism") order(1 4)) xscale(range(.03 .20)) xlabel(.05(.05).20))
graph save bac_recid.gph, replace
graph export bac_recid.png, replace 


rename acc  accident

twoway (scatter fitted_acc low_score if low_score>=.08 & low_score<=.15, scheme(s2mono) lcolor(black) msize(0) xscale(range(.03 .20)) xlabel(.05(.05).20)  lcolor(black) connect(1)) (scatter fitted_acc low_score if low_score>.15 & low_score<=.20,lcolor(black) msize(0) xscale(range(.03 .20)) xlabel(.05(.05).20) connect(1)) (scatter fitted_acc low_score if low_score<=.08 & low_score>=.03, lcolor(black) msize(0) xscale(range(.03 .20)) xlabel(.05(.05).20) connect(1)) (scatter accident low_score if low_score<.20 & low_score>=.03,  msymbol(Oh) mfcolor(none) xline(.079) xline(.151)  title("Accident at Scene") legend(label(1 "Fitted" ) label(4 "Accident") order(1 4)) xscale(range(.03 .20)) xlabel(.05(.05).20))
graph save acc_bac.gph, replace

twoway (scatter fitted_male low_score if low_score>=.08 & low_score<=.15,  scheme(s2mono) lcolor(black) msize(0) xscale(range(.03 .20)) xlabel(.05(.05).20)  lcolor(black) connect(1)) (scatter fitted_male low_score if low_score>.15 & low_score<=.20,lcolor(black) msize(0) xscale(range(.03 .20)) xlabel(.05(.05).20) connect(1)) (scatter fitted_male low_score if low_score<=.08 & low_score>=.03, lcolor(black) msize(0) xscale(range(.03 .20)) xlabel(.05(.05).20) connect(1)) (scatter male low_score if low_score<.20 & low_score>=.03,  msymbol(Oh) mfcolor(none) xline(.079) xline(.151)  title("Male") legend(label(1 "Fitted" ) label(4 "Male") order(1 4)) xscale(range(.03 .20)) xlabel(.05(.05).20))
graph save male_bac.gph, replace

twoway (scatter fitted_white low_score if low_score>=.08 & low_score<=.15, scheme(s2mono) lcolor(black) msize(0) xscale(range(.03 .20)) xlabel(.05(.05).20)  lcolor(black) connect(1)) (scatter fitted_white low_score if low_score>.15 & low_score<=.20,lcolor(black) msize(0) xscale(range(.03 .20)) xlabel(.05(.05).20) connect(1)) (scatter fitted_white low_score if low_score<=.08 & low_score>=.03, lcolor(black) msize(0) xscale(range(.03 .20)) xlabel(.05(.05).20) connect(1)) (scatter white low_score if low_score<.20 & low_score>=.03,  msymbol(Oh) mfcolor(none) xline(.079) xline(.151)  title("White") legend(label(1 "Fitted" ) label(4 "White") order(1 4)) xscale(range(.03 .20)) xlabel(.05(.05).20))
graph save white_bac.gph, replace

twoway (scatter fitted_age low_score if low_score>=.08 & low_score<=.15, scheme(s2mono) lcolor(black) msize(0) xscale(range(.03 .20)) xlabel(.05(.05).20)  lcolor(black) connect(1)) (scatter fitted_age low_score if low_score>.15 & low_score<=.20,lcolor(black) msize(0) xscale(range(.03 .20)) xlabel(.05(.05).20) connect(1)) (scatter fitted_age low_score if low_score<=.08 & low_score>=.03, lcolor(black) msize(0) xscale(range(.03 .20)) xlabel(.05(.05).20) connect(1)) (scatter age low_score if low_score<.20 & low_score>=.03, xline(.079)  msymbol(Oh) mfcolor(none) xline(.151)  title("Age") legend(label(1 "Fitted" ) label(4 "Age") order(1 4)) xscale(range(.03 .20)) xlabel(.05(.05).20))
graph save age_bac.gph, replace

twoway (scatter fitted_test low_score if low_score>=.08 & low_score<=.15, scheme(s2mono) lcolor(black) msize(0) xscale(range(.03 .20)) xlabel(.05(.05).20)  lcolor(black) connect(1)) (scatter fitted_test low_score if low_score>.15 & low_score<=.20,lcolor(black) msize(0) xscale(range(.03 .20)) xlabel(.05(.05).20) connect(1)) (scatter fitted_test low_score if low_score<=.08 & low_score>=.03, lcolor(black) msize(0) xscale(range(.03 .20)) xlabel(.05(.05).20) connect(1)) (scatter pbt_test low_score if low_score<.20 & low_score>=.03, xline(.079)  msymbol(Oh) mfcolor(none) xline(.151)  title("PBT") legend(label(1 "Fitted" ) label(4 "PBT Test") order(1 4)) xscale(range(.03 .20)) xlabel(.05(.05).20))
graph save test_bac.gph, replace
d
twoway (scatter fitted_pbt low_score if low_score>=.08 & low_score<=.15, scheme(s2mono) lcolor(black) msize(0) xscale(range(.03 .20)) xlabel(.05(.05).20)  lcolor(black) connect(1)) (scatter fitted_pbt low_score if low_score>.15 & low_score<=.20,lcolor(black) msize(0) xscale(range(.03 .20)) xlabel(.05(.05).20) connect(1)) (scatter fitted_pbt low_score if low_score<=.08 & low_score>=.03, lcolor(black) msize(0) xscale(range(.03 .20)) xlabel(.05(.05).20) connect(1)) (scatter PBTResult low_score if low_score<.20 & low_score>=.03, xline(.079)  msymbol(Oh) mfcolor(none) xline(.151)  title("PBT Result") legend(label(1 "Fitted" ) label(4 "PBT Result") order(1 4)) xscale(range(.03 .20)) xlabel(.05(.05).20))
graph save pbt_bac.gph, replace

twoway (scatter fitted_prior low_score if low_score>=.08 & low_score<=.15, scheme(s2mono) lcolor(black) msize(0) xscale(range(.03 .20)) xlabel(.05(.05).20)  lcolor(black) connect(1)) (scatter fitted_prior low_score if low_score>.15 & low_score<=.20,lcolor(black) msize(0) xscale(range(.03 .20)) xlabel(.05(.05).20) connect(1)) (scatter fitted_prior low_score if low_score<=.08 & low_score>=.03, lcolor(black) msize(0) xscale(range(.03 .20)) xlabel(.05(.05).20) connect(1)) (scatter prior low_score if low_score<.20 & low_score>=.03,  msymbol(Oh) xline(.079) xline(.151)  mfcolor(none) title("Prior Offenses") legend(label(1 "Fitted" ) label(4 "Prior") order(1 4)) xscale(range(.03 .20)) xlabel(.05(.05).20))
graph save prior_bac.gph, replace
scatter total_stops low_score if low_score<.20 & low_score>=.03, xline(.079) xline(.151) 


graph combine acc_bac.gph  male_bac.gph age_bac.gph white_bac.gph prior_bac.gph pbt_bac.gph, scheme(s2mono)
graph export figure2.eps, replace


graph combine bac_recid.gph bac_recid_first.gph bac_recid_repeat.gph, scheme(s2mono) col(1) ysize(10) xsize(7)
graph export figure3.eps, replace

