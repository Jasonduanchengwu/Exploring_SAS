/* exercise 1-6 */
/* SAS coding exercises */

libname npi "~/my_shared_file_links/u5338439/";

proc contents data=npi.cms_providers_la;
run;

proc sgplot data=npi.cms_providers_la;
  reg x=total_unique_benes y=total_submitted_chrg_amt / nomarkers;
  reg x=total_unique_benes y=total_medicare_allowed_amt / nomarkers;
  reg x=total_unique_benes y=total_medicare_payment_amt / nomarkers;
run;

proc sgplot data=npi.cms_providers_la;
   title1 "Association of Total Charges/Payments and Number of Beneficiaries"; 
   title2 "Best-Fit Line";
	reg x=total_unique_benes y=total_submitted_chrg_amt / legendlabel="Medicare Submitted Charges" nomarkers;
	reg x=total_unique_benes y=total_medicare_allowed_amt / legendlabel="Medicare Allowed Charges" nomarkers;
	reg x=total_unique_benes y=total_medicare_payment_amt / legendlabel="Medicare Payments" nomarkers;
   format total_submitted_chrg_amt
          total_medicare_allowed_amt
          total_medicare_payment_amt dollar15.;
   xaxis label="Number of Medicare Beneficiaries";
   yaxis label="Total Amount";
run;

/* wide format is per id all patient visits */
/* long format is list of visits from that patient in multiple rows */

data cms_submitted;
 set npi.cms_providers_la;
 keep npi total_unique_benes total_submitted_chrg_amt;
run;

data cms_allowed;
 set npi.cms_providers_la;
 keep npi total_unique_benes total_medicare_allowed_amt;
run;

data cms_payment;
 set npi.cms_providers_la;
 keep npi total_unique_benes total_medicare_payment_amt;
run;

data cms_append;
 set cms_submitted (in=in_sub rename=(total_submitted_chrg_amt = amount))
     cms_allowed (in=in_allow rename=(total_medicare_allowed_amt = amount))
     cms_payment (in=in_pay rename=(total_medicare_payment_amt = amount));
 if in_sub then amount_type = "Medicare Submiitted Charges";
 else if in_allow then amount_type = "Medicare Allowed Charges"; 
 else if in_pay then amount_type = "Medicare Payments";
run;

proc sort data=cms_append;
	by npi;
run;

proc print data=cms_append (obs=20) noobs;
run;

proc sgplot data=cms_append;
   title1 "Association of Total Charges/Payments and Number of Beneficiaries"; 
   title2 "Best-Fit Line";
   label amount_type = "Amount Type";
   reg y=amount x=total_unique_benes / group=amount_type nomarkers; 
   xaxis label="Number of Medicare Beneficiaries";
   yaxis label="Total Amount";
   format amount dollar15.;
run;

/* to check labels */
proc contents data=npi.cms_providers_la (obs=10);
run;

/* ------------------------------------------------- */
/* Exercise 1 */
/* ---------------------------------------------------- */

data cms_submitted;
 set npi.cms_providers_la;
 keep npi total_drug_unique_benes total_drug_submitted_chrg_amt;
run;

data cms_allowed;
 set npi.cms_providers_la;
 keep npi total_drug_unique_benes total_drug_medicare_allowed_amt;
run;

data cms_payment;
 set npi.cms_providers_la;
 keep npi total_drug_unique_benes total_drug_medicare_payment_amt;
run;

data cms_append;
 set cms_submitted (in=in_sub rename=(total_drug_submitted_chrg_amt = amount))
     cms_allowed (in=in_allow rename=(total_drug_medicare_allowed_amt = amount))
     cms_payment (in=in_pay rename=(total_drug_medicare_payment_amt = amount));
 if in_sub then amount_type = "Medicare Drug Submiitted Charges";
 else if in_allow then amount_type = "Medicare Drug Allowed Charges"; 
 else if in_pay then amount_type = "Medicare Drug Payments";
run;

proc sort data=cms_append;
	by npi;
run;

proc sgplot data=cms_append;
   title1 "Association of Total Drug Charges/Drug Payments and Number of Beneficiaries With Drug Services"; 
   title2 "Best-Fit Line";
   label amount_type = "Amount Type";
   reg y=amount x=total_drug_unique_benes / group=amount_type nomarkers; 
   xaxis label="Number of Medicare Beneficiaries With Drug Services";
   yaxis label="Total Amount";
   format amount dollar15.;
run;
	
