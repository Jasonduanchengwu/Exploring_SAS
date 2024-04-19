/* Demographic descriptive statistics for the sample
 in 2007 stratified by whether or not the respondent
 completed an assessment in 2011 */

libname mqp "~/my_non_shared_file_links/Data";

/* --------------------------------------- */
/* Age in years */
/* --------------------------------------- */
/* 322 BIRTMO17 Num 8 BIRTMO1F. W17 K1 What is your birth date? Month: */
/* 323 BIRTYR17 Num 8 BIRTYR1F. W17 K1 What is your birth date? Year: */
/* --------------------------------------- */
/* Annual Household Income */
/* --------------------------------------- */
/* 150 E5HI17 Num 8 W17 E5
Annual household income -high */
/* --------------------------------------- */
/* Mental Health Total Score */
/* --------------------------------------- */
/* 285 H13A17 Num 8 H13A17FF. W17 H13 Future looks hopeful and promising? */
/* 286 H13B17 Num 8 H13A17FF. W17 H13 Under any strain, stress, or pressure? */
/* 287 H13C17 Num 8 H13A17FF. W17 H13 Have you been anxious or worried? */
/* 288 H13D17 Num 8 H13A17FF. W17 H13 Have you generally enjoyed the things you do? */
/* 289 H13E17 Num 8 H13A17FF. W17 H13 Have you felt tired, worn out, or exhausted? */
/* 290 H13F17 Num 8 H13A17FF. W17 H13 Have you felt calm and peaceful? */
/* 291 H13G17 Num 8 H13A17FF. W17 H13 Have you felt downhearted and blue? */
/* 292 H13H17 Num 8 H13A17FF. W17 H13 Have you felt tense or "high strung"? */
/* 293 H13I17 Num 8 H13A17FF. W17 H13 Have you felt cheerful or lighthearted? */
/* 294 H13J17 Num 8 H13A17FF. W17 H13 Have you been moody or brooded about things? */
/* 295 H13K17 Num 8 H13A17FF. W17 H13 Have you felt depressed? */
/* 296 H13L17 Num 8 H13A17FF. W17 H13 Have you been in low or very low spirits? */
/* 297 H13M17 Num 8 H13A17FF. W17 H13 Have you felt lonely? */
/* 298 H13N17 Num 8 H13A17FF. W17 H13 Has your daily life been full of things that are interesting to you? */
/* 299 H13O17 Num 8 H13A17FF. W17 H13 Do you wake up feeling fresh and rested? */

proc sort data=mqp.my07; by famid;run;
proc sort data=mqp.my11; by famid;run;

%MACRO rev(var, dat);
	data &dat;
		set &dat;
		select(&var);
			when (1) &var=5;
			when (2) &var=4;
			when (3) &var=3;
			when (4) &var=2;
			when (5) &var=1;
			otherwise;
		end;
	run;
%mend rev;

/* ------------------------------------------------------------ */
/* completed assessment in 2011 */
/* ------------------------------------------------------------ */
data comp07and11;
	merge mqp.my07(in=in07) mqp.my11(in=in11);
	by famid;
	if in07 and in11;
	if (BIRTMO17 ne . and BIRTYR17 ne .) then age=(10-BIRTMO17+(2007-BIRTYR17)*12)/12;
	else age=.;
	keep famid age E5HI17 
	H13A17 H13B17 H13c17 H13d17 H13e17 
	H13f17 H13g17 H13h17 H13i17 H13j17 
	H13k17 H13l17 H13m17 H13n17 H13o17;
run;
/* to verify age calculations include below in keep statement*/
/* BIRTMO17 BIRTYR17 */

/* to verify reverse function */
proc print data=comp07and11 noobs;
	var H13A17 H13D17 H13F17 H13I17 H13N17 H13O17;
run;

%rev(H13A17, comp07and11);
%rev(H13D17, comp07and11);
%rev(H13F17, comp07and11);
%rev(H13I17, comp07and11);
%rev(H13N17, comp07and11);
%rev(H13O17, comp07and11);

