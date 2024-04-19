/* Lab 4: */
/* SAS Macro and Report Examples */

%MACRO gen(n,Start,End);
 data generate;
  do Subj = 1 to &n;
   x = int((&End - &Start + 1)*ranuni(0) + &Start);
   output;
  end;
 run;
 proc print data=generate noobs;
  title "Randomly Generated Data Set with &n Observations";
  title2 "Values are Integers from &Start to &End";
 run;
%MEND;
%gen(4,1,100);

/* -------------------------------------------------------------------- */
/* Exercise 1 */
/* -------------------------------------------------------------------- */
%macro squtab;
data sqr_table;
 do n = 10 to 15;
  Sqr_n = n*n;
  output;
 end;
run;
title "Table of Squared Values for Integers from 10 to 15";
proc print data=sqr_table noobs;
 label n="N"
	Sqr_n = "Squared Result";
run;
%mend squtab;
%squtab;
/* -------------------------------------------------------------------- */
/* Classnote */
/* -------------------------------------------------------------------- */
libname L "~/my_shared_file_links/u5338439/";

title "Beneficiary Age and Risk by Provider Type";
proc tabulate data=L.cms_providers_la;
 class provider_type;
 var beneficiary_average_age beneficiary_average_risk_score;
 table provider_type='',
       (beneficiary_average_age beneficiary_average_risk_score)*
       (n='N' mean='Mean' std='Standard Deviation');
run;

title "Beneficiary Age and Risk by Provider Type";
proc tabulate data=L.cms_providers_la;
 where provider_type contains "Neur";
 class provider_type;
 var beneficiary_average_age beneficiary_average_risk_score;
 table provider_type='',
       (beneficiary_average_age beneficiary_average_risk_score)*
       (n='N' mean='Mean' std='Standard Deviation');
run;

%MACRO provtyp(string);
title "Beneficiary Age and Risk by Provider Type";
proc tabulate data=L.cms_providers_la;
 where provider_type contains &string;
 class provider_type;
 var beneficiary_average_age beneficiary_average_risk_score;
 table provider_type='',
       (beneficiary_average_age beneficiary_average_risk_score)*
       (n='N' mean='Mean' std='Standard Deviation');
run;
%MEND;

%provtyp("Neur");
%provtyp("Psych");

/* -------------------------------------------------------------------- */
/* Exercise 2 need fixing*/
/* -------------------------------------------------------------------- */
%macro proctab(str1, str2);
title "Beneficiary Age and Risk by Provider Type";
proc tabulate data=L.cms_providers_la;
	where ((provider_type = "&str1") or (provider_type = "&str2"));
	class provider_type;
	var beneficiary_average_age beneficiary_average_risk_score;
	table provider_type='',
       (beneficiary_average_age beneficiary_average_risk_score)*
       (n='N' mean='Mean' std='Standard Deviation');
run;
%mend proctab;
%proctab(Anesthesiology, Orthopedic Surgery);

/* -------------------------------------------------------------------- */
/* Classnote */
/* -------------------------------------------------------------------- */
/* The Output Delivery System */
/* ods html file = 'C:\Path\sampleoutput.html'; */
/*  SAS Program; */
/* ods html close; *ods is output delivery system; */
ods html file = '~/my_non_shared_file_links/sampleoutput.html';
title "Listing of Physicians";
proc print data=L.cms_providers_la (obs=5);
 id npi;
 var nppes_provider_last_org_name nppes_provider_first_name;
run;

title "Total Services by Provider Gender";
proc means data=L.cms_providers_la;
 class nppes_provider_gender;
 var total_services;
run;
ods html close;

/* rtf is word */
ods rtf file = '~/my_non_shared_file_links/sampleoutput.rtf';
title "Listing of Physicians";
proc print data=L.cms_providers_la (obs=5);
 id npi;
 var nppes_provider_last_org_name nppes_provider_first_name;
run;

title "Total Services by Provider Gender";
proc means data=L.cms_providers_la;
 class nppes_provider_gender;
 var total_services;
run;
ods rtf close;

/* -------------------------------------------------------------------- */
/* Exercise 3 need check*/
/* -------------------------------------------------------------------- */
/* if marco variables causes a problem try adding a dot first */
%macro ex3(numobs, varmeans);
/* need double quotes for macro var */
ods rtf file = "~/my_non_shared_file_links/exercise3_&varmeans..rtf" style=Journal;

