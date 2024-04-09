
clear
clear matrix

set mem 4g

set more off


*cd "Change to Directory Name where you have put administrative data"
cd "Insert Directory"

use "washington_administrative_testing.dta", clear

label variable low_score "BAC"

 
local poly score8_1 score8_1int male white black hisp c_* a_* y_*


*keep if offense==1

local y=1
foreach x in recid_90 recid_365 recid_730 recid_1460 {

*gen lower=Date-`y'
*gen upper=Date


local out dui

eststo hazd_`y': quietly reg `x' `out' `poly' if abs(score8_1)<=.05, cluster(score8_1)
local y=`y'+1

}

local y=1
foreach x in recid_90 recid_365 recid_730 recid_1460 {

*gen lower=Date-`y'
*gen upper=Date


local out  agg_dui

eststo haza_`y': quietly reg `x' `out' `poly' if abs(score15_1)<=.05, cluster(score15_1)
local y=`y'+1

}

esttab hazd_1 hazd_2 hazd_3 hazd_4, keep(dui _cons) se

esttab haza_1 haza_2 haza_3 haza_4, keep(agg_dui _cons) se

sum recid_90 recid_365 recid_730 recid_1460 if low_score<=.079 & low_score>=.075
sum recid_90 recid_365 recid_730 recid_1460 if low_score<=.149 & low_score>=.145
