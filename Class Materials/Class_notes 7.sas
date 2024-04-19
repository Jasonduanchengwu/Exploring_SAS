libname dat "~/my_shared_file_links/u5338439/";

/* Introduction to Longitudinal Data */
proc print data=dat.clinical (obs=5) noobs;
run;

/* Identifying the First or Last Observation in a Group */
proc sort data=dat.clinical out=clinical;
 by PID VisitDate;
run; 

data last;
 set clinical;
 by PID;
/*  put is used to show in logs that the specified variable values in each iteration */
 put PID= VisitDate= First.PID= Last.PID=;
/*  most recent visit for each pid, first. and last. is inbuilt name*/
 if Last.PID;
run; 

data count;
 set clinical; 
 by PID;
 if first.PID then N_visits = 0; *without this condition, it becomes cumulative;
  N_visits + 1;
 if last.PID then output;
run; 

/* -------------------------------------------------------- */
/* need fixing */
proc sort data=dat.clinical out=clinical;
 by PID n_rountine_visits;
run; 

data count_routine;
	set clinical;
	by pid;
	if first.pid then N_routine_visits=0;
		if dx="1" then N_routine_visits+1;
	if last.pid;
run;
/* --------------------------------------------------------------- */
/* Counting the Number of Visits using proc freq */
proc freq data=clinical noprint;
 tables PID/out=counts (rename = (count = N_Visits) drop = percent);
run; 

proc print data=counts;
run;

proc sort data=clinical; by PID; run;
proc sort data=counts; by PID; run;

data clinical_counts;
 merge clinical
       counts;
 by PID;
run;

proc print data=clinical_counts noobs;
run;

/* Computing Differences between Observations */
data difference;
 set clinical;
 by PID;
 if first.PID and last.PID then delete; *only 1 obs;
  Diff_HR  = HR - lag(HR);
  Diff_SBP = SBP - lag(SBP);
  Diff_DBP = DBP - lag(DBP);
 if not first.PID then output; *first obs has no prev obs;
/*  the values are executed upon the output dataset in the next iteration */
/* 	thats why the total was reset since the latest obs is not "outputted" */
run;

proc print data=difference noobs;
run;

data difference;
 set clinical;
 by PID;
 if first.PID and last.PID then delete;
  Diff_HR  = HR - lag(HR);
  Diff_SBP = SBP - lag(SBP);
  Diff_DBP = DBP - lag(DBP);
 *if not first.PID then output;
run;

proc print data=difference noobs;
run;

data difference;
 set clinical;
 by PID;
 if not first.PID then do;
  Diff_HR  = HR - lag(HR);
  Diff_SBP = SBP - lag(SBP);
  Diff_DBP = DBP - lag(DBP);
 end;
run;

proc print data=difference noobs;
run;

/* Computing Differences between First and Last Observations in a by Group */
data first_last;
 set clinical;
 by PID;
 if first.PID and last.PID then delete;
 if first.PID or last.PID then do; *only executed twice, so lag works;
  Diff_HR  = HR - lag(HR);
  Diff_SBP = SBP - lag(SBP);
  Diff_DBP = DBP - lag(DBP);
 end;
 if last.PID then output;
run;

proc print data=clinical noobs;
run;

proc print data=first_last noobs;
run;

/* using retain statement */
data first_last;
 set clinical;
 by PID;
 if first.PID and last.PID then delete;
 retain First_HR First_SBP First_DBP; *the values are retained throughout the executions;
 if first.PID then do;
  First_HR  = HR;
  First_SBP = SBP;
  First_DBP = DBP;
 end;
 if last.PID then do;
  Diff_HR  = HR - First_HR;
  Diff_SBP = SBP - First_SBP;
  Diff_DBP = DBP - First_DBP; 
  output;
 end;
 drop First_:;
run;

/* try execise 1*/
data hypertension;
	length HighBP $3.;
	set clinical;
	by pid;
	retain HighBP;
	if first.pid then HighBP="No";
	if SBP>140 then HighBP="Yes";
	if last.pid;
run;
		
/* exercise 2 */

/* Performing an Operation on Several Variables */
proc print data=dat.spss noobs;
run;

data new;
 set dat.SPSS;
 if Height = 999 then Height = .;
 if Weight = 999 then Weight = .;
 if Age = 999 then Age = .;
 if HR = 999 then HR = .;
 if Chol = 999 then Chol = .;
run;

/* Numeric Array Example */
data new;
 set dat.SPSS;
 array myvars{5} Height -- Chol;
 do i = 1 to 5;
  if myvars{i} = 999 then myvars{i} = .;
 end;
 drop i;
run;
/* can use all of these for array: [], (), {} */
proc print data=new noobs;
run;

/* Character Array Example */
proc print data=dat.careless noobs;
run;
proc contents data=dat.careless;
run;
data lower;
 set dat.careless;
 array all_chars{*} $ _character_; *all character variables;
 do i = 1 to dim(all_chars); *dim outputs the number of variables in that array;
  all_chars{i} = lowcase(all_chars{i});
 end;
 drop i;
 *i will be incremented again at the end and checked for condition in the next iteration;
run;

proc print data=lower noobs;
run;

/* Creating New Variables using an Array */
data temp;
   input Fahren1-Fahren24 @@; *@@ reads data in one row not newline;
   array Fahren{24};
   array Celsius{24}  Celsius1-Celsius24;
/* the loops puts the obs into the rows (long format) */
   do Hour = 1 to 24;
      Celsius{Hour} = (Fahren{Hour} - 32)/1.8;
   end;
   drop Hour;
datalines;
35 37 40 42 44 48 55 59 62 62 64 66 68 70 72 75 75
72 66 55 53 52 50 45
;

proc print data=temp noobs;
 var Fahren1-Fahren3 Celsius1-Celsius3;
run;

/* Temporary Arrays */
data score;
   array ans{10} $ 1; *specifies the length of each element;
   array key{10} $ 1 _temporary_; *exists within the block and is not output;
      ('A','B','C','D','E','E','D','C','B','A');
   input ID (Ans1-Ans10)($1.);
   RawScore = 0;
   do Ques = 1 to 10;
      RawScore + (key{Ques} eq Ans{Ques});
   end;
   Percent = 100*RawScore/10;
   keep ID RawScore Percent;
datalines;
123 ABCDEDDDCA
126 ABCDEEDCBA
129 DBCBCEDDEB
;

/* Exercise */
proc print data=dat.survey2;
run;