/* ------------------------------------------------- */
/* Lab material */
/* ---------------------------------------------------- */
proc transpose 
 data=npi.cms_providers_la
 out=cms_long (rename=(Col1=amount _LABEL_ = amount_type))
 name=at;
 by npi total_unique_benes;
 var total_submitted_chrg_amt total_medicare_allowed_amt total_medicare_payment_amt;
run;

proc sgplot data=cms_long;
   title1 "Association of Total Charges/Payments and Number of Beneficiaries"; 
   title2 "Best-Fit Line";
   label amount_type = "Amount Type";
   reg y=amount x=total_unique_benes / group=amount_type nomarkers; 
   xaxis label="Number of Medicare Beneficiaries";
   yaxis label="Total Amount";
   format amount dollar15.;
run;

proc contents data=npi.cms_providers_la (obs=10);
run;
/* ------------------------------------------------- */
/* Exercise 2 */
/* ---------------------------------------------------- */
proc transpose 
 data=npi.cms_providers_la
/*  pct = percent/100; */
 out=per_long (rename=(Col1=percent _LABEL_ = percent_of_conditions))
 name=at;
 by npi beneficiary_average_age; *x-axis;
 var beneficiary_cc_depr_percent 
 	beneficiary_cc_diab_percent 
 	beneficiary_cc_hypert_percent
 	beneficiary_cc_strk_percent
 	beneficiary_cc_ost_percent; *y-axis;
/*  if not(missing(percent)); */
run;

data per_long;
	set per_long;
	pct = percent/100;
run;

proc sgplot data=per_long;
   title1 "Association of Percentage of Beneficiaries With Conditions and Average Age of Beneficiaries"; 
   title2 "Best-Fit Line";
   label percent_of_conditions = "Percentage of Beneficiaries With Conditions";
   reg y=pct x=beneficiary_average_age / group=percent_of_conditions nomarkers; 
   xaxis label="Average Age of Beneficiaries";
   yaxis label="Percentage of Beneficiaries With Conditions";
/*    pct = percent /100; */
   format pct percent11.2;
run;

/* used to check for negative percent */
data per_long;
	set per_long;
	where (not missing(pct));
run;
proc sort data=per_long;
	by pct;
run;
proc print data=per_long (obs=100);
	var pct;
run;
/* ------------------------------------------------- */
/* Lab material */
/* ---------------------------------------------------- */
data psych;
 set npi.cms_providers_la;
 if provider_type = "Psychiatry";
run;

data totPsych (keep=TotChrgs);
 set psych end=last;
 TotChrgs + total_submitted_chrg_amt;
 if last then output;
run;

data pctPsych; 
set psych(keep=npi nppes_provider_last_org_name nppes_provider_first_name  total_submitted_chrg_amt); 
 if _n_ = 1 then set totPsych; 
 pct_submitted_charges = total_submitted_chrg_amt/TotChrgs; 
 format pct_submitted_charges percent10.3; 
run;

/* ------------------------------------------------- */
/* Exercise 3 */
/* ---------------------------------------------------- */
data FamPrac;
 set npi.cms_providers_la;
 if provider_type = "Family Practice";
run;

data totFamPrac (keep=TotServ);
 set FamPrac end=last;
 TotServ + total_services;
 if last then output;
run;

data pctFamPrac; 
 set famprac; 
 if _n_ = 1 then set totfamprac; 
 pct_total_services = total_services/Totserv; 
run;

/* to get range */
proc means data=pctfamprac min max;
	var pct_total_services;
run;
/* ------------------------------------------------- */
/* Exercise 4 */
/* ---------------------------------------------------- */
data FamPrac4;
 set npi.cms_providers_la;
 if provider_type = "Family Practice";
run;

data totFamPrac4 (keep=famtot);
 set FamPrac4 end=last;
 famtot + total_unique_benes;
 if last then output;
run;

data psych4;
 set npi.cms_providers_la;
 if provider_type = "Psychiatry";
run;

data totPsych4 (keep=psytot);
 set psych end=last;
 psytot + total_unique_benes;
 if last then output;
run;

data emeMed4;
	set npi.cms_providers_la;
	if provider_type = "Emergency Medicine";
run;

data totEmeMed4(keep=emetot);
	set emeMed4 end=last;
	emetot + total_unique_benes;
	if last then output;
run;

data three;
	set npi.cms_providers_la;
	if provider_type in ("Family Practice", "Psychiatry", "Emergency Medicine");
run;

