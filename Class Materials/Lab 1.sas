data uni_rank;
 length Name$ 50
       Location$ 20;
 informat tuition comma10.
 		  in_state comma10.
 		  Ugrad_enroll comma10.;
 infile "~/my_shared_file_links/u5338439/US_University_Rankings.csv" dsd firstobs=2;
 input Name$
       Location$
       Rank
       Tuition
       In_state
       Ugrad_enroll;
/*        Tuition $ */
/*        In_state $ */
/*        Urgrad_enroll$; */
 label in_state = "Annual In-State Tuition";

*check out documentations to find out the options to include, median not included in the default;
Proc means data=uni_rank median;
/*  var Tuition; tuition is not numeric as it is a character type */
	var in_state ugrad_enroll;
	
run;

/* proc format; */
/*  value feefmt low-<20000 = "< $20,000" */
/*               20000-<30000 = "$20,000 to $29,999" */
/*               30000-<40000 = "$30,000 to $39,999" */
/*               40000-<50000 = "$40,000 to $49,999" */
/*               50000-high = "$50,000 or more"; */
/* run; */
/*  */
/* proc freq data=uni_rank; */
/* 	format tuition feefmt.; */
/* 	tables tuition; */
/* run; */

*actual exercise 2;
proc format;
 value feefmt low-<5000 = "< $5000"
              5000-<10000 = "5,000 to 9,999"
              10000-<15000 = "10,000 to 14,999"
              15000-<25000 = "15,000 to 24,999"
              25000-<35000 = "25,000 to 34,999"
              35000-high = "35,000 or more";
run;

proc freq data=uni_rank;
	format ugrad_enroll feefmt.;
	tables ugrad_enroll;
run;

/* proc freq data=uni_rank; */
/*  format tuition feefmt.; */
/*  tables location*tuition/nopercent; */
/* run; */

*Exercise 3;

*TO DO: this is creating fmt for rank to be crossed;
proc format;
 value rankfmt 1-50 = "Rank 1-50"
              51-100 = "Rank 51-100"
              101-high = "Rank > 100"
run;

proc freq data=uni_rank;
 format ugrad_enroll feefmt.
 		rank rankfmt.;
 tables ugrad_enroll*rank/nopercent norow;
run;

*exercise 4;
proc means data=uni_rank;
	format ugrad_enroll feefmt.;
	class ugrad_enroll;
run;

*exercise 5;
data uni_rank;
 length Name$ 50
       Location$ 50;
 informat tuition comma10.
 		  in_state comma10.
 		  Ugrad_enroll comma10.;
 infile "~/my_shared_file_links/u5338439/US_University_Rankings.csv" dsd firstobs=2;
 input Name$
       Location$
       Rank
       Tuition
       In_state
       Ugrad_enroll;
 label Name = "Name of University"
 		location = "Location of University"
 		Rank = "Rank of University"
 		Tuition = "Tuition and Fees"
 		in_state = "Annual In-State Tuition"
 		ugrad_enroll = "Undergraduate Enrollment";
 format in_state feefmt.
 		tuition feefmt.;

title "Alphabetic List of Variables and Attributes";
proc contents data=uni_rank;
run;


*---------------------------------------------------;
*lung cancer survey data set;

*exercise 6;
libname myfmts "~/my_non_shared_file_links/Formats";
options fmtsearch=(myfmts);

proc format library=myfmts;
	value $gendfmt 'M'="Male"
				  'F'="Female";
	value yesnofmt 1 = "NO"
					2 = "YES";
				 
data lung_cancer;
	infile "~/my_shared_file_links/u5338439/survey_lung_cancer.csv" dsd firstobs =2;
	input gender$
		  age
		  smoking
		  y_finger
		  anxiety
		  ppressure
		  cdisease
		  fatigue
		  allergy
		  wheezing
		  alcohol
		  coughing
		  short_of_breath
		  swallow_diff
		  chest_pain
		  lung_cancer$;
	format gender$ gendfmt.
			smoking--chest_pain yesnofmt.;
run;
	
*exercise 7;
* * means crossing;
/* proc freq data=lung_cancer; */
/*  tables gender*anxiety*lung_cancer/list; */
/* run; */

proc freq data=lung_cancer;
 tables (smoking anxiety ppressure alcohol)*lung_cancer/norow nopercent;
run;
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	