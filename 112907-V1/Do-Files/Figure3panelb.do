clear
clear matrix

set mem 4g

set more off



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

collapse (sum) obs (mean) fitted acc prior total_stops acc_recid male white hisp black indian recidivism total_dui total_acc recid_nodui recid_agg recid_dui, by(low_score)



label variable recidiv "Recidivism"
label variable low_score "BAC"
label variable white "White"
label variable male "Male"
label variable prior "Prior Stops"
label variable total_stops "Police Experience"
label variable acc "Accident Involved"

twoway (scatter fitted low_score if low_score>=.08 & low_score<=.15, lcolor(black) msize(0) xscale(range(.03 .20)) xlabel(.05(.05).20)  lcolor(black) connect(1)) (scatter fitted low_score if low_score>.15 & low_score<=.20,lcolor(black) msize(0) xscale(range(.03 .20)) xlabel(.05(.05).20) connect(1)) (scatter fitted low_score if low_score<.079 & low_score>=.03, lcolor(black) msize(0) xscale(range(.03 .20)) xlabel(.05(.05).20) connect(1)) (scatter recidiv low_score if low_score<.20 & low_score>=.03, xline(.079) xline(.151) mfcolor(none) scheme(s2mono)  msymbol(Oh) title("No Prior Stops") legend(label(1 "Fitted" ) label(4 "Recidivism") order(1 4)) xscale(range(.03 .20)) xlabel(.05(.05).20))
graph save bac_recid_first.gph, replace 
graph export bac_recid_first.png, replace 



