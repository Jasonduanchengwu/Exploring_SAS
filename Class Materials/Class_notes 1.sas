/* data demographic; */
/*  infile "~/my_shared_file_links/u5338439/mydata.csv" dlm=','; */
/*  infile "~/my_shared_file_links/u5338439/mydata.txt"; */
/*  input Gender$ Age Height Weight; */
/*  label Gender = "Gender Definition"; */
/* run;  */

/* title "List of demographics"; */
/* proc print data = demographic; */
/* run; */

/* data bank; */
/*  infile "~/my_shared_file_links/u5338439/bank.txt"; */
/*  input subj$ 1-3 */
/*  		dob$ 4-13 */
/*  		gender$ 14 */
/*  		balance$ 15-21; */
/* run; */

/* title "descriptor of bank infos"; */
/* proc contents data=bank; */
/* run; */

/* data overdose; */
/*  length state $ 2 */
/*         state_name $ 2 */
/*         year $ 4 */
/*         month $ 9 */
/*         indicator $ 45 */
/*         percent_complete $ 5 */
/*         footnote $ 36; */
/*  infile "~/my_shared_file_links/u5338439/VSRR_Provisional_Drug_Overdose_Death_Counts.csv" dsd firstobs=2; */
/*  input state $ */
/*        state_name $  */
/*        year $  */
/*         month $ */
/*         indicator $ */
/*         data_value  */
/*         predicted_value  */
/*         percent_complete $ */
/*         percent_pending_investigation */
/*         footnote $; */
/* run; */
/*  */
/* title "overd"; */
/* proc print data=overdose (obs=15); */
/*  var year month indicator; */
/* run; */

data university_ranking;
 length Name$ 50
       Location$ 20
       Tuition$ 20
       In_state$ 20
       Undergrad_enrollment$ 20;
 infile "~/my_shared_file_links/u5338439/US_University_Rankings.csv" dsd firstobs=2;
 input Name$
       Location$
       Rank
       Tuition$
       In_state$
       Undergrad_enrollment$;
run;