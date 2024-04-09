
clear
clear matrix

set mem 4g

set more off


*cd "Change to Directory Name where you have put administrative data"
cd "Insert Directory"

use "washington_administrative_testing_linkd_courts.dta", clear

label variable low_score "BAC"



rdqtese fine_paid dui if abs(rd)<.050, running(rd) quantiles(.5 .75 .9 .95) 
rdqtese fine dui if abs(rd)<.050, running(rd) quantiles(.5 .75 .9 .95) 
rdqtese jail dui if abs(rd)<.050, running(rd) quantiles(.5 .75 .9 .95) 
rdqtese prob_length dui if abs(rd)<.050, running(rd) quantiles(.5 .75 .9 .95) 


rdqtese fine_paid agg if abs(ra)<.050, running(ra) quantiles(.5 .75 .9 .95) 
rdqtese fine agg if abs(ra)<.050, running(ra) quantiles(.5 .75 .9 .95) 
rdqtese jail agg if abs(ra)<.050, running(ra) quantiles(.5 .75 .9 .95) 

rdqtese prob_length agg if abs(ra)<.050, running(ra) quantiles(.5 .75 .9 .95) 
*/







foreach x in fine fine_paid jail probation prob_length alcohol_assess victims_panel alcohol_treatment aa other_fine susp susp_length monitor {
*reg `x' dui rd rd_int if abs(rd)<=.010, robust
*reg `x' dui rd rd_int if abs(rd)<=.025, robust
reg `x' dui rd rd_int if abs(rd)<=.050, robust
sum `x' if bac<.08 & bac>.078
sum `x' if bac<.08 & bac>.078,d 
reg `x' rd if rd<0, robust
predict yl_`x', xb
replace yl_`x'=. if bac>.08
reg `x' rd if rd>=0, robust
predict yr_`x', xb
replace yr_`x'=. if rd<0
replace yr_`x'=. if ra>0
}

