 libname lect "~/my_shared_file_links/u5338439/";
/* proc sort data=lect.best_countries; */
/* 	by incgroup popgroup; */
/* run; */
proc means data=lect.best_countries mean median;
	var oa;
	class incgroup popgroup;
run;

title "Proc Means with an Output Statement";
proc means data=lect.best_countries n mean median noprint;
 var Relig PE;
 output out    = Relig_and_PE
        mean   = Relig_avg PE_avg
        median = Relig_med PE_med;
run;
        
title "Mean and Median Relig and PE";
proc print data=Relig_and_PE;
run;


title "Two-way Table using Proc Freq";
proc freq data=lect.best_countries;
 tables incGroup*popGroup;
run;