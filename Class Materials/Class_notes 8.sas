/* Class Notes 8: SAS Macro Variables and proc sql */
/* Introduction to the SAS Macro Language */
/* Built-In Macro Variables */
/* macro variable is the same as global variable */
title "The date is &sysdate9 and the time is &systime";
proc print data=sashelp.class (obs=5);
run;

/* macro variable has to be within double quotes */
title 'The date is &sysdate9 and the time is &systime';
proc print data=sashelp.class (obs=5);
run;

/* User-Defined Macro Variables */
%let var_list = Age Height Weight;

title "Using a Macro Variable List";
proc print data=sashelp.class (obs=3);
 var &var_list;
run;

proc print data=sashelp.class (obs=3);run;

proc means data=sashelp.class;
 var &var_list;
run;

libname lect "~/my_shared_file_links/u5338439/";

data psych;
 set lect.cms_providers_la;
 if provider_type = "Psychiatry";
run;

proc means data=psych sum noprint;
 var total_submitted_chrg_amt;
 output out=tot sum=sumchrg;
run;

data _null_; *a dataset that is not write out, it is just a placeholder data step that allows you to do actions without storing;
 set tot;
 call symput('TotChrgs',sumchrg); *for creating macro variable, first argument is the newname;
run;

data pctPsych;
 set psych;
 pct_submitted_chrgs = total_submitted_chrg_amt/&TotChrgs;
 format pct_submitted_chrgs percent10.3; 
run;

proc sort data=pctPsych;
 by descending pct_submitted_chrgs;
 run;
 
title "3 Psychiatrists with the Highest Percent Submitted Charges Amount";
proc print data=pctPsych (obs=3);
 var npi nppes_provider_last_org_name nppes_provider_first_name pct_submitted_chrgs;
run;

/* Introduction to Macros */
/* it works like a function */
%MACRO select(sortvar,provtype);
 proc sort data=lect.cms_providers_la out=cms_sorted;
  by descending &sortvar;
  where provider_type = "&provtype";
 run;
 proc print data=cms_sorted (obs=5);
  title1 "Providers of Type &provtype";
  title2 "Providers with the 5 Highest Values of &sortvar";
  var npi nppes_provider_last_org_name nppes_provider_first_name provider_type &sortvar;
 run;
%MEND select;

%select(total_unique_benes, Internal Medicine);
%select(total_medicare_payment_amt, Anesthesiology);

/* exercise */
/* ------------------------------------------------------------- */
%macro provmeans(by_var);
proc means data=lect.cms_providers_la noprint;
	class provider_type;
	var &by_var;
	output out=ourmeans /*(drop=_:)*/ mean=mean_numvar;
run;
proc print data=ourmeans(where= (type ne 0));run;
%mend provmeans;
%provmeans(total_unique_benes);
/* row one is sum across all (_type_==0) */
/* --------------------------------------------------------------- */


/* Writing Macros with Conditional Logic */
%MACRO bbreport;
/* use % for conditional statements outside data step. Ex. %if */
%IF &SYSDAY = Tuesday %THEN %DO;
 title "today's Report";
 proc report data=sashelp.baseball;
  column name team nhits nruns;
 run;
%END;
%ELSE %IF &SYSDAY = Sunday %THEN %DO;
 title "Today's Report";
 proc report data=sashelp.baseball;
  column team nhits nruns;
  define team/display group;
  define nhits/analysis sum "Team Total Hits";
  define nruns/analysis sum "Team Total Runs";
 run;
%END;
%MEND bbreport;

%bbreport;

/* Resolving Macro Variables */
%let prefix = abc;
data &prefix.123; *the data is called abc123;
 x = 3;
run;

%let libref = lect;
proc print data=&libref.cms_providers_la /*lectcms_providers_la*/(obs=10) noobs;
 title "First 10 Providers";
 var npi nppes_provider_last_org_name nppes_provider_first_name provider_type;
run;

%let libref = lect;
proc print data=&libref..cms_providers_la (obs=10) noobs;
 title "First 10 Providers";
 var npi nppes_provider_last_org_name nppes_provider_first_name provider_type;
run;

/* Introduction to proc sql */
/* read at own pace */

