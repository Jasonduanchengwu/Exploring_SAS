libname lb "~/my_shared_file_links/u5338439/";

proc contents data=lb.hlth_2009;
run;

proc sort data=lb.hlth_2009;
	by IND_ID HH_ID;
run;

proc transpose data=lb.hlth_2009 out=hlth_long_headache;
	by IND_ID HH_ID;
 	var HEADACHE_2004
     HEADACHE_2006
     HEADACHE_2009;
run;

proc print data=hlth_long_headache (obs=6) noobs;
run;

proc transpose data=lb.hlth_2009 out=hlth_long_headache (rename=(COL1=HEADACHE)) name=WAVE;
 by IND_ID HH_ID;
 var HEADACHE_2004
     HEADACHE_2006
     HEADACHE_2009;
run;

data hlth_long_headache;
 set hlth_long_headache;
 WAVE = compress(WAVE, '_', 'a');
run;

proc print data=hlth_long_headache (obs=6) noobs;
run;

/* ------------------------------------ */
/* exercise 1 */
/* ----------------------------------------- */
proc transpose data=lb.hlth_2009 out=hlth_very_long (rename=(COL1=INDICATOR)) name=EXTRACT;
	by IND_ID HH_ID;
	var HEADACHE_2004
     	HEADACHE_2006
     	HEADACHE_2009
    	SORETHROAT_2004
    	SORETHROAT_2006
    	SORETHROAT_2009
    	STOMACHACHE_2004	
    	STOMACHACHE_2006	
    	STOMACHACHE_2009;
run;

data hlth_very_long;
	set hlth_very_long;
	length WAVE $4.;
	WAVE = compress(EXTRACT, '_', 'a');
	SYMPTOM = compress(EXTRACT, '_', 'd');
	drop extract;
run;
proc contents data=hlth_very_long;
run;
proc print data=hlth_very_long (obs=9) noobs;
run;

/* ---------------------------- */
/* Exercise 2 */
/* ---------------------------------- */
proc transpose data=lb.hlth_2009 out=hlth_long_ha (rename=(COL1=HEADACHE))  name=HA;
	by IND_ID HH_ID HH_TYPE;
	var HEADACHE_2004
     	HEADACHE_2006
     	HEADACHE_2009;
run;

proc transpose data=lb.hlth_2009 out=hlth_long_st (rename=(COL1=SORETHROAT)) name=ST;
	by IND_ID HH_ID HH_TYPE;
	var SORETHROAT_2004
    	SORETHROAT_2006
    	SORETHROAT_2009;
run;

proc transpose data=lb.hlth_2009 out=hlth_long_sa (rename=(COL1=STOMACHACHE)) name=SA;
	by IND_ID HH_ID HH_TYPE;
	var STOMACHACHE_2004	
    	STOMACHACHE_2006	
    	STOMACHACHE_2009;
run;

data hlth_long_ha;
	set hlth_long_ha;
	Length WAVE $4;
	WAVE = compress(HA, '_', 'a');
	drop HA;
run;

data hlth_long_st;
	set hlth_long_st;
	Length WAVE $4;
	WAVE = compress(ST, '_', 'a');
	drop ST;
run;

data hlth_long_sa;
	set hlth_long_sa;
	Length WAVE $4;
	WAVE = compress(SA, '_', 'a');
	drop SA;
run;

proc sort data=hlth_long_ha;
	by IND_ID HH_ID WAVE;
run;
proc sort data=hlth_long_st;
	by IND_ID HH_ID WAVE;
run;
proc sort data=hlth_long_sa;
	by IND_ID HH_ID WAVE;
run;

data hlth_long;
	merge hlth_long_ha hlth_long_st hlth_long_sa;
	by IND_ID HH_ID WAVE;
run;
proc contents data=hlth_long;
run;

proc print data=hlth_long (obs=50) noobs;
run;

/* ---------------------------------- */
/* Exercise 3 need exercise 2*/ 
/* --------------------------------------- */
/* part1 */
proc sort data=hlth_long;
	by WAVE;
run;
proc freq data=hlth_long; *remove missing by default /missing would include missing;
	table HEADACHE SORETHROAT STOMACHACHE;
	by WAVE;
run;
/* part2n3 */
proc sort data=hlth_long;
	by WAVE;
run;
proc freq data=hlth_long;
	table HH_TYPE* (HEADACHE SORETHROAT STOMACHACHE) /nofreq nocol nopercent;
	by WAVE;
run;
/* it is table description*row*col for cross tabulation*/
/* ---------------------------------- */
/* Classnotes */
/* --------------------------------------- */
data hlth_array_long_headache;
 set lb.hlth_2009;
 array headache_array{3} 
       HEADACHE_2004
       HEADACHE_2006
       HEADACHE_2009;
 array wv{3}$ wv1-wv3 ('2004','2006','2009');
 do i = 1 to 3;
  HEADACHE = headache_array{i};
  WAVE = wv{i};
  output;
 end;
 keep HEADACHE IND_ID HH_ID WAVE;
