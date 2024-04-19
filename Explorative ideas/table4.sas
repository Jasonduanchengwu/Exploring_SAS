/* Table 4. Employment-related concerns about the future in 2007
 and 2011 for the subsample with assessments completed at both
 time points */

/* 1.	Lack of ability to get training or degree */
/* 2.	Lack of money to complete education or get started in my chosen career field */
/* 3.	I am considered "overqualified" */
/* 4.	Lack of openings in my field */
/* 5.	Relocation is difficult or impossible */
/* 6.	Illness, accident, or disability */
/* 7.	Caring for a sick parent or relative */
/* 8.	Transportation problems - difficulty in getting to or from work */

libname mqp "~/my_non_shared_file_links/Data";
/* 2007 */
/* D3CNRA17 Num 8 D3INTA1F. W17 D3 Concerned about interference with work or career plans in the future by lack of ability */
/* D3CNRB17 Num 8 C2A17FFF. W17 D3 Concerned about interference with work or career plans in the future by lack of money */
/* D3CNRC17 Num 8 C2A17FFF. W17 D3 Concerned about interference with work or career plans in the future by overqualification */
/* D3CNRE17 Num 8 C2A17FFF. W17 D3 Concerned about interference with work or career plans in the future by lack of openings */
/* D3CNRF17 Num 8 C2A17FFF. W17 D3 Concerned about interference with work or career plans in the future by difficulty with relocation */
/* D3CNRD17 Num 8 D3INTD1F. W17 D3 Concerned about interference with work or career plans in the future by illness */
/* D3CNRI17 Num 8 D3CNRI1F. W17 D3 Concerned about interference with work or career plans in the future caring for a sick parent */
/* D3CNRJ17 Num 8 C2A17FFF. W17 D3 Concerned about interference with work or career plans in the future by transportation problems */

data future07;
	set mqp.my07;
	keep famid D3CNRA17 D3CNRB17 D3CNRC17
	D3CNRe17 D3CNRf17 D3CNRd17 D3CNRi17 D3CNRj17;
/* 	if D3CNRB17 ne .; */
run;

proc contents data=future07;run;
proc print data=future07 noobs;run;

/* 2011 */
/* D4CNRA19 Num 8 D4INTA1F. W19 D4 Lack of ability to get training or degree (Concerned about the future) */
/* D4CNRB19 Num 8 D4INTA1F. W19 D4 Lack of money to complete education or get started in my chosen career field (Concerned about */
/* D4CNRD19 Num 8 D4INTA1F. W19 D4 I am considered "overqualified" (Concerned about the future) */
/* D4CNRE19 Num 8 D4INTA1F. W19 D4 Lack of openings in my field (Concerned about the future) */
/* D4CNRF19 Num 8 D4INTA1F. W19 D4 Relocation is difficult or impossible (Concerned about the future) */
/* D4CNRI19 Num 8 D4INTA1F. W19 D4 Illness, accident, or disability (Concerned about the future) */
/* D4CNRJ19 Num 8 D4INTA1F. W19 D4 Caring for a sick parent or relative (Concerned about the future) */
/* D4CNRK19 Num 8 D4INTA1F. W19 D4 Transportation problems - difficulty in getting to or from work (Concerned about the future) */

/* only include completed and var we concerned with */
proc format;
	value yesno 0="no"
			1="yes"
			.="missing";
	value circled 1="yes"
			.="missing";
run;
data future11;
	set mqp.my11;
	keep famid D4CNRA19 D4CNRB19 D4CNRD19
	D4CNRE19 D4CNRF19 D4CNRI19 D4CNRJ19 D4CNRK19;
run;

proc contents data=future11; run;
proc print data=future11 noobs; run;

proc sort data=future07; by famid; run;
proc sort data=future11; by famid; run;

data future0711;
	merge future07(in=in07) future11(in=in11);
	by famid;
	if in07 and in11;
/* 	format D4CNRK199 yesno.; */
run;
/* proc contents data=future0711; run; */
/* proc print data=future0711 noobs; var D3CNRA17;run; */

/* D3CNRA17 D3CNRB17 D3CNRC17 D3CNRe17 D3CNRf17 D3CNRd17 D3CNRi17 D3CNRj17 */
/* D4CNRA19 D4CNRB19 D4CNRD19 D4CNRE19 D4CNRF19 D4CNRI19 D4CNRJ19 D4CNRK19 */
proc tabulate data=future0711 missing;
	class D3CNRj17;
	table D3CNRj17 *(n pctn="%") all;
run;