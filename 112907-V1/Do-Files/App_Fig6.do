*****regression tables



clear
clear matrix

set mem 4g

set more off


cd "C:\Users\Benjamin\Dropbox\Alcohol WA\

use dui_analysis, clear

gen one=1
bysort Operator: egen total_stops=total(one)

gen black=0
replace black=1 if Eth=="B"
gen hisp=0
replace hisp=1 if Eth=="H"
gen indian=0
replace indian=1 if Eth=="I"
*keep if crime=="01"


keep if year>1998 & year<2008
*drop if year==2007 & month(Date)>9

tab year, gen(y_)


gen acc=0
replace acc=1 if Accident=="Y"

*replace low_score=low_score/1000
replace recid_bac=recid_bac/1000

gen score8_1=low_score-80
gen score8_2=score8_1^2
gen score8_3=score8_1^3
gen score8_4=score8_1^4

gen dui=0
replace dui=1 if score8_1>=0

gen score8_1int=score8_1*dui
gen score8_2int=score8_2*dui
gen score8_3int=score8_3*dui
gen score8_4int=score8_4*dui

gen score15_1=low_score-150
gen score15_2=score15_1^2
gen score15_3=score15_1^3
gen score15_4=score15_1^4

gen agg_dui=0
replace agg_dui=1 if score15_1>0

gen score15_1int=score15_1*agg_dui
gen score15_2int=score15_2*agg_dui
gen score15_3int=score15_3*agg_dui
gen score15_4int=score15_4*agg_dui

destring County, replace 
replace County=99 if County==0
replace County=99 if County>39


gen age=(mdy(month(Date), day(Date), year(Date))-mdy(month(dob), day(dob),year(dob)+21))/365+21

drop if age<21

sum age, d

*keep if age<76 & age>35

sum age, d

*keep if age>35

keep if age>=21

tab County, gen(c_)
tab Ethnic, gen(e_)
replace age=trunc(age)
tab age, gen(a_)

*keep if white==1


forvalues x=0/5{
local b=`x'

**** score8_1 score8_1int        
local poly_dc score8_1 score8_1int  c_* white black hisp male y_* acc a_*

quietly reg recidivism dui `poly_dc' if abs(score8_1)<50 & abs(score8_1)>`b', cluster(score8_1)
gen bdui_`x'=_b[dui]
gen sd_`x'=_se[dui]



gen up_`x'=bdui_`x'+2*sd_`x'
gen low_`x'=bdui_`x'-2*sd_`x'





**** score15_1 score15_1int score15_2 score15_2int score15_3 score15_3int score15_4 score15_4int        

local poly_a score15_1 score15_1int  
local poly_ac score15_1 score15_1int c_* white black hisp male y_*   acc  a_*

quietly reg recidivism agg_dui `poly_ac' if abs(score15_1)<50 & abs(score15_1)>`b', cluster(score15_1)
gen bduia_`x'=_b[agg_dui]
gen sda_`x'=_se[agg_dui]

gen upa_`x'=bduia_`x'+2*sda_`x'
gen lowa_`x'=bduia_`x'-2*sda_`x'




}

collapse (mean) bdui_* up_* low_* bduia_* upa_* lowa_*

gen id=1

reshape long bdui_ up_ low_ recid_ bduia_ upa_ lowa_, i(id) j(bandwidth)

tsset bandwidth
replace bandwidth=bandwidth/1000



twoway (tsline bdui_) (tsline up_, lpattern(dash)) (tsline low_, lpattern(dash) title("DUI: Discontinuity at .08") xtitle("Donut Width") yline(0) xlabel(0(.001).005) scheme(s2mono) legend(label(1 "Est. Effect") label(3 "95% Conf.") order(1 3))) 
graph save dui_donut.gph, replace

twoway (tsline bduia_) (tsline upa_, lpattern(dash)) (tsline lowa_, lpattern(dash) title("Agg. DUI: Discontinuity at .15") xtitle("Donut Width") yline(0) xlabel(0(.001).005) lcolor(black) scheme(s2mono) legend(label(1 "Est. Effect") label(3 "95% Conf.") order(1 3))) 
graph save aggdui_donut.gph, replace


graph combine dui_donut.gph aggdui_donut.gph, title("Donut Size and Estimated Effects") scheme(s2mono) ycommon

graph export donut_choice.eps, replace
graph export donut_choice.emf, replace
