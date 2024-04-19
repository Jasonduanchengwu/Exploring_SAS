*SAS conditional logic and looping;
/* text operator and symbol operators are inter-changeable */
/* if ... then... OR if ... then ... else if ... then ...*/
/* & and | */
/* data is read one row at a time */
/* SAS remembers the first instance of the variable as the naming convention */

data conditional;
   length Gender $ 1
          Quiz   $ 2;
   input Age Gender Midterm Quiz FinalExam;
   if missing(age) then AgeGroup = .;
   else if Age <= 20 then AgeGroup = 1;
   else if Age >= 20 and Age lt 40 then AgeGroup = 2;
/* 	else if Age 20-39 then AgeGroup = 2; does not work*/
   else if Age ge 40 and Age lt 60 then AgeGroup = 3;
   else if Age ge 60 then AgeGroup = 4;
/*    else AgeGroup = 4; works*/

/* . represents numeric missing data while "" represents character missing data */
datalines;
21 M 80 B- 82
.  F 90 A  93
35 M 87 B+ 85
48 F  . .  76
59 F 95 A+ 97
15 M 88 .  93
67 F 97 A  91
.  M 62 F  67
35 F 77 C- 77
49 M 59 C  81
;
run;

data female;
   length Gender $ 1
          Quiz   $ 2;
   input Age Gender Midterm Quiz FinalExam;
   if Gender eq 'F'; *only gender = "F" would be stored;
datalines;
21 M 80 B- 82
.  F 90 A  93
35 M 87 B+ 85
48 F  . .  76
59 F 95 A+ 97
15 M 88 .  93
67 F 97 A  91
.  M 62 F  67
35 F 77 C- 77
49 M 59 C  81
;

title "Listing of Data Set Female";
proc print data=female noobs; *noobs omits the id;
run;

/* if Quiz = 'A+' or Quiz = "a" or Quiz = 'B+' or Quiz = 'B' then QuizRange = 1; */
/* else if Quiz = 'B-' or Quiz = 'C+' or Quiz = 'C' then QuizRange = 2; */
/* else if not missing(Quiz) then QuizRange = 3; */

/* we could use the following: */
/* (...) represents a grouping */
/* if Quiz in ('A+','A','A-','B+') then QuizRange = 1; */
/* else if Quiz in ('B-' 'C+' 'C') then QuizRange = 2; */
/* else if not missing(Quiz) then QuizRange = 3; */

data conditional;
   length Gender $ 1
          Quiz   $ 2;
   input Age Gender Midterm Quiz FinalExam;
   
   if Age lt 20 and not missing(age) then AgeGroup = 1;
   else if Age ge 20 and Age lt 40 then AgeGroup = 2;
   else if Age ge 40 and Age lt 60 then AgeGroup = 3;
   else if Age ge 60 then AgeGroup = 4;
   
   select(AgeGroup);
     when (1) Limit = 110;
     when (2) Limit = 120;
     when (3) Limit = 130;
     when (4) Limit = 140;
     otherwise; *Limit=0 it is else statement;
  end; *used to end select block;
datalines;
21 M 80 B- 82
.  F 90 A  93
35 M 87 B+ 85
48 F  . .  76
59 F 95 A+ 97
15 M 88 .  93
67 F 97 A  91
.  M 62 F  67
35 F 77 C- 77
49 M 59 C  81
;

title "Listing of Data Set Conditional";
proc print data=conditional noobs;
 var Age AgeGroup Limit;
run;

/* where statement and combining logical operators */
libname learn "~/my_shared_file_links/u5338439/";
options fmtsearch=(learn);

title "Listing of Data Set Medical";
proc print data=learn.medical;
 var Patno Clinic DX Wgt VisitDate;
 where clinic = 'HMC' and (DX in ('7','9') or wgt>180);
