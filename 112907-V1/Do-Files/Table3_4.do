
clear
clear matrix

set mem 4g

set more off


*cd "Change to Directory Name where you have put administrative data"
cd "Insert Directory"

use "washington_administrative_testing.dta", clear

label variable low_score "BAC"

local b=50


keep if year
**** score8_1 score8_1int        
local poly_d score8_1 score8_1int 
local poly_dc score8_1 score8_1int  c_* white black hisp male y_* acc a_*

eststo model_dui1: quietly reg recidiv dui `poly_d' if abs(score8_1)<=`b', cluster(score8_1)
eststo model_dui2: quietly reg recidiv dui `poly_dc' if abs(score8_1)<=`b', cluster(score8_1)
sum recidiv if low_score==079
eststo model_dui3: quietly reg recidiv dui `poly_d' if abs(score8_1)<=`b' & offense==3, cluster(score8_1)
eststo model_dui4: quietly reg recidiv dui `poly_dc' if abs(score8_1)<=`b' & offense==3, cluster(score8_1)
sum recidiv if low_score==079 & offense==1
eststo model_dui5: quietly reg recidiv dui `poly_d' if abs(score8_1)<=`b' & offense>=4, cluster(score8_1)
eststo model_dui6: quietly reg recidiv dui `poly_dc' if abs(score8_1)<=`b' & offense>=4, cluster(score8_1)
sum recidiv if low_score==079 & offense>=2




esttab model_dui3 model_dui4 model_dui5 model_dui6



**** score15_1 score15_1int score15_2 score15_2int score15_3 score15_3int score15_4 score15_4int        

local poly_a score15_1 score15_1int  
local poly_ac score15_1 score15_1int c_* white black hisp male y_*   acc a_*

quietly reg recidiv agg_dui if abs(score15_1)<`b', cluster(id)
eststo model_agg1: quietly reg recidiv agg_dui `poly_a' if abs(score15_1)<=`b', cluster(score15_1)
eststo model_agg2: quietly reg recidiv agg_dui `poly_ac' if abs(score15_1)<=`b', cluster(score15_1)
sum recidiv if low_score==149
eststo model_agg3: quietly reg recidiv agg_dui `poly_a' if abs(score15_1)<=`b' & offense==3, cluster(score15_1)
eststo model_agg4: quietly reg recidiv agg_dui `poly_ac' if abs(score15_1)<=`b' & offense==3, cluster(score15_1)
sum recidiv if low_score==149 & offense==1
eststo model_agg5: quietly reg recidiv agg_dui `poly_a' if abs(score15_1)<=`b' & offense>=4, cluster(score15_1)
eststo model_agg6: quietly reg recidiv agg_dui `poly_ac' if abs(score15_1)<=`b' & offense>=4, cluster(score15_1)
sum recidiv if low_score==149 & offense>=2


esttab model_dui1  model_dui2  model_dui3  model_dui4 model_dui5 model_dui6, keep(dui score8_1 score8_1int) r2

esttab  model_agg1  model_agg2  model_agg3  model_agg4 model_agg5 model_agg6, keep(agg_dui score15_1 score15_1int) r2





gen recid_nodui=0 
replace recid_nodui=1 if recid_bac>=0 & recid_bac<.08
gen recid_dui=0 
replace recid_dui=1 if recid_bac>=0.08 & recid_bac<=.15
gen recid_agg=0 
replace recid_agg=1 if recid_bac>.15 & recid_bac!=.

gen refusal=0
replace refusal=1 if refusal1!=""
replace refusal=1 if refusal2!=""

*keep if offense==1

local y=1
foreach x in recid_dui recid_agg recid_nodui refusal acc_recid{
sum `x' if low_score==079
sum `x' if low_score==149

sum `x' if low_score==079 & offense==1
sum `x' if low_score==149 & offense==1

sum `x' if low_score==079 & offense==2
sum `x' if low_score==149 & offense==2
eststo model_dsev`y': quietly reg `x' dui `poly_d' if abs(score8_1)<`b', cluster(score8_1)
eststo model_sev`y': quietly reg `x' agg_dui `poly_a' if abs(score15_1)<`b', cluster(score15_1)
local y=`y'+1
}


sum recid_dui recid_agg recid_nodui refusal acc_recid if low_score<.125
esttab model_dsev1 model_dsev2 model_dsev3 model_dsev4 model_dsev5, keep(dui `poly_d') r2


sum recid_dui recid_agg recid_nodui refusal acc_recid if low_score>.125

esttab model_sev1 model_sev2 model_sev3 model_sev4 model_sev5, keep(agg_dui `poly_a') r2


foreach x in recid_dui recid_agg recid_nodui refusal acc_recid{
di "All suspected offenders"
sum `x' if low_score==079
}
di "No Prior Tests"
foreach x in recid_dui recid_agg recid_nodui refusal acc_recid{

di "No Prior Tests"
sum `x' if low_score==079 & offense==1
}


di "At Least One Prior Test"
foreach x in recid_dui recid_agg recid_nodui refusal acc_recid{
sum `x' if low_score==079 & offense==2
}

di "All Suspects"
foreach x in recid_dui recid_agg recid_nodui refusal acc_recid{


sum `x' if low_score==149 
}


di "No Prior Tests"

foreach x in recid_dui recid_agg recid_nodui refusal acc_recid{
sum `x' if low_score==149 & offense==1
}

di "At Least One Prior Test"
foreach x in recid_dui recid_agg recid_nodui refusal acc_recid{
sum `x' if low_score==149 & offense==2

}