/* to verify reverse function */
proc print data=comp07and11 (obs=10) noobs;
	var H13A17 H13D17 H13F17 H13I17 H13N17 H13O17;
run;

data comp07and11;
	set comp07and11;
	if (H13A17 ne . and H13B17 ne . and H13c17 ne . and H13d17 ne . and 
	H13e17 ne . and H13f17 ne . and H13g17 ne . and H13h17 ne . and 
	H13i17 ne . and H13j17 ne . and H13k17 ne . and  H13l17 ne . and 
	H13m17 ne . and H13n17 ne . and H13o17 ne .) then total_mental =
	H13A17+H13B17+H13c17+H13d17+H13e17+
	H13f17+H13g17+H13h17+H13i17+H13j17+ 
	H13k17+H13l17+H13m17+H13n17+H13o17;
	else total_mental = .;
run;

proc contents data=comp07and11; run;
proc print data=comp07and11 noobs;
	var H13A17 H13B17 H13c17 H13d17 H13e17 
	H13f17 H13g17 H13h17 H13i17 H13j17 
	H13k17 H13l17 H13m17 H13n17 H13o17 total_mental;
run;
/* age E5HI17 total_mental*/
proc tabulate data=comp07and11;
	var total_mental;
	table total_mental*(n mean std);
run;

/* verify missing mental */
data missmental;
	set comp07and11;
	if total_mental=.;
run;
proc contents data=missmental; run;

/* ------------------------------------------------------------ */
/* did not completed assessment in 2011 */
/* ------------------------------------------------------------ */
data comp07not11;
	merge mqp.my07(in=in07) mqp.my11(in=in11);
	by famid;
	if in07 and not in11;
	if (BIRTMO17 ne . and BIRTYR17 ne .) then age=(10-BIRTMO17+(2007-BIRTYR17)*12)/12;
	else age=.;
	keep famid age E5HI17 
	H13A17 H13B17 H13c17 H13d17 H13e17 
	H13f17 H13g17 H13h17 H13i17 H13j17 
	H13k17 H13l17 H13m17 H13n17 H13o17;
run;

/* to verify reverse function */
proc print data=comp07not11 (obs=10) noobs;
	var H13A17 H13D17 H13F17 H13I17 H13N17 H13O17;
run;

%rev(H13A17, comp07not11);
%rev(H13D17, comp07not11);
%rev(H13F17, comp07not11);
%rev(H13I17, comp07not11);
%rev(H13N17, comp07not11);
%rev(H13O17, comp07not11);

/* to verify reverse function */
proc print data=comp07not11 (obs=10) noobs;
	var H13A17 H13D17 H13F17 H13I17 H13N17 H13O17;
run;

data comp07not11;
	set comp07not11;
	if (H13A17 ne . and H13B17 ne . and H13c17 ne . and H13d17 ne . and 
	H13e17 ne . and H13f17 ne . and H13g17 ne . and H13h17 ne . and 
	H13i17 ne . and H13j17 ne . and H13k17 ne . and  H13l17 ne . and 
	H13m17 ne . and H13n17 ne . and H13o17 ne .) then total_mental =
	H13A17+H13B17+H13c17+H13d17+H13e17+
	H13f17+H13g17+H13h17+H13i17+H13j17+ 
	H13k17+H13l17+H13m17+H13n17+H13o17;
	else total_mental = .;
run;

proc contents data=comp07not11; run;

/* verify addition */
proc print data=comp07not11 noobs;
	var H13A17 H13B17 H13c17 H13d17 H13e17 
	H13f17 H13g17 H13h17 H13i17 H13j17 
	H13k17 H13l17 H13m17 H13n17 H13o17 total_mental;
run;
/* age E5HI17 total_mental*/
proc tabulate data=comp07not11;
	var total_mental;
	table total_mental*(n mean std);
run;

/* verify missing mental */
data missmental;
	set comp07not11;
	if total_mental=.;
run;
proc contents data=missmental; run;