/* saving the format in library */
libname myfmts "~/my_non_shared_file_links/Formats";
options fmtsearch=(myfmts);

libname mydat "~/my_non_shared_file_links/Data";
proc freq data=mydat.survey;
	tables ques1-ques5;
	format ques1-ques5 $two.;
run;

/* picture format */
proc format;
 picture yrfmt Low-high = "999.9 years";
run; 

proc print data=mydat.survey;
 format Age yrfmt.;
 var Age;
run;

/* dates in SAS */

/* SAS informats */
/* undo preexisting format and perform your own fmt on the data */
data list_example;
 *informat is specifing to SAS how the raw file was formatted, so SAS knows how to read it;
 informat subj    $3.
          name    $20.
          DOB   mmddyy10.
          salary dollar8.;
 infile "~/my_shared_file_links/u5338439/list.csv" dsd;
 input subj
       name
       DOB
       salary;
 *format is displaying the format specified;
 format dob date9.
 		salary dollar8.;
run;

title "Listing of the data set list_example";
proc print data=list_example;
   id subj;
run;



