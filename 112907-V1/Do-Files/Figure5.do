
clear
clear matrix

set mem 4g

set more off


*cd "Change to Directory Name where you have put administrative data"
cd "Insert Directory"

use "washington_administrative_testing.dta", clear

label variable low_score "BAC"


*keep if white==1

local b=50



**** score8_1 score8_1int        
local poly_d score8_1 score8_1int 
local poly_dc score8_1 score8_1int  c_* white black hisp male y_* acc a_*



eststo model_dui1: quietly reg recidiv dui `poly_d' if abs(score8_1)<=`b' & offense==1, cluster(score8_1)
gen b1df=_b[dui]
gen s1df=_se[dui]
gen u1df=b1df+2*s1df
gen l1df=b1df-2*s1df
eststo model_dui2: quietly reg recidiv dui `poly_d' if abs(score8_1)<=`b' & off_bac==1, cluster(score8_1)
gen b2df=_b[dui]
gen s2df=_se[dui]
gen u2df=b2df+2*s2df
gen l2df=b2df-2*s2df
eststo model_dui3: quietly reg recidiv dui `poly_d' if abs(score8_1)<=`b' & offense>=2, cluster(score8_1)
gen b1dr=_b[dui]
gen s1dr=_se[dui]
gen u1dr=b1dr+2*s1dr
gen l1dr=b1dr-2*s1dr
eststo model_dui4: quietly reg recidiv dui `poly_d' if abs(score8_1)<=`b' & off_bac>=2, cluster(score8_1)
gen b2dr=_b[dui]
gen s2dr=_se[dui]
gen u2dr=b2dr+2*s2dr
gen l2dr=b2dr-2*s2dr

eststo model_dui3: quietly reg recidiv dui `poly_d' if abs(score8_1)<=`b' & prior_conv==0, cluster(score8_1)
gen b3df=_b[dui]
gen s3df=_se[dui]
gen u3df=b3df+2*s3df
gen l3df=b3df-2*s3df
eststo model_dui4: quietly reg recidiv dui `poly_d' if abs(score8_1)<=`b' & prior_conv>=1, cluster(score8_1)
gen b3dr=_b[dui]
gen s3dr=_se[dui]
gen u3dr=b3dr+2*s3dr
gen l3dr=b3dr-2*s3dr








**** score15_1 score15_1int score15_2 score15_2int score15_3 score15_3int score15_4 score15_4int        

local poly_a score15_1 score15_1int  
local poly_ac score15_1 score15_1int c_* white black hisp male y_*   acc a_*

quietly reg recidiv agg_dui if abs(score15_1)<`b', cluster(id)
eststo model_agg1: quietly reg recidiv agg_dui `poly_a' if abs(score15_1)<=`b' & offense==1, cluster(score15_1)
gen b1af=_b[agg_dui]
gen s1af=_se[agg_dui]
gen u1af=b1af+2*s1af
gen l1af=b1af-2*s1af
eststo model_agg2: quietly reg recidiv agg_dui `poly_a' if abs(score15_1)<=`b' & off_bac==1, cluster(score15_1)
gen b2af=_b[agg_dui]
gen s2af=_se[agg_dui]
gen u2af=b2af+2*s2af
gen l2af=b2af-2*s2af
eststo model_agg3: quietly reg recidiv agg_dui `poly_a' if abs(score15_1)<=`b' & offense>=2, cluster(score15_1)
gen b1ar=_b[agg_dui]
gen s1ar=_se[agg_dui]
gen u1ar=b1ar+2*s1ar
gen l1ar=b1ar-2*s1ar
eststo model_agg4: quietly reg recidiv agg_dui `poly_a' if abs(score15_1)<=`b' & off_bac>=2, cluster(score15_1)
gen b2ar=_b[agg_dui]
gen s2ar=_se[agg_dui]
gen u2ar=b1ar+2*s2ar
gen l2ar=b1ar-2*s2ar

quietly reg recidiv agg_dui if abs(score15_1)<`b', cluster(id)
eststo model_agg1: quietly reg recidiv agg_dui `poly_a' if abs(score15_1)<=`b' & prior_conv==0, cluster(score15_1)
gen b3af=_b[agg_dui]
gen s3af=_se[agg_dui]
gen u3af=b3af+2*s3af
gen l3af=b3af-2*s3af
eststo model_agg2: quietly reg recidiv agg_dui `poly_a' if abs(score15_1)<=`b' & prior_conv>=1, cluster(score15_1)
gen b3ar=_b[agg_dui]
gen s3ar=_se[agg_dui]
gen u3ar=b3ar+2*s3ar
gen l3ar=b3ar-2*s3ar


esttab model_dui1  model_dui2  model_dui3  model_dui4 , keep(dui score8_1 score8_1int) r2

esttab  model_agg1  model_agg2  model_agg3  model_agg4 , keep(agg_dui score15_1 score15_1int) r2

collapse (mean) b3df s3df u3df l3df b3dr s3dr u3dr l3dr b3af s3af u3af l3af b3ar s3ar u3ar l3ar b1df s1df u1df l1df b2df s2df u2df l2df b1dr s1dr u1dr l1dr b2dr s2dr u2dr l2dr b1af s1af u1af l1af b2af s2af u2af l2af b1ar s1ar u1ar l1ar b2ar s2ar u2ar l2ar 

local y=1 
foreach x in 1df 2df 3df 1dr 2dr 3dr 1af 2af 3af 1ar 2ar 3ar {
rename b`x' b_`y' 
rename u`x' u_`y'
rename l`x' l_`y'
 local y=`y'+1
}
gen id=1 

reshape long b_ u_ l_, i(id) j(model)
eclplot b_ u_ l_ model if model>=1 & model<=6, scheme(s2mono) xlabel(1 "No Prior Tests" 2 "No Prior Tests>=.08" 3 "No Prior Conv." 4 "At Least 1 Prior Test" 5 "At Least 1 Prior Test>=.08" 6 "At Least 1 Prior Conv.", angle(45)) title("Effect of BAC>=.08 Threshold") xtitle("")
graph save prio_dui.gph, replace

eclplot b_ u_ l_ model if model>=7 & model<=12, xlabel(7 "No Prior Tests" 8 "No Prior Tests>=.08" 9 "No Prior Conv." 10 "At Least 1 Prior Test" 11 "At Least 1 Prior Test>=.08" 12 "At Least 1 Prior Conv.", angle(45)) title("Effect of BAC>=.15 Threshold") scheme(s2mono) xtitle("")
graph save prio_agg.gph, replace

graph combine prio_dui.gph prio_agg.gph, scheme(s2mono) title("Heterogeneous Effects by Prior Experience") ycommon
graph export "prior_exp.eps", replace
graph export "prior_exp.png", replace
graph export "prior_exp.emf", replace
graph export "prior_exp.wmf", replace
