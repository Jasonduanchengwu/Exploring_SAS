/* 606-332-825,9 */

/* establish dataset save location */
libname mqp "~/my_non_shared_file_links/Data";

/* find and save my subset of famid*/
data mqp.myfamid;
	set mqp.famidsubset;
	if subsetnumber=9;
run;

/* sort before merging */
proc sort data=mqp.myfamid; by famid; run;
proc sort data=mqp.w2007; by famid; run;
proc sort data=mqp.w2011; by famid; run;

/* creating MyW2007 dataset */
data mqp.my07;
	merge mqp.myfamid (in=infamid)
		mqp.w2007 (in=in07);
	by famid;
	if infamid and in07;
run;
proc contents data=mqp.my07; run;

/* creating MyW2011 dataset */
data mqp.my11;
	merge mqp.myfamid (in=infamid)
		mqp.w2011 (in=in11);
	by famid;
	if infamid and in11;
run;
proc contents data=mqp.my11; run;