
clear
clear matrix

set mem 4g

set more off


*cd "Change to Directory Name where you have put administrative data"
cd "Insert Directory"

use "washington_administrative_testing.dta", clear

label variable low_score "BAC"

 
local poly score8_1 score8_1int male white black hisp c_* a_* y_*


local b=50

**** score8_1 score8_1int        
local poly_d score8_1 score8_1int 
local poly_dc score8_1 score8_1int  c_* white black hisp male y_* acc a_*

eststo model_dui1: quietly reg assault dui `poly_dc' if abs(score8_1)<=`b', cluster(score8_1)
eststo model_dui2: quietly reg dv dui `poly_dc' if abs(score8_1)<=`b', cluster(score8_1)
eststo model_dui3: quietly reg other_crime dui `poly_d' if abs(score8_1)<=`b', cluster(score8_1)
eststo model_dui4: quietly reg all_other_crimes dui `poly_dc' if abs(score8_1)<=`b', cluster(score8_1)







**** score15_1 score15_1int score15_2 score15_2int score15_3 score15_3int score15_4 score15_4int        

local poly_a score15_1 score15_1int  
local poly_ac score15_1 score15_1int c_* white black hisp male y_*   acc  a_*

quietly reg recidiv agg_dui if abs(score15_1)<`b', cluster(id)
eststo model_agg1: quietly reg assault agg_dui `poly_ac' if abs(score15_1)<=`b', cluster(score15_1)
eststo model_agg2: quietly reg dv agg_dui `poly_ac' if abs(score15_1)<=`b', cluster(score15_1)
eststo model_agg3: quietly reg other_crime agg_dui `poly_ac' if abs(score15_1)<=`b', cluster(score15_1)
eststo model_agg4: quietly reg all_other_crimes agg_dui `poly_ac' if abs(score15_1)<=`b', cluster(score15_1)




esttab model_dui1  model_dui2  model_dui3  model_dui4 , keep(dui score8_1 score8_1int) r2

esttab  model_agg1  model_agg2  model_agg3  model_agg4 , keep(agg_dui score15_1 score15_1int) r2

sum assault dv other_crime all_other_crime if low_score<080 & low_score>30

sum assault dv other_crime all_other_crime if low_score>100 & low_score<150


