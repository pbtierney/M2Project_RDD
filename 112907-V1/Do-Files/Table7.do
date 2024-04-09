
clear
clear matrix

set mem 4g

set more off


*cd "Change to Directory Name where you have put administrative data"
cd "Insert Directory"

use "washington_administrative_testing_linkd_courts.dta", clear

label variable low_score "BAC"


gen any_fine=0 if fine_paid==0
replace any_fine=1 if fine_paid>0 & fine_paid!=. 

gen any_jail=0 if jail==0
replace any_jail=1 if jail>0 & jail!=. 

gen any_treat=0
replace any_treat=1 if alcohol_assess==1 | alcohol_treatment==1 | aa==1



gen acc=0
replace acc=1 if Accident=="Y"

foreach x in amended aa charges dismissed not_guilty  alcohol_assess alcohol_treatment alcohol_school probation victims_panel monitor {
replace `x'=1 if `x'>1 & `x'!=. 
}

local controls c_* black hisp male y_* acc a_*

local y=1
foreach x in fine_paid jail any_fine any_jail  monitor susp susp_length probation prob_length victims_panel alcohol_assess alcohol_treatment aa any_treat{

eststo dui_`y': quietly reg `x' dui rd rd_int  `controls' if abs(rd)<=.050, cluster(rd)
local y=`y'+1
}

local y=1
foreach x in  fine_paid jail any_fine any_jail  monitor susp susp_length probation prob_length victims_panel alcohol_assess alcohol_treatment aa any_treat  {
eststo agg_`y': quietly reg `x' agg ra ra_int `controls' if abs(ra)<=.050, cluster(ra)
local y=`y'+1
}



esttab dui_1 dui_2 dui_3 dui_4 dui_5, keep(dui) se
tabstat fine_paid jail monitor any_fine any_jail if bac>.075 & bac<.079, statistics(mean median)

esttab dui_6 dui_7 dui_8 dui_9, keep(dui) se 
tabstat susp susp_length    probation  prob_length if bac>.075 & bac<.079, statistics(mean median)

esttab dui_10 dui_11 dui_12 dui_13 dui_14, keep(dui) se
tabstat  victims_panel alcohol_assess alcohol_treatment aa any_treat if bac>.075 & bac<.079, statistics(mean median)

esttab agg_1 agg_2 agg_3 agg_4 agg_5, keep(agg) se
tabstat fine_paid jail probation monitor any_fine any_jail if bac>.145 & bac<.150, statistics(mean median)

esttab agg_6 agg_7 agg_8 agg_9, keep(agg) se
tabstat probation  prob_length   susp susp_length   if bac>.145 & bac<.150, statistics(mean median)
esttab  agg_10 agg_11  agg_12 agg_13 agg_14, keep(agg) se
tabstat  victims_panel alcohol_assess alcohol_treatment aa any_treat if bac>.145 & bac<.150, statistics(mean median)



tabstat fine_paid jail monitor any_fine any_jail if bac>.075 & bac<.079, statistics(mean median)
tabstat fine_paid jail probation monitor any_fine any_jail if bac>.145 & bac<.150, statistics(mean median)
tabstat probation  prob_length   susp susp_length   if bac>.145 & bac<.150, statistics(mean median)
tabstat susp susp_length    probation  prob_length if bac>.075 & bac<.079, statistics(mean median)
tabstat  victims_panel alcohol_assess alcohol_treatment aa any_treat if bac>.075 & bac<.079, statistics(mean median)

tabstat fine_paid jail probation monitor any_fine any_jail if bac>.145 & bac<.150, statistics(mean median)
tabstat probation  prob_length   susp susp_length   if bac>.145 & bac<.150, statistics(mean median)
tabstat  victims_panel alcohol_assess alcohol_treatment aa any_treat if bac>.145 & bac<.150, statistics(mean median)

