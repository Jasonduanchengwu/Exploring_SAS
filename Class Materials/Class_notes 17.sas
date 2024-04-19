libname LCT "~/my_non_shared_file_links/Data";
proc freq data=LCT.tech_mh;
 tables treatment*family_history/norow nopercent missing;
run;
/* in the project we dont want to include the missings */
proc freq data=LCT.TECH_MH;
 tables family_history*treatment/norow nopercent missing chisq;
run;

/* exercise */
/* proc freq data=LCT.TECH_MH(where=(benefits ne "Don't know" & benefits ne "Yes")); */
proc freq data=LCT.TECH_MH(where=(benefits ne "Don't know"));
 tables tech_company*benefits/norow nopercent chisq;
run;

/* assuming alpha=0.05 */
proc format;
 value $empfmt '1-5' = '(1) 1-25'
               '6-25' = '(1) 1-25'
               '26-100' = '(2) 26-100'
               '100-500' = '(3) 100-500'
               '500-1000' = '(4) 500+'
               'More than 1000' = '(4) 500+';
run;
proc freq data=LCT.TECH_MH;
 tables obs_consequence*no_employees /norow nopercent missing chisq;
run; 

/* order=formatted follows the format, otherwise it follows the internal order */
proc freq data=LCT.TECH_MH order=formatted;
 format no_employees $empfmt.;
 tables obs_consequence*no_employees/norow nopercent missing chisq;
run;
/* ordering matters for Mantel-Haenszel Chi-Square, is assumed to have ascending ordering*/

/* Computing Chi-Square from Frequency Counts */
data chisq;
 input group $ outcome $ count;
datalines;
drug alive 90
drug dead 10
placebo alive 80
placebo dead 20
;
run;

proc freq data=chisq;
 tables group*outcome/nocol nopercent chisq;
 weight count; *this weight represents the values in each cat;
run;

/* SAS looping is fine */
%MACRO CHISQ(A,B,C,D,OPTIONS=CHISQ);
 data chisq;
  array cells[2,2] _temporary_ (&A &B &C &D); *cells are not displayed and stored;
  do row = 1 to 2;
   do col = 1 to 2;
    count = cells[row,col];
    output;
   end;
  end;
 run;
 proc freq data=chisq;
  tables row*col/ &options;
  weight count;
 run;
%MEND CHISQ; 

%CHISQ(90,10,80,20);

data couples_cm;
 set LCT.couples;
 if DEP_PRE_CNVRTD ne . & DEP_EXIT_CNVRTD ne .;
 if DEP_PRE_CNVRTD >= 0.95 then DEP_PRE_CM = 'Y'; 
 else DEP_PRE_CM = 'N';
 if DEP_EXIT_CNVRTD >= 0.95 then DEP_EXIT_CM = 'Y'; 
 else DEP_EXIT_CM = 'N'; 
 keep PID DEP_PRE_CM DEP_EXIT_CM;
run;

/* agree is option for McNemar's test, paired*/
proc freq data=couples_cm;
 tables DEP_PRE_CM*DEP_EXIT_CM/agree;
run;

/* Kappa Statistics */
/* agreement between two analysis of the same observations, still paired*/
%CHISQ(25,3,5,50,OPTIONS=AGREE);

/* >0.9 estimate kappa is good standard now */

/* Odds Ratios */
data odds;
 input outcome $ exposure $ count;
datalines;
case 1-Yes 50
case 2-No 100
control 1-Yes 20
control 2-No 130
;
run;
proc freq data=odds;
 tables exposure*outcome/chisq measures;
 weight count;
run;

/* p-value of chisq val should match that if confi-inter contains 1 */
/* how to change CI into anything besides 95%? */

/* exercise */
proc freq data=LCT.TECH_MH;
 tables family_history*treatment/norow nopercent nocol measures;
run;

/* SAS assumes that the first col and row are yes, no matter the label */
/* use formats to arrange yes to the first col and row */
proc format;
 value $ynfmt "No" = "2-No"
              "Yes" = "1-Yes";
run; 
proc freq data=LCT.TECH_MH order=formatted;
 tables family_history*treatment/norow nopercent nocol measures;
 format family_history treatment $ynfmt.;
run;

/* Creating a Table Containing Association Results */
proc sort data=LCT.TECH_MH;
 by no_employees;
run;

proc freq data=LCT.TECH_MH (where=(benefits ne "Don't know")) order=formatted;
 format benefits obs_consequence $ynfmt.;
 by no_employees;
 tables benefits*obs_consequence/nocol nopercent measures;
run; 

/* documents the internal var saved with traces in logs */
ods output CrossTabFreqs=CTF RelativeRisks=RR;
ods trace on;
proc freq data=LCT.TECH_MH (where=(benefits ne "Don't know")) order=formatted;
 format benefits obs_consequence $ynfmt.;
 by no_employees;
 tables benefits*obs_consequence/nocol nopercent measures;
run; 
ods trace off;

data ORs;
 set RR;
 where statistic = "Odds Ratio";
 keep no_employees statistic value LowerCL UpperCL;
run;
proc print data=ORs noobs;
run;

