/* Classnote 6 */
libname dat "~/my_shared_file_links/u5338439/";

proc contents data=dat.blood;
run;
proc print data=dat.blood (obs=10) noobs;
run;
/* use class for discrete/categorical variables */
/* use var for continuous/numeric variables */

/* Descriptive statistics */
/* ----------------------------------------------------------------- */
proc tabulate data=dat.blood format=comma9.2;
	var RBC WBC;
	table (RBC WBC)*(mean min max);
run;

/* combining class and analysis variables in a table */
/* ------------------------------------------------------------------------------------ */
/* ALL includes all of the combined statistics too */
proc tabulate data=dat.blood format=comma11.2;
	class gender agegroup;
	var RBC WBC Chol;
/* 	when using "," in table, first argument is defining the row while the second is for col */
	table (gender ALL)*(agegroup ALL),
		(RBC WBC Chol)*mean;
run;

proc tabulate data=dat.blood format=comma11.2;
	class gender agegroup;
	var RBC WBC Chol;
	table (gender)*(agegroup),
		(RBC WBC Chol)*mean;
run;

/* customizing tables */
proc tabulate data=dat.blood;
	var RBC WBC Chol;
/* 	for individual format apply to different col */
	table RBC*mean*f=7.2 WBC*mean*f=comma7.;
run;

proc tabulate data=dat.blood;
	class gender;
	var RBC WBC;
	table gender ALL,
			RBC*(mean*f=9.1 std*f=9.2)
			WBC*(mean*f=comma9. std*f=comma9.1);
	keylabel ALL="Total"
			mean="Average"
			std="Standard Deviation";
run;

proc tabulate data=dat.blood noseps;
	class gender bloodtype;
	table gender bloodtype;
run;

proc tabulate data=dat.blood;
	class gender bloodtype;
	table gender*n='' bloodtype*n='';
run;

/* Returning to the complex table */
proc tabulate data=dat.blood format=comma9.2;
 class gender AgeGroup;
 var RBC WBC Chol;
 table (Gender = '' ALL)*(AgeGroup=' ' ALL),
       RBC*(n*f=3. mean*f=5.1)
       WBC*(n*f=3. mean*f=comma7.)
       Chol*(n*f=4. mean*f=7.1);
 keylabel ALL = 'Total';
run;

/* Computing percentages */
proc tabulate data=dat.blood;
	class bloodtype;
	table bloodtype*(n pctn);
run;

proc format; 
	*round will ensure rounding happens first before truncation 
	like 56.38 will be 56.4 instead of 56.3;
	picture pctfmt (round)
/* 0 is like ? while 9 is like + in regex, picture only works in numeric */
			low-high='009.9%';
run;

proc tabulate data=dat.blood;
	class bloodtype;
	table bloodtype*(n pctn*f=pctfmt.);
run;
/* ------------------------------------------------------------------------------------------------ */
/* displaying percentages in a two-D table */
proc tabulate data=dat.blood;
	class gender bloodtype;
	table (bloodtype ALL),
		(gender ALL)*(n*f=5. pctn*f=pctfmt.);
	keylabel ALL="Both Genders"
			n='Count'
			pctn='Percent';
run;
/* ------------------------------------------------------------------------------------------------ */
/* column percent */
proc tabulate data=dat.blood;
	class gender bloodtype;
	table (bloodtype ALL='ALL Blood Types'),
		(gender ALL)*(n*f=5. colpctn*f=pctfmt.);
	keylabel ALL="Both Genders"
			n='Count'
			pctn='Percent';
run;

/* row percent */
proc tabulate data=dat.blood;
	class gender bloodtype;
	table (bloodtype ALL='ALL Blood Types'),
		(gender ALL)*(n*f=5. rowpctn*f=pctfmt.);
	keylabel ALL="Both Genders"
			n='Count'
			pctn='Percent';
run;

/* computing percentages of numeric variables */
proc contents data=dat.sales;
run;

proc print data=dat.sales (obs=10) noobs;
run;

proc tabulate data=dat.sales;
	class region;
	var totalsales;
	table (region ALL),
			totalsales*(n*f=6. sum*f=dollar8. pctsum*f=pctfmt.)/box='Total Sales by Region';
	keylabel ALL="All Regions"
			n='Number of Sales'
			sum='Total Amount'
			pctsum='Percent';
	label totalsales ="Total Sales";
run;

/* missing values and proc tabulate */
title "Listing of the Data Set Missing";
proc print data=dat.missing;
run;

proc tabulate data=dat.missing format=4.;
	class A B;
	table A ALL, B ALL;
run;

proc tabulate data=dat.missing format=4.;
	class A B C;
	table A ALL, B ALL;
run;

proc tabulate data=dat.missing format=4. missing;
	class A B C;
	table A ALL, B ALL;
run;

proc tabulate data=dat.missing format=4. missing;
	class A B C;
	table A ALL, B ALL/misstext='NA';
run;

/* Exercise 1 */
proc format;
 value rnkfmt 1-50 = "Rank 1-50"
              51-100 = "Rank 51-100"
              101-high = "Rank > 100";
 value enrfmt low-<5000 = "< 5,000"
              5000-<10000 = "5,000 to 9,999"
              10000-<15000 = "10,000 to 14,999"
              15000-<25000 = "15,000 to 24,999"
              25000-<35000 = "25,000 to 34,999"
              35000-high = "35,000 or more";            
run;

proc tabulate data=dat.rankings;
	format rank rnkfmt.
			undergrad_enrollment enrfmt.;
	class rank undergrad_enrollment; *categorical;
	tables undergrad_enrollment="Undergraduate Enrollment",
			rank=""*(n*f=5. colpctn="%"*f=pctfmt.);
run;

/* class exercise 2 */
/* picture format has to start with an digit placeholder thus the prefix option*/
 proc format;
  picture paren (round)
          low-high = '00009.9)' (prefix = '(');
 run;
 
 *read documentation for style for more options;
 proc tabulate data=dat.rankings;
 format undergrad_enrollment enrfmt. rank rnkfmt.;
 class undergrad_enrollment rank;
 table rank,
       undergrad_enrollment=''*(n=''*[style={just=r borderrightstyle=hidden}]
                colpctn=''*[style={just=l} f=paren.]);
run;  