run;

proc print data=hlth_array_long_headache (obs = 8) noobs;
run;




/* ---------------------------------- */
/* Exercise 4 */
/* --------------------------------------- */
libname lb "~/my_shared_file_links/u5338439/";
data hlth_array_long;
 retain IND_ID HH_ID WAVE HEADACHE SORETHROAT STOMACHACHE HH_TYPE;
 set lb.hlth_2009;
 array headache_array{3} 
       HEADACHE_2004
       HEADACHE_2006
       HEADACHE_2009;
 array sorethroat_array{3} 
       SORETHROAT_2004
       SORETHROAT_2006
       SORETHROAT_2009;
 array stomachache_array{3} 
       STOMACHACHE_2004
       STOMACHACHE_2006
       STOMACHACHE_2009;
 array wv{3}$ wv1-wv3 ('2004','2006','2009');
 do i = 1 to 3;
  HEADACHE = headache_array{i};
  SORETHROAT = sorethroat_array{i};
  STOMACHACHE = stomachache_array{i};
  WAVE = wv{i};
  output;
 end;
 keep HEADACHE SORETHROAT STOMACHACHE IND_ID HH_ID WAVE HH_TYPE;
run;

proc contents data=hlth_array_long;
run;
proc print data=hlth_array_long (obs = 9) noobs;
run;

/* data hlth_array_long_headache; */
/*  set lb.hlth_2009; */
/*  array headache_array{3}  */
/*        HEADACHE_2004 */
/*        HEADACHE_2006 */
/*        HEADACHE_2009; */
/*  array wv{3}$ wv1-wv3 ('2004','2006','2009'); */
/*  do i = 1 to 3; */
/*   HEADACHE = headache_array{i}; */
/*   WAVE = wv{i}; */
/*   output; */
/*  end; */
/*  keep HEADACHE IND_ID HH_ID WAVE HH_TYPE; */
/* run; */
/*  */
/* data hlth_array_long_sorethroat; */
/*  set lb.hlth_2009; */
/*  array sorethroat_array{3}  */
/*        SORETHROAT_2004 */
/*        SORETHROAT_2006 */
/*        SORETHROAT_2009; */
/*  array wv{3}$ wv1-wv3 ('2004','2006','2009'); */
/*  do i = 1 to 3; */
/*   SORETHROAT = sorethroat_array{i}; */
/*   WAVE = wv{i}; */
/*   output; */
/*  end; */
/*  keep SORETHROAT IND_ID HH_ID WAVE HH_TYPE; */
/* run; */
/*  */
/* data hlth_array_long_stomachache; */
/*  set lb.hlth_2009; */
/*  array stomachache_array{3}  */
/*        STOMACHACHE_2004 */
/*        STOMACHACHE_2006 */
/*        STOMACHACHE_2009; */
/*  array wv{3}$ wv1-wv3 ('2004','2006','2009'); */
/*  do i = 1 to 3; */
/*   STOMACHACHE = stomachache_array{i}; */
/*   WAVE = wv{i}; */
/*   output; */
/*  end; */
/*  keep STOMACHACHE IND_ID HH_ID WAVE HH_TYPE; */
/* run; */
/* proc sort data = hlth_array_long_headache; */
/* 	by IND_ID HH_ID WAVE; */
/* run; */
/* proc sort data =hlth_array_long_sorethroat; */
/* 	by IND_ID HH_ID WAVE; */
/* run; */
/* proc sort data =hlth_array_long_stomachache; */
/* 	by IND_ID HH_ID WAVE; */
/* run; */
/* data hlth_array_long; */
/* 	merge hlth_array_long_headache hlth_array_long_sorethroat hlth_array_long_stomachache; */
/* 	by IND_ID HH_ID WAVE; */
/*  */
/* proc contents data=hlth_array_long; */
/* run; */

/* to validify dataset */
/* data hlth_array_long; */
/* 	set hlth_array_long; */
/* 	if HEADACHE ^= sorethroat; */

/* ---------------------------------- */
/* Classnotes */
/* --------------------------------------- */

proc transpose data=hlth_array_long_headache out=hlth_wide_headache (drop = _NAME_) prefix=HEADACHE_;
 by IND_ID HH_ID;
 id WAVE;
 var HEADACHE;
run;

proc print data=hlth_wide_headache (obs = 8) noobs;
run;

data wv2004 wv2006 wv2009;
 set hlth_array_long_headache;
 select (WAVE);
  when ('2004') output wv2004;
  when ('2006') output wv2006;
  when ('2009') output wv2009;
 end;
run;

proc sort data=wv2004; by IND_ID HH_ID; run;
proc sort data=wv2006; by IND_ID HH_ID; run;
proc sort data=wv2009; by IND_ID HH_ID; run;