title "Listing of &numobs Physicians";
proc print data=L.cms_providers_la (obs=&numobs);
 id npi;
 var nppes_provider_last_org_name nppes_provider_first_name;
run;

title "&varmeans by Provider Gender";
proc means data=L.cms_providers_la;
 class nppes_provider_gender;
 var &varmeans;
run;

ods rtf close;
%mend;

%ex3(10, beneficiary_average_risk_score);
proc contents data=L.cms_providers_la;
run;
/* -------------------------------------------------------------------- */
/* Classnote */
/* -------------------------------------------------------------------- */
%MACRO provtypo(string, name);

ods rtf file = "~/my_non_shared_file_links/&name_output.rtf" style = journal;

title "Beneficiary Age and Risk by Provider Type";
proc tabulate data=L.cms_providers_la;
 where provider_type contains &string;
 class provider_type;
 var beneficiary_average_age beneficiary_average_risk_score;
 table provider_type='',
       (beneficiary_average_age beneficiary_average_risk_score)*
       (n='N' mean='Mean' std='Standard Deviation');
run;
ods rtf close;

%MEND;
%provtypo("Neur",Neuro Providers);
/* -------------------------------------------------------------------- */
/* Exercise 4 need checking*/
/* -------------------------------------------------------------------- */
%macro ex4(numobs, varmeans, name);
/* need double quotes for macro var */
ods rtf file = "~/my_non_shared_file_links/Output_&name..rtf" style=Journal;

title "Listing of &numobs Physicians";
proc print data=L.cms_providers_la (obs=&numobs);
 id npi;
 var nppes_provider_last_org_name nppes_provider_first_name;
run;

title "&name by Provider Gender";
proc means data=L.cms_providers_la;
 class nppes_provider_gender;
 var &varmeans;
run;

ods rtf close;
%mend;

%ex4(8, beneficiary_average_age, Beneficiary Mean Age);

/* -------------------------------------------------------------------- */
/* Classnote */
/* -------------------------------------------------------------------- */
/* Generating Reports */
title "Provider Details: Los Angeles";
proc report data=L.cms_providers_la (obs = 5);
 column npi nppes_provider_last_org_name nppes_provider_first_name 
        nppes_credentials nppes_provider_gender provider_type;
run;

/* for numeric the default is to perform sum */
proc report data=L.cms_providers_la (obs = 5);
 column beneficiary_average_age beneficiary_average_risk_score;
run;

/* display shows the all obs/details, can be used for nominal too */
proc report data=L.cms_providers_la (obs = 5);
 column beneficiary_average_age beneficiary_average_risk_score;
 define beneficiary_average_age/display;
 define beneficiary_average_risk_score/display;
run;

/* analysis allow you to show specific stats */
proc report data=L.cms_providers_la;
 column provider_type beneficiary_average_age beneficiary_average_risk_score;
 define provider_type/display group "Provider Type"; *group groups by the same charc;
 define beneficiary_average_age/analysis mean format=6.2;
 define beneficiary_average_risk_score/analysis mean format=6.2;
run;

/* -------------------------------------------------------------------- */
/* Exercise 5 need check*/
/* -------------------------------------------------------------------- */
proc contents data=L.cms_providers_la;
run;
proc report data=L.cms_providers_la;
 column provider_type total_drug_unique_benes total_drug_submitted_chrg_amt;
 define provider_type/display group "Provider Type"; *group groups by the same charc;
 define total_drug_unique_benes/analysis sum format=8.;
 define total_drug_submitted_chrg_amt/analysis sum format=dollar20.2;
run;

/* -------------------------------------------------------------------- */
/* Classnote */
/* -------------------------------------------------------------------- */
proc report data=L.cms_providers_la;
 where provider_type contains "Neuro";
 column provider_type beneficiary_average_age beneficiary_average_risk_score;
 define provider_type/display group "Provider Type";
 define beneficiary_average_age/analysis mean format=6.2;
 define beneficiary_average_risk_score/analysis mean format=6.2;
 rbreak after/summarize;
run;
/* -------------------------------------------------------------------- */
/* Exercise 6 need check*/
/* -------------------------------------------------------------------- */
proc report data=L.cms_providers_la;
 column provider_type npi total_drug_unique_benes total_drug_submitted_chrg_amt;
 define provider_type/display group "Provider Type"; *group groups by the same charc;
 define npi/display group "NPI";
 define total_drug_unique_benes/analysis sum format=8.;
 define total_drug_submitted_chrg_amt/analysis sum format=dollar20.2;
 break after provider_type/summarize;
run;
