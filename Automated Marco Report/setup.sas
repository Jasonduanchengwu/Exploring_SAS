/* establish dataset save location */
libname fp "~/my_non_shared_file_links/Data/Final_project";

data t;
	set fp;
	if ppage ne . & Q9 ne .;
	Q100_1=abs(ppage-Q9)<=5;
	keep ppage q9 q100_1;
run;

data t;
	set t;
/* 	if ppage = .; */
	if q9 = .;
run;

data subn;
	infile "~/my_non_shared_file_links/Data/Final_project/Final Project SubsetNumber Assignment.csv" dsd firstobs=2;
	input uid$:11. 
			subnum;
	if uid = "606-332-825";
run;
/* subnum is 9 */

data casel;
	infile "~/my_non_shared_file_links/Data/Final_project/CaseSubset.csv" dsd firstobs=2;
	input caseid subnum;
run;

proc sort data=casel; by subnum; run;

data mcl;
	merge subn (in=insubn) casel;
	by subnum;
	if insubn;
	drop uid subnum;
	rename caseid = caseid_new;
run;

data tmain; set fp.hcmst; run;
proc sort data=mcl; by caseid_new; run;
proc sort data=tmain; by caseid_new; run;


data fp.mfp;
	merge mcl(in = inmc) tmain;
	by caseid_new;
	if inmc;
run;
	
proc contents data=fp.mfp; run;


