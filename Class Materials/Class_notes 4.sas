/* class notes 4: SAS subsetting , appending, and merging */

/* subsetting a SAS data set */
/* ----------------------------------- */
libname learn "~/my_non_shared_file_links/Data";

data females;
	set learn.survey(drop=salary);
	where gender = 'F';
run;
title 'Listing of the data set females';
proc print data=females noobs;
run;

data females;
	set learn.survey;
	where gender ='F';
	drop salary; *so the sequence of execution is not line by line?;
	monthly_salary= salary/12;
run;

data males females;
	set learn.survey;
	if gender ='F' then output females;
	else if gender ='M' then output males;
run;

title 'listing of the data set males';
proc print data=males noobs;
run;

/* Appending SAS data sets */
/* ------------------------------------- */
data one;
   length ID $ 3 Name $ 12;
   input ID Name Weight;
datalines;
7 Adams 210
1 Smith 190
2 Schneider 110
4 Gregory 90
;

data two;
   length ID $ 3 Name $ 12;
   input ID Name Weight;
datalines;
9 Shea 120
3 O'Brien 180
5 Bessler 207
;

data three;
   length ID $ 3 Gender $ 1.  Name $ 12;
   Input ID Gender Name;
datalines;
10 M Horvath
15 F Stevens
20 M Brown
;

/* formats inherits from the first data set in the single set statement */
data onetwothree;
	set one two three;
run;

title 'listing of the onetwothree data set';
proc print data= onetwothree noobs;
run;

/* need examples to set length? */

/* Multiple set statements */
/* ----------------------------- */
/* the set one was populated first  */
/* then set three was added in and overwrote repetitive sections */
data onethree;
	set one;
	set three;
run;

proc print data=onethree;
run;

/* performing a set operation conditionally */
/* ---------------------------------------- */
libname class '~/my_shared_file_links/u5338439/';
/* if want to save output without data step can use output statement */
proc means data=class.blood noprint;
	var chol;
	output out = means(keep=avechol)
			mean = avechol;
run;

title 'listing of the means data set';
proc print data=means noobs;
run;

data percent;
	set class.blood (keep=subject chol);
/* 	this ensures that only during first iteration */
/* 	means is added into the set */
	*because multi-set statements stops when one of the sets is exhausted, we only set it once for it to pertain for the rest;
	if _n_=1 then set means;  
	perchol =chol/avechol;
	drop avechol;
	format perchol percent8.;
run;

proc print data=percent (obs=10) noobs;
run;

/* Merging multiple SAS data sets */
/* --------------------------------------------- */
data employee;
   length ID $ 3 Name $ 12;
   input ID Name;
datalines;
7 Adams
1 Smith
2 Schneider
4 Gregory
5 Washington
;

data hours;
   length ID $ 3 JobClass $ 1;
   input ID 
         JobClass
         Hours;
datalines;
1 A 39
4 B 44
9 B 57
5 A 35
;
proc sort data=employee;
	by id;
run;

proc sort data=hours;
	by id;
run;

data combine;
	merge employee hours;
	by id;
run;

/* controlling observations when merging */
/* -------------------------------------------------- */

data combine;
	merge employee
			hours(in=inhours);
	by id;
	if inhours;
run;

proc print data=combine noobs;
run;

data combine;
	merge employee(in=inemploy)
			hours(in=inhours);
	by ID;
	if inemploy and inhours;
run;

proc print data=combine noobs;
run;

data ds1 ds2(drop = Name);
   merge employee(in=InEmploy)
         hours(in=InHours);
   by ID;
   if InEmploy and InHours then output ds1;
   else if InHours and not InEmploy then output ds2;
run;

/* merging sas data sets with different variable names or data types */
/* ---------------------------------------------- */
data bert;
   input ID $ X;
datalines;
123 90
222 95
333 100
;

data ernie;
   input EmpNo $ Y;
datalines;
123 200
222 205
333 317
;

data sesame;
   merge bert (rename=(ID = EmpNo))
         ernie;
   by EmpNo;
run;

title "Listing of the Bert Data Set";
proc print data=bert noobs;
run;

title "Listing of Ernie Data Set";
proc print data=ernie noobs;
run;

title "Listing of the Sesame Data Set";
proc print data=sesame noobs;
run;

data division1;
   input SS
         DOB : mmddyy10.
         Gender : $1.;
   format DOB mmddyy10.;
datalines;
111223333 11/14/1956 M
123456789 5/17/1946 F
987654321 4/1/1977 F
;

data division2;
   input SS : $11.
         JobCode : $3.
         Salary : comma8.0;
datalines;
111-22-3333 A10 $45,123
123-45-6789 B5 $35,400
987-65-4321 A20 $87,900
;

data division1c;
	set division1(rename=(ss=numss));
	ss=put(numss, ssn11.);
/* 	put() is numbers to char */
/* format does not change the underlaying values */
	drop numss;
run;

data division2n;
	set division2(rename=(ss=charss));
	ss=input(compress(charss, '-'), 9.);
	/* input() is used for char to digits */
	drop charss;
run;

/* why input for format division2n ??? */
data bdivisions;
	merge division1c division2;
	by ss;
run;
proc print data=bdivisions noobs;
run;

/* More complex types of merges */
/* -------------------------------------------- */

data oscar;
   input ID $ Y;
datalines;
123  200
123  250
222  205
333  317
333  400
333  500
;

data bert;
   input ID $ X;
datalines;
123 90
222 95
333 100
;

title "Listing of Oscar Data Set";
proc print data=oscar noobs;
run;

title "Listing of Bert Data Set";
proc print data=bert noobs;
run;

/* one to many */
data combine;
   merge bert
         oscar;
   by ID;
run;

title "Listing of Combine Data Set";
proc print data=combine noobs;
run;

/* updating a master file with a transaction file */
/* -------------------------------------- */

/* update is used when you dont want the second dataset value to replace the first */
/* thus updating the firstone */

data prices;
   Length ItemCode $ 3 Description $ 17;
   input ItemCode Description & Price;
/*    what is the purpose of the & operator */
datalines;
150 50 foot hose  19.95
175 75 foot hose  29.95
200 greeting card  1.99
204 25 lb. grass seed  18.88
208 40 lb. fertilizer  17.98
;
title "Listing of the Prices Data Set";
proc print data=prices noobs;
run;
data newdec2015;
   Length ItemCode $ 3;
   input ItemCode Price;
datalines;
204 17.87
175 25.11
208 .
;

title "Listing of the Newdec2015 Data Set";
proc print data=newdec2015 noobs;
run;

proc sort data=prices;
   by ItemCode;
run;
proc sort data=newdec2015;
   by ItemCode;
run;

data prices_dec2015;
	update prices newdec2015;
	by itemcode;
run;

title "Listing of the Prices_dec2015 Data Set";
proc print data=prices_dec2015 noobs;
run;