/*  read the question properly */
/*   where Clinic = 'HMC' and (DX="9" or DX="7") and wgt>180; */
/*   how to write this better? */
run;
/* % is used to represent any number of characters */
/* where is used for subsetting */
/* do groups allows for statements to be executed under the same condition block */

data grades;
	length gender $1
		quiz $2
		agegrp $13;
	infile "~/my_shared_file_links/u5338439/grades.txt" missover;
	input age gender midterm quiz finalexam;
/* 	if missing(age) then delete; */
	if not missing(age); *without then signifies subsetting;
	if age le 39 then do;
		agegrp="younger group";
		grade=0.4*midterm+0.6*finalexam;
	end;
	else if age gt 39 then do;
		agegrp="older group";
		grade=(midterm+finalexam)/2;
	end;
run;

proc print data=grades noobs;
run;

/* sum statements */
data revenue;
/*   place informat and length within input with : */
  input Day : $3.
        Revenue : dollar6.;
  Total + Revenue; *total=total+revenue;
  format revenue Total dollar8.; *can put all variables of the same format;
  datalines;
  Mon 150
  Tue 350
  Wed 200
  Thu 155
  Fri 415
  Sat 500
  Sun 115
  ;
run;
title "Listing of Data Set Revenue";
proc print data=revenue noobs;
run;

data test;
  input x @@; *@@ allows for one row of data to contain multiple data in one line;
  if missing(x) then MissCounter + 1;
  datalines;
  5 4 . 2 . 1 . . 0 3 . 5
  ;
/*   if input x; no @@ */
/*   datalines; */
/*   5  */
/*   4  */
/*   .  */
/*   2  */
/*   .  */
/*   1  */
/*   .  */
/*   .  */
/*   0  */
/*   3  */
/*   .  */
/*   5 */
/*   ; */
run;
title "Listing of Data Set Test";
proc print data=test noobs;
run;

/* do loops */

data compound;
   Interest = .0375;
   Total = 100;

   Year + 1;
   Total + Interest*Total;
   output;

   Year + 1;
   Total + Interest*Total;
   output;

   Year + 1;
   Total + Interest*Total;
   output; *this is to write out an observation to the output dataset;

   format Total dollar10.2;
run;

title "Listing of Data Set Compound";
proc print data=compound noobs;
run;

data compound;
	interest = .0375;
	total=100;
	do year = 1 to 10 by 0.5;
		total +interest*total;
		output;
	end;
	format total dollar10.2;
run;

title "listing of data set compound";
proc print data=compound noobs;
run;

data equation;
	do x=-10 to 10 by .01;
		y=2*x**3-5*x**2+15*x-8;
		output;
	end;
run;

title "plot of y versus x";
proc sgplot data=equation;
	series y=y x=x;
run;

data easyway;
	do group = "p", "a";
		do subj=1 to 5;
			output;
		end;
	end;
run;

proc print data=easyway noobs;
run;

data interest;
	interest =.0375;
	total=100;
	do until (total ge 200);
		year+1;
		total=total+interest*total;
		output;
	end;
	format total dollar10.2;
run;

proc print data=interest noobs;
run;

/* do while conditon is checked before executing while do until is executed first */

data double;
   Interest = .0375;
   Total = 300;
   do until (Total gt 200);
      Year + 1;
      Total = Total + Interest*Total;
      output;
   end;
   format Total dollar10.2;
run;
title "do until Example Printed";
proc print data=double noobs;
run;

data double;
   Interest = .0375;
   Total = 300;
   do while (Total lt 200);
      Year + 1;
      Total = Total + Interest*Total;
      output;
   end;
   format Total dollar10.2;
run;
title "do while Example Printed";
proc print data=double noobs;
run;

data continue_on;
   Interest = .0375;
   Total = 100;
   do Year = 1 to 100 until (Total ge 200);
      Total = Total + Interest*Total;
      if Total le 150 then continue;
      output;
   end;
   format Total dollar10.2;
run;
title "Listing of Data Set Continue_On";
proc print data=continue_on noobs;
run;
