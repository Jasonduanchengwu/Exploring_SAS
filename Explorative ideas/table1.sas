libname mqp "~/my_non_shared_file_links/Data";

/* use class for discrete/categorical variables */
/* use var for continuous/numeric variables */

proc sort data=mqp.my07; by famid;run;
proc sort data=mqp.my11; by famid;run;


/* Table 1. Demographic and employment frequencies
 for the sample in 2007 stratified by whether or
 not the respondent completed an assessment in 2011. */
/* -------------------------------------------- */
/* -------------------------------------------- */
/* W1C542C(gender): 0-Female, 1-Male */
/* C1ED17 Num 8 C1ED17FF. W17 C1 Highest level of education */

/* o	High school or less (include High school or GED and Elementary or junior high) 	1+2 */
/* o	Technical or vocational 														3 */
/* o	Some college (include Some College and Associate degree)						4+5 */
/* o	Bachelor’s degree 																6 */
/* o	Graduate degree (include Master’s degree and PhD or professional) 				7+8 */

/* D617 Num 8 D617FFFF. W17 D6 Currently employed (either part-time or full-time) */
/* F1017 Num 8 F317FFFF. W17 F10 Are you currently married or cohabiting in an intimate relationship? */
/* F517 Num 8 F317FFFF. W17 F5 Do you have any children? */

proc format;
	value gender 0="Female"
				1="Male"
				.="Missing";
	value hle 1-2 = "High school or less"
			3="Technical or vocational"
			4-5="Some college"
			6="Bachelor’s degree"
			7-8="Graduate degree"
			.="Missing";
	value yesno 1="No"
					2="Yes"
					.="Missing";
	value jsec 1="Not at all secure"
				2="Somewhat secure"
				3="Secure"
				4="Very Secure"
				.="Missing";
	value jsat 1-2="Extremely or very dissatisfied"
				3="Somewhat dissatisfied"
				4="Somewhat satisfied"
				5-6="Extremely or Very satisfied"
				.="Missing";
run;

/* ------------------------------------------------------------ */
/* completed assessment in 2011 */
/* ------------------------------------------------------------ */
data comp07and11;
	merge mqp.my07(in=in07) mqp.my11(in=in11);
	by famid;
	if in07 and in11;
	label W1C542C="Gender" C1ED17="Highest level of Education" D617="Currently employed" 
			F1017="currently married" F517="any children";
	keep famid W1C542C C1ED17 D617 F1017 F517 D1617 D1817;
	format W1C542C gender.
			C1ED17 hle.
			D617 yesno.
			F1017 yesno.
			F517 yesno.;
run;

proc print data=comp07and11 noobs;run;
/* W1C542C C1ED17 D617 F1017 F517 */
proc tabulate data=comp07and11 missing;
	class F517;
	table (F517 *(n="N" pctn="%") ALL);
run;

/* D1617 Num 8 D1617FFF. W17 D16 How secure is your primary job? */
/* D1817 Num 8 D1817FFF. W17 D18 How satisfied with your job as a whole? */

data jsecjsat;
	set comp07and11;
	if D617=2;
	keep famid D617 D1617 D1817;
	label D1617="Job Security" C1ED17="Job satisfaction";
	format D1617 jsec. D1817 jsat.;
run;
/* D1617 D1817 */
proc tabulate data=jsecjsat missing;
	class D1817;
	table (D1817)*(n pctn="%") ALL;
run;

/* ------------------------------------------------------------ */
/* Did not completed assessment in 2011 */
/* ------------------------------------------------------------ */

proc sort data=mqp.my07; by famid;run;
proc sort data=mqp.my11; by famid;run;

data comp07not11;
	merge mqp.my07(in=in07) mqp.my11 (in=in11);
	by famid;
	if in07 and not in11;
	label W1C542C="Gender" C1ED17="Highest level of Education" D617="Currently employed" 
			F1017="currently married" F517="any children";
	keep famid W1C542C C1ED17 D617 F1017 F517 D1617 D1817;
	format W1C542C gender.
			C1ED17 hle.
			D617 yesno.
			F1017 yesno.
			F517 yesno.;
run;

proc print data=comp07not11 noobs;run;
/* W1C542C C1ED17 D617 F1017 F517 */
proc tabulate data=comp07not11 missing;
	class F517;
	table (F517 *(n pctn="%") ALL);
run;

data check;
	set comp07and11;
	if F517 =.;
run;
/* D1617 Num 8 D1617FFF. W17 D16 How secure is your primary job? */
/* D1817 Num 8 D1817FFF. W17 D18 How satisfied with your job as a whole? */

data jsecjsatnot11;
	set comp07not11;
	if D617=2;
	keep famid D617 D1617 D1817;
	label D1617="Job Security" C1ED17="Job satisfaction";
	format D1617 jsec. D1817 jsat.;
run;
/* D1617 D1817 */
proc tabulate data=jsecjsatnot11 missing;
	class D1617;
	table (D1617)*(n pctn="%") ALL;
run;

/* finding missing for job satisfaction */
data miss0711;
	set mqp.my07;
	if famid in (1763, 260, 1094);
	keep famid D617 D1817;
run;


