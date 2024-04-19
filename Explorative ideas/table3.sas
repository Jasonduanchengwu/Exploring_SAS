
/* Table 3. Financial stress in 2007 and 2011 for the subsample
 with assessments completed at both time points */

/* in 2007.E117: How much stress have you felt 
in meeting financial obligations? */
/* in 2007.E217: How difficult is it for you to pay your bills on time? */

libname mqp "~/my_non_shared_file_links/Data";

/* only include completed and var we concerned with */
data fs07;
	set mqp.my07;
	keep famid E117 E217;
	label E117 = "07 stress" E217 = "07 bill";
run;

proc print data=fs07 noobs;
run;

/* in 2011.E2STRE19: How much stress have you felt 
in meeting your financial obligations during this past year? */
/* in 2011.E3BILL19: How difficult is it for you to pay your bills on time? */
data fs11;
	set mqp.my11;
	keep famid E2STRE19 E3BILL19;
	label E2STRE19 = "11 stress" E3BILL19 = "11 bill";
run;

proc print data=fs11 noobs;
run;

proc sort data=fs07; by famid; run;
proc sort data=fs11; by famid; run;

data fs07and11;
	merge fs07(in=in07) fs11(in=in11);
	by famid;
	if in07 and in11;
/* 	if E3BILL19=.; */
run;
proc print data=fs07and11 noobs; run;
/* E117 E217 E2STRE19 E3BILL19 */
proc tabulate data=fs07and11;
	var E3BILL19;
	table E3BILL19*(n mean std) ALL;
run;