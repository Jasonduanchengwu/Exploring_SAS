libname data "~/my_non_shared_file_links/Data/Final_project";
data fp; set data.mfp; run;

/* formats */
proc format;
	value rqfmt 1="Excellent"
				0="Not Excellent"
				.="Missing";
	value ynfmt 1="Yes"
				0="No";
	value gfmt 1="Male"
				2="Female";
run;
/* use class for discrete/categorical variables */
/* use var for continuous/numeric variables */

/* step 1 */ 
%macro ascv(varname, label, format,datname);
	*created new var for if age <=5 apart and non of the conprising vars are .;
	data temp;
		set &datname;
		if ppage ne . & Q9 ne .;
		Q100_1=(abs(ppage-Q9)<=5);
	run;
	*helper macro help us to get data regarding each row;
	*prefix varn passed in to make the marco flexible for all use;
	%macro helper(prefix,varn, varname, dat); 
		*retaining rows that are only True (1);
		ods output ChiSq=CHI&prefix&varn (where=(statistic="Chi-Square")) 
		CrossTabFreqs=CTF&prefix&varn (where=(&prefix&varn=1 & RowPercent ne .));
		ods trace on;
		ods select summary (nowarn);
		proc freq data=&dat;
			*getting row percent, N and p-value;
			table &prefix&varn*&varname/nopercent nocol chisq;
			run;
		ods trace off;
		proc sort data=CTF&prefix&varn; by table; run;
		proc sort data=CHI&prefix&varn; by table;run;
		data CTFCHI&prefix&varn;
			merge CTF&prefix&varn CHI&prefix&varn;
			by table;
			length varlabel $30.;
			length grplabel $30.;
			varlabel = "&prefix&varn";
			grplabel = "&prefix";
			keep grplabel varlabel &varname frequency rowpercent prob;
		run;
	%mend;
	*since we had a flexible macro, we can get all rows from 3 questions in one loop;
	%do i= 1 %to 9;
		*this runs the DS that removed Q9 =. or ppage =.;
		%if &i=1 %then %helper(Q100_,&i, &varname, temp);
		%if &i<=7 %then %helper(Q33_,&i, &varname, &datname);
		%helper(Q31_,&i, &varname, &datname);
	%end;
	run;
	*set all created dat into one overall dat;
	data ft;
		set CTFCHIQ31_1-CTFCHIQ31_9 CTFCHIQ33_1-CTFCHIQ33_7 CTFCHIQ100_1;
		select (varlabel);
			when("Q31_1") varlabel="1. Work";
			when("Q31_2") varlabel="2. School";
			when("Q31_3") varlabel="3. Church";
			when("Q31_4") varlabel="4. Dating Service";
			when("Q31_5") varlabel="5. Vacation";
			when("Q31_6") varlabel="6. Bar";
			when("Q31_7") varlabel="7. Social Organization";
			when("Q31_8") varlabel="8. Private Party";
			when("Q31_9") varlabel="9. Other";
			
			when("Q33_1") varlabel="1. Family";
			when("Q33_2") varlabel="2. Mutual Friends";
			when("Q33_3") varlabel="3. Co-workers";
			when("Q33_4") varlabel="4. Classmates";
			when("Q33_5") varlabel="5. Neighbors";
			when("Q33_6") varlabel="6. Self or Partner";
			when("Q33_7") varlabel="7. Other";
			
			when("Q100_1") varlabel="Age Difference <=5";
			otherwise;
		end;
		select (grplabel);
			when("Q31_") grplabel="1. Where Met Partner:";
			when("Q33_") grplabel="2. Who Introduced Partner:";
			when("Q100_") grplabel="3. Similar Age:";
			otherwise;
		end;
	run;
	proc tabulate data=ft;
		class &varname varlabel grplabel;
		var frequency rowpercent prob;
		table grplabel=""*varlabel="", &varname=&label*(frequency="N" rowpercent="%")*sum="" 
		ALL="Total"*prob="p-value"*mean=""*f=10.4/box="List of Questions";
		
		format &varname &format;
	run;
	*this can release the memory of created temp DS;
	proc datasets library=work nolist;
		delete CTF: Chi: Temp; *: is same as * to represent replaceable naming for var;
	quit;
%mend;

%ascv(PARENTAL_APPROVAL,"Parental Approval",ynfmt.,fp);
%ascv(PPGENDER,"Gender",gfmt.,fp);
%ascv(MARRIED,"Married or not",ynfmt.,fp);

/* step 2 */
data rq;
	set fp;
	select (relationship_quality);
		when (5) isexc=1;
		when (.) isexc=.;
		otherwise isexc=0;
	end;
run;

%ascv(isexc,"Excellent or not",ynfmt.,rq);