foreach x in fine fine_paid jail probation prob_length victims_panel alcohol_assess alcohol_treatment aa  monitor susp susp_length{
*reg `x' agg ra ra_int if abs(ra)<=.010 , robust
*reg `x' agg ra ra_int if abs(ra)<=.025 , robust
reg `x' agg ra ra_int if abs(ra)<=.050, robust
reg `x' ra if bac>=.15 & bac<=.20, robust
sum `x' if bac<.150 & bac>.148
sum `x' if bac<.150 & bac>.148,d

predict ya_`x', xb
replace ya_`x'=. if ra<0 | bac>.20
reg `x' ra if bac>=.10 & bac<=.15, robust
predict yla_`x', xb
replace yla_`x'=. if bac<.08 | bac>.15
}


local mod=.010

gen mod_bac=mod(bac,`mod')
*tab mod
replace mod_bac=0 if mod_bac==`mod'
replace bac=bac-mod_bac




replace bac=round(bac, .01)

drop if bac<.04 | bac>.20

collapse (mean) yl_* yr_* yla_* ya_* susp amended aa charges dismissed not_guilty fine* jail* alcohol_* probation prob_length victims_panel other_fine monitor lic_surr susp_length*, by(bac)  



gen dui=0
replace dui=1 if bac>=.08

gen rd=bac-.08
gen rd_int=rd*dui

gen agg=0
replace agg=1 if bac>=.15
gen ra=bac-.15
gen ra_int=ra*agg


twoway (scatter yl_fine bac,connect(l) msymbol(none) legend(off)) (scatter yla_fine bac,connect(l) lstyle(solid) msymbol(none)) (scatter ya_fine bac, lstyle(solid) connect(l) msymbol(none)) (scatter fine bac if bac<.21 & bac>=.040, scheme(s1mono) xline(.080) xline(.150) title("Fine") ytitle("") yla(, ang(h))  mfcolor(none) msize(2) lcolor(black))
graph save fine.gph, replace
twoway (scatter yl_fine_paid bac,connect(l) msymbol(none) legend(off)) (scatter yla_fine_paid bac,connect(l) lstyle(solid) msymbol(none)) (scatter ya_fine_paid bac, lstyle(solid) connect(l) msymbol(none)) (scatter fine_paid bac if bac<.21 & bac>=.040, scheme(s2mono) xline(.080) xline(.150) title("Fine Paid")  mstyle(circle) ytitle("") yla(, ang(h))  mfcolor(none) msize(2) lcolor(black)) 
graph save fine_paid.gph, replace
scatter fine_held bac if bac<.21 & bac>=0.040, scheme(s2mono) xline(.080) xline(.150) title("Fine Held") ytitle("") yla(, ang(h))  mfcolor(none) msize(2) lcolor(black)
graph save fine_held.gph, replace
scatter jail_held bac if bac<.21 & bac>=.040, scheme(s1mono) xline(.080) xline(.150) title("Jail Held") ylabel(0(.25)1) ytitle("") yla(, ang(h))  mfcolor(none) msize(2) lcolor(black)
twoway (scatter yl_jail bac,connect(l) msymbol(none) legend(off)) (scatter yla_jail  bac,connect(l) lstyle(solid) msymbol(none)) (scatter ya_jail bac, lstyle(solid) connect(l) msymbol(none)) (scatter jail bac if bac<.21 & bac>.040, scheme(s2mono) xline(.080) xline(.150) title("Jail") yla(, ang(h)) mfcolor(none) mstyle(circle) msize(2) lcolor(black))
graph save jail.gph, replace
twoway (scatter yl_victims_panel bac,connect(l) msymbol(none) legend(off)) (scatter yla_victims_panel bac,connect(l) lstyle(solid) msymbol(none)) (scatter ya_victims_panel bac, lstyle(solid) connect(l) msymbol(none)) (scatter victims_panel bac if bac<.21 & bac>=.040, scheme(s2mono) xline(.080) xline(.150) title("Victims Panel") ylabel(0(.25)1) ytitle("") yla(, ang(h)) mfcolor(none) mstyle(circle) msize(2) lcolor(black))
graph save victims_panel.gph, replace
 twoway (scatter yl_alcohol_treatment bac,connect(l) msymbol(none) legend(off)) (scatter yla_alcohol_treatment bac,connect(l) lstyle(solid) msymbol(none)) (scatter ya_alcohol_treatment bac, lstyle(solid) connect(l) msymbol(none)) (scatter alcohol_treatment bac if bac<.21 & bac>=.040, scheme(s2mono) xline(.080) xline(.150) title("Alc. Treatment") ylabel(0(.25)1) ytitle("") yla(, ang(h))  mfcolor(none) mstyle(circle) msize(2) lcolor(black))
graph save alc_treat.gph, replace
twoway (scatter yl_alcohol_assess bac,connect(l) msymbol(none) legend(off)) (scatter yla_alcohol_assess bac,connect(l) lstyle(solid) msymbol(none)) (scatter ya_alcohol_assess bac, lstyle(solid) connect(l) msymbol(none)) (scatter alcohol_assess bac if bac<.21 & bac>=.040, scheme(s2mono) xline(.080) xline(.150) title("Alc. Assess") ylabel(0(.25)1) ytitle("") yla(, ang(h))  mfcolor(none) mstyle(circle) msize(2) lcolor(black))
graph save alc_ass.gph, replace 
twoway (scatter yl_aa bac,connect(l) msymbol(none) legend(off)) (scatter yla_aa bac,connect(l) lstyle(solid) msymbol(none)) (scatter ya_aa bac, lstyle(solid) connect(l) msymbol(none)) (scatter aa bac if bac<.21 & bac>=.040, scheme(s2mono) xline(.080) xline(.150) title("AA") ylabel(0(.25)1) ytitle("") yla(, ang(h))  mfcolor(none) mstyle(circle) msize(2) lcolor(black))
graph save alc_aa.gph, replace
twoway (scatter yl_probation bac,connect(l) msymbol(none) legend(off)) (scatter yla_probation bac,connect(l) lstyle(solid) msymbol(none)) (scatter ya_probation bac, lstyle(solid) connect(l) msymbol(none)) (scatter probation bac if bac<.21 & bac>=.040, scheme(s2mono) xline(.080) xline(.150) title("Probation") ylabel(0(.25)1) ytitle("") yla(, ang(h))  mfcolor(none) mstyle(circle) msize(2) lcolor(black))
graph save alc_probation.gph, replace

twoway (scatter yl_prob_length bac,connect(l) msymbol(none) legend(off)) (scatter yla_prob_length bac,connect(l) lstyle(solid) msymbol(none)) (scatter ya_prob_length bac, lstyle(solid) connect(l) msymbol(none)) (scatter prob_length bac if bac<.21 & bac>=.040, scheme(s2mono) xline(.080) xline(.150) title("Probation Length")  ytitle("") yla(, ang(h))  mfcolor(none) mstyle(circle) msize(2) lcolor(black))
graph save prob_length.gph, replace 

twoway (scatter yl_monitor bac,connect(l) msymbol(none) legend(off)) (scatter yla_monitor bac,connect(l) lstyle(solid) msymbol(none)) (scatter ya_monitor bac, lstyle(solid) connect(l) msymbol(none))(scatter monitor bac if bac<.21 & bac>=.040, scheme(s2mono) xline(.080) xline(.150) title("Monitor") ylabel(0(.25)1) ytitle("")  yla(, ang(h))  mfcolor(none) mstyle(circle) msize(2) lcolor(black))
graph save monitor.gph, replace


twoway (scatter yl_susp bac,connect(l) msymbol(none) legend(off)) (scatter yla_susp bac,connect(l) lstyle(solid) msymbol(none)) (scatter ya_susp bac, lstyle(solid) connect(l) msymbol(none))(scatter susp bac if bac<.21 & bac>=.040, scheme(s2mono) xline(.080) xline(.150) title("Court Ordered""Lic. Suspension")  ytitle("")  yla(, ang(h))  mfcolor(none) mstyle(circle) msize(2) lcolor(black))
graph save susp.gph, replace
twoway (scatter yl_susp_length bac,connect(l) msymbol(none) legend(off)) (scatter yla_susp_length bac,connect(l) lstyle(solid) msymbol(none)) (scatter ya_susp_length bac, lstyle(solid) connect(l) msymbol(none)) (scatter susp_length bac if bac<.21 & bac>=.040, scheme(s2mono) xline(.080) xline(.150) title("Suspension Length")  ytitle("")  yla(, ang(h))  mfcolor(none) mstyle(circle) msize(2) lcolor(black))
graph save susp_length.gph, replace



graph combine fine_paid.gph jail.gph alc_probation.gph prob_length.gph victims_panel.gph alc_ass.gph alc_treat.gph alc_aa.gph monitor.gph susp.gph susp_length.gph, scheme(s2mono)  
 
graph export first_stages.eps, replace