data hlth_wide_data;
 merge wv2004 (rename = (HEADACHE = HEADACHE_2004))
       wv2006 (rename = (HEADACHE = HEADACHE_2006))
       wv2009 (rename = (HEADACHE = HEADACHE_2009));
 by IND_ID HH_ID;
 drop WAVE;
run;

proc print data=hlth_wide_data (obs = 8) noobs;
run;



/* ---------------------------------- */
/* Exercise 5 */
/* --------------------------------------- */


proc transpose data=hlth_array_long out=hlth_wide_headache (drop = _NAME_) prefix=HEADACHE_;
 by IND_ID HH_ID HH_TYPE;
 id WAVE;
 var HEADACHE;
run;

proc transpose data=hlth_array_long out=hlth_wide_sorethroat (drop = _NAME_) prefix=SORETHROAT_;
 by IND_ID HH_ID HH_TYPE;
 id WAVE;
 var SORETHROAT;
run;

proc transpose data=hlth_array_long out=hlth_wide_stomachache (drop = _NAME_) prefix=STOMACHACHE_;
 by IND_ID HH_ID HH_TYPE;
 id WAVE;
 var STOMACHACHE;
run;

proc sort data=hlth_wide_headache;
	by IND_ID HH_ID HH_TYPE;
run;

proc sort data=hlth_wide_sorethroat;
	by IND_ID HH_ID HH_TYPE;
run;

proc sort data=hlth_wide_stomachache;
	by IND_ID HH_ID HH_TYPE;
run;

data hlth_wide;
	merge hlth_wide_headache hlth_wide_sorethroat hlth_wide_stomachache;
	by IND_ID HH_ID HH_TYPE;
run;

proc contents data=hlth_wide;
run;
proc print data=hlth_wide (obs = 8) noobs;
run;
/* to validify */
/* proc print data=lb.hlth_2009 (obs=8) noobs; */
/* run; */

/* ---------------------------------- */
/* Classnote */
/* --------------------------------------- */
data question;
 set lb.hlth_2009;
 MISS_COUNT_0609 = CMISS(HEADACHE_2006, HEADACHE_2009);
run;

proc freq data=question;
 tables MISS_COUNT_0609;
run;

data question;
 set question;
 if (HEADACHE_2004 ne .) & (MISS_COUNT_0609 ne 2) then WV04_AND_06OR09 = 1;
 else WV04_AND_06OR09 = 0;
run;

proc freq data=question;
 tables WV04_AND_06OR09;
run;

proc contents data=question;
run;
/* ---------------------------------- */
/* Exercise 6 */
/* --------------------------------------- */
/* Individuals with surveys completed at each of the following time points: */


data q;
	set lb.hlth_2009;
	/* 2004 and 2006 */
	miss_0406=CMISS(HEADACHE_2004,HEADACHE_2006);
	/* 2004, 2006, and 2009 */
	miss040609=CMISS(HEADACHE_2004,HEADACHE_2006, HEADACHE_2009);
	/* 2006 and 2009 (but not 2004) */
	miss_0609=CMISS(HEADACHE_2006,HEADACHE_2009);
	if (miss_0609=0) & (HEADACHE_2004 =.) then com0609not04 =1;
	else com0609not04 =0;
run;

proc freq data=q;
	table miss_0406 miss040609 com0609not04;
run;
/* ---------------- */
data question;
	set question;
	if (HEADACHE_2004 ne .) & (HEADACHE_2006 ne .) then wv04and06 =1;
	else wv04and06=0;
run;

proc freq data=question;
 tables wv04and06;
run;

proc print data=question (obs=50) noobs;
	var HEADACHE_2004 HEADACHE_2006 wv04and06;
run;

/* 2004, 2006, and 2009 */
data question;
	set question;
	if (HEADACHE_2004 ne .) & (HEADACHE_2006 ne .) & (HEADACHE_2009 ne .) then wv04and06and09 =1;
	else wv04and06and09=0;
run;

proc freq data=question;
 tables wv04and06and09;
run;

proc print data=question (obs=50) noobs;
	var HEADACHE_2004 HEADACHE_2006 HEADACHE_2009 wv04and06and09;
run;

/* 2006 and 2009 (but not 2004) */
data question;
	set question;
	if (HEADACHE_2004 = .) & (HEADACHE_2006 ne .) & (HEADACHE_2009 ne .) then wvnot04and06and09 =1;
	else wvnot04and06and09=0;
run;

proc freq data=question;
 tables wvnot04and06and09;
run;

proc print data=question (obs=50) noobs;
	var HEADACHE_2004 HEADACHE_2006 HEADACHE_2009 wvnot04and06and09;
run;
/* ---------------------------------- */
/* Exercise 7 need exercise 2 */
/* --------------------------------------- */
proc freq data=hlth_long (where=(headache ne .));
	tables wave;
run;


