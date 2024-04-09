
clear
clear matrix

set mem 4g

set more off


*cd "Change to Directory Name where you have put administrative data"
cd "Insert Directory"

use "washington_administrative_testing.dta", clear

label variable low_score "BAC"

 
local poly score8_1 score8_2 male white black hisp c_*

forvalues x=10(10)2200{
capture drop recid_`x'
quietly gen recid_`x'=0 
quietly replace recid_`x'=1 if recid_date-Date<`x' & recid_date!=.


quietly reg recid_`x' dui `poly' if abs(score8_1)<.05, cluster(id)
gen b_`x'=_b[dui]
gen sd_`x'=_se[dui]
gen up_`x'=b_`x'+2*sd_`x'
gen low_`x'=b_`x'-2*sd_`x'
replace recid_`x'=. if low_score<.08 | low_score>.15
}

drop recid_date

collapse (mean) b_* up_* low_* recid_*

gen id=1

reshape long b_ up_ low_ recid_, i(id) j(time)

tsset time

label variable time "Recidivism Window, in Days"
label variable b_ "Est. Effect"
label variable up_ "95% Upp. Bound"
label variable low_ "95% Low Bound"
label variable recid_ "Average Recidivism"


twoway (tsline b_, title("Estimated Prob. Effect")) (tsline up_, lpattern(dash)) (tsline low_, lpattern(dash) scheme(s2mono) ttitle("Recividism Window, in Days") legend(size(small) cols(3) label(1 "Est. Effect") label(3 "95% Low Bound") order(1 3))) 
graph save estimated_effects_first.gph, replace 
capture gen elas=b_/recid_



tsline recid, title("Average Recivisim""No Prior Tests") scheme(s2mono)
graph save recid_rate_first.gph, replace

replace elas=. if elas>.1

label variable elas "Est. Elasticity"

tsline elas, ylabel(-.5(.1).1) title("Estimated Elasticity") scheme(s2mono)
graph save elas_first.gph, replace