data three_provider;
	set three;
	if _n_= 1 then set totFamPrac4;
	if _n_= 1 then set totPsych4;
	if _n_= 1 then set totememed4;
	if provider_type="Family Practice" then num_benes_relative_tot=total_unique_benes/famtot;
	else if provider_type="Psychiatry" then num_benes_relative_tot=total_unique_benes/psytot;
	else if provider_type="Emergency Medicine" then num_benes_relative_tot=total_unique_benes/emetot;
	format num_benes_relative_tot percent10.5;
run;

proc print data=three_provider noobs;
	var nppes_provider_last_org_name provider_type num_benes_relative_tot;
run;

proc means data=three_provider median;
	var num_benes_relative_tot;
	class provider_type;
run;

/* Alternative Elegent solutions------------------------------ */
data fam_psych_emerg;
	set npi.cms_providers_la;
	** Create the data set that consists of the 3 variables;

	if provider_type in ("Family Practice" "Psychiatry" "Emergency Medicine");
run;

proc summary data=fam_psych_emerg;
	class provider_type;
	var total_unique_benes;
	output out=total_benes_sum(drop=_FREQ_ _type_) sum=total_benes;
run;

*create data set to contain the sum of all total_unique_benes for each provider type;

proc sort data=total_benes_sum;
	by provider_type;
run;

proc sort data=fam_psych_emerg;
	by provider_type;
run;

data providers (keep=npi provider_Type total_benes num_benes_relative_tot);
	merge fam_psych_emerg(in=ind1) total_benes_sum;
	by provider_type;
	if ind1;
	num_benes_relative_tot=total_unique_benes/ total_benes;
run;

proc means data=providers median; 
class provider_type; 
var num_benes_relative_tot; 
run; 

/* ------------------------------------------------- */
/* Lab material */
/* ---------------------------------------------------- */
data cms_deactivated;
 length NPI $10;
 informat NPPES_Deactivation_Date mmddyy10.;
 infile "~/my_shared_file_links/u5338439/NPPES_Deactivated_NPI_Report_20171010.csv" dsd;
 input  NPI $
        NPPES_Deactivation_Date;
 format NPPES_Deactivation_Date mmddyy10.;
run;

title "Contents of the Deactivation NPI Report Data Set";
proc contents data=cms_deactivated;
run;

/* ------------------------------------------------- */
/* Exercise 5 */
/* ---------------------------------------------------- */
/* proc contents data=provider; */
/* run; */
/* proc print data=cms_deactivated (obs=10) noobs; */
/* run; */
/* proc print data=provider (obs=10) noobs; */
/* 	var npi; */
/* run; */
data provider;
	set npi.cms_providers_la;
run;

proc sort data=provider;
	by npi;
run;

proc sort data=cms_deactivated;
	by npi;
run;

data combine;
	merge provider (in=inprovide)
			cms_deactivated (in=indeactivate);
	by npi;
	if inprovide and indeactivate;
run;

proc sort data=combine;
	by NPPES_Deactivation_Date;
run;

/* to find out the number of observations */
proc contents data=combine;
run;

title "the earliest deactivation date in the sorted merged Data Set";
proc print data=combine (obs=1) noobs;
	var npi NPPES_Deactivation_Date;
run;

data combine_last(keep=NPPES_Deactivation_Date);
	set combine end=last;
	if last then output;
run;

title "the latest deactivation date in the sorted merged Data Set";
proc print data=combine_last (obs=1) noobs;
	var NPPES_Deactivation_Date;
run;
/* all the record refers to the intersections */
/* ------------------------------------------------- */
/* Exercise 6 */
/* ---------------------------------------------------- */
data provider;
	set npi.cms_providers_la;
run;

data cms_deactivated;
 length NPI $10;
 informat NPPES_Deactivation_Date mmddyy10.;
 infile "~/my_shared_file_links/u5338439/NPPES_Deactivated_NPI_Report_20171010.csv" dsd;
 input  NPI $
        NPPES_Deactivation_Date;
 format NPPES_Deactivation_Date mmddyy10.;
run;

proc sort data=provider;
	by npi;
run;

proc sort data=cms_deactivated;
	by npi;
run;

data updated_provider;
	update provider (in=inp) cms_deactivated;
	by npi;
	if inp;
run;

/* to validate answer */
proc contents data=updated_provider;
run;

proc contents data=npi.cms_providers_la;
run;

title "Listing of the updated provider dataset";
proc print data=updated_provider (obs=100);
run;