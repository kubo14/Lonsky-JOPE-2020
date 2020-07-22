*********************************************************************************************************************
* 		Paper: Does immigration decrease far-right popularity? Evidence from Finnish municipalities	  	  			*
* 		Author: Jakub Lonsky 											  	      	 		  		 	  			*
*		Journal: Journal of Population Economics (2020)																*
* 		Data Source: Statistics Finland's StatFin Database (https://www.stat.fi/tup/statfin/index_en.html)	   	    *  		  		  
*********************************************************************************************************************
clear
global path "/Users/Lonskyj/Desktop/JPOP Pub. 2020/GitHub - Replication fles"
cd "$path"

************
* Figure 1 *
************
clear
use "Figure_Data_FINAL.dta"
graph twoway connected National Year if Year >= 1993 & Year <= 2015, ytitle("Share of valid votes") ///
graphregion(color(white)) mcolor(black) lcolor(black) xline(2004, lcolor(black) ///
lpattern(dash)) text(0.195 2004 "2004 EU enlargement", place(w) box) ylabel(0(.035).21, angle(0) format(%9.0gc))
graph export "Fig1.pdf", replace

************
* Figure 2 *
************
clear
use "Figure_Data_FINAL.dta"
graph twoway connected Immig_inflow Year if Year>=1990, ytitle("Inflow of immigrants (% of total population)") ///
graphregion(color(white)) mcolor(black) lcolor(black) xline(2004, lcolor(black) ///
lpattern(dash)) text(0.0043 2004 "2004 EU enlargement", place(w) box) ylabel(0.001(.0007).0046, angle(0) format(%9.0gc))
graph export "Fig2.pdf", replace

************
* Figure 3 *
************
clear
use "Figure_Data_FINAL.dta"
graph twoway connected Immig_stock Year, ytitle("Share of foreign citizens (% of total population)") ///
graphregion(color(white)) mcolor(black) lcolor(black) xline(2004, lcolor(black) lpattern(dash)) text(0.039 2004 "2004 EU enlargement", place(w) box) ///
ylabel(0(.007).042, angle(0) format(%9.0gc))
graph export "Fig3.pdf", replace

************
* Figure 4 *
************
clear
use "Figure_Data_FINAL.dta"
line Europe_infl Year, lcolor(black) lpattern(dash_dot) || ///
line Asia_infl Year, lcolor(black) lpattern(shortdash) || line Africa_infl Year, lcolor(black) lpattern(line) ///
xtitle("Year") ytitle("Total annual immigrant inflow") legend(label(1 "Europe") label(2 "Asia") label(3 "Africa")) ///
graphregion(color(white)) mcolor(black) lcolor(black) xline(2004, lcolor(black) lpattern(dash)) text(14000 2004 "2004 EU enlargement", place(w) box) ///
ylabel(0(3000)15000, angle(0) format(%9.0gc))
graph export "Fig4.pdf", replace 

************
* Figure 5 *
************
clear
use "Figure_Data_FINAL.dta"
line Total_eu8brc_infl Year, lcolor(black) lpattern(line) || ///
line Eu15_infl Year, lcolor(black) lpattern(shortdash) || line Rest_of_europe_infl Year, lcolor(black) lpattern(dash_dot) ///
xtitle("Year") ytitle("Total annual immigrant inflow") legend(label(1 "EU8 + Bulgaria, Romania, Croatia") label(2 "EU15") label(3 "Rest of Europe")) ///
graphregion(color(white)) mcolor(black) lcolor(black) xline(2004, lcolor(black) lpattern(dash)) text(7500 2004 "2004 EU enlargement", place(w) box) ///
ylabel(0(2000)8000, angle(0) format(%9.0gc))
graph export "Fig5.pdf", replace 

************
* Figure 6 *
************
clear
use Figure_6_Data_FINAL.dta
histogram EU_vote_share, bin(80) fraction graphregion(color(white)) ytitle("Fraction") xtitle("Non-Finnish E.U. citizens' share of total votes (by municipality)") ///
graphregion(color(white)) ylabel(0(.07).35, angle(0) format(%9.0gc)) xlabel(0(.001).009) ///
fcolor(blue) lcolor(black)
graph export "Fig6.pdf", replace 

************
* Figure 7 *
************
clear
use "Figure_Data_FINAL.dta"
twoway connected Natur_rate_foreign_pop Year, lcolor(black) lpattern(line) ///
xtitle("Year") ytitle("# citizenships granted (% of immigrant population)") ///
graphregion(color(white)) mcolor(black) lcolor(black) xline(2004, lcolor(black) lpattern(dash)) text(0.095 2004 "2004 EU enlargement", place(w) box) ///
ylabel(0(0.01)0.1, angle(0) format(%9.0gc))
graph export "Fig7.pdf", replace 
