
clear
clear matrix

set mem 4g

set more off


*cd "Change to Directory Name where you have put administrative data"
cd "Insert Directory"

use "washington_administrative_testing.dta", clear

label variable low_score "BAC"

local b=50




*keep if offense==1

local y=1

local b=50

drop if recidivism==.

foreach x in male white prior acc age pbt_bac{

*score8_2 score8_2int

local poly score8_1 score8_1int 

eststo model_char`y': quietly reg `x' dui `poly' if abs(score8_1)<=`b', cluster(score8_1)


*score15_2  score15_2int
local poly score15_1 score15_1int    

eststo model_char_a`y': quietly reg `x' agg_dui `poly' if abs(score15_1)<=`b', cluster(score15_1)
local y=`y'+1
}

esttab model_char1 model_char2 model_char3 model_char4 model_char5 model_char6, keep(dui score8_1 score8_1int)


esttab model_char_a1 model_char_a2 model_char_a3 model_char_a4 model_char_a5 model_char6, keep(agg_dui score15_1 score15_1int)
