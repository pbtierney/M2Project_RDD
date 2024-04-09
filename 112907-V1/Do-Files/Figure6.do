clear
clear matrix

set mem 2g



*insheet using "C:\Users\T800\Downloads\hansen_dui_caseperson.txt", delimiter("|") clear

*save "C:\Users\T800\Desktop\Awesome Data\Alcohol WA\conviction.dta", replace

cd "C:\Users\Benjamin\Dropbox\Alcohol WA\"


use "DUI_Attorney.dta", clear

rename v2 id

gen attorney=0
replace attorney=1 if v3=="Y"

collapse (max) attorney, by(id)
sort id

save "DUI_Attorney_max.dta", replace 


use "conviction.dta", clear

rename v2 id

sort id 

merge id using "DUI_Attorney_max.dta" 

gen year=trunc(v7/10000)

keep if year>=1999 & year<=2007

gen bac=v5*1000
replace bac=trunc(bac)

gen dismissed=0
replace dismissed=1 if v11=="Dismissed"
replace dismissed=1 if  v11=="Dismissed W/Prejudice"
replace dismissed=1 if v11=="Dismissed W/O Prejudice"
replace dismissed=1 if v11=="Not Guilty"


gen guilty=0
replace guilty=1 if v11=="Guilty"
replace guilty=1 if v11=="Amended"
replace guilty=1 if v11=="Guilty Defrd Pros Revoked"
replace guilty=1 if v11=="Deferred Prosecution"
replace guilty=1 if v11=="Guilty Oth Defrl Revoked"
replace guilty=1 if v11=="Other Deferral"

*drop if bac>100

sum dismissed guilty

gen obs=1

duplicates drop id, force

rename v16 name
split name, p(",")
replace name2=trim(name2)
replace name2=itrim(name2)
split name2, p(" ") 

gen lastname=name1
gen firstinit=substr(name21, 1,1)
gen midinit=substr(name22, 1,1)

gen yob=trunc(v17/10000)
gen mob=trunc(v17/100)-yob*100
gen daob=v17-mob*100-yob*10000

gen dob=mdy(mob,daob,yob)

gen d21=mdy(mob,daob,yob+21)






collapse (sum) obs (mean) dismissed guilty attorney, by(bac)

scatter dismissed bac if bac<200
scatter guilty bac if bac<200
scatter obs bac if bac<200
scatter obs bac if bac<200 , xline(80)
