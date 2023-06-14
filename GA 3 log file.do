clear all 
capture log close 

use "/Users/leah/Desktop/EIPR/mentorStata9copy.dta", clear

log using "/Users/leah/Desktop/EIPR/GA 3 log file.log", replace

ssc install outreg2


 * question 1 describe the sample 
 
summarize 
centile 

*question 2 - describe the sample and show that the randomization worked 

*look at breakdown and n of program participants 
tab1 program
	 *label the table 
	label variable program "selected into program?"
	label define yesno 0 "no" 1 "yes"	
	label values program yesno
	codebook program
	tab1 program
	*outreg2 using 5.doc
	
		* this is who was selected into the program vs not see dummy of who was in the program vs not, find that group not in program (0) bigger then group in program (1) 55% not in program and 45% in program of those who applied.
*look at frequency of variables, make sure in percentage 

bysort program: sum pastsc pastab black hispanic whiteoth kennedy classize pastment

*outreg2 using 11.doc
		*shows the split is fairly even between groups 
			
	
* ccan onduct chi^2 test, test by association tells dif between two groups significant 

oneway program score
	* this is comparison of association between program and score


* question 3 - pre and post means for scores and absent - EXCEL GRAPHS

*find mean values of pre and post absent and score
	
mean pastsc if program==0
	*=89.5
mean pastsc if program==1
	*=90.2

mean score if program==0
	*=75.7
mean score if program==1
	*=92.0
	
mean pastab if program==0
	*=18.5
mean pastab if program==1
	*=14.9
mean absent if program==0
	*=17.8
mean absent if program==1
	*=6.6


 *numbers put into excel table and make graphs 
 
		
*question 4 - estimate the program impacts 
	*formula: score=trt

reg score program
outreg2 
	* findings; the impact of the program on scores is 16, highly statistically significant at 1% confidence level (this what expect)
		**can also do with covarites: reg score program pastsc pastab black hispanic whiteoth kennedy classize pastment
		

reg absent program
 *outreg2
	* findings; the impact of program on absents is -11, highly statistically significant at 1% confidence interval. Meaning when accounting for program, absents decline (this what expect)
	** can also do with covarietes:reg absent program pastsc pastab black hispanic whiteoth kennedy classize pastment 
 
*put findings into table and describe them
	
* question 5 - compare impacts of subgroups, outcome is score

	*Set A:  Students who were previously mentored (pastment =1), versus students who were not previously mentored (pastment =0)
	
	*(For Set A, was the program impact different for students who were and were not previously mentored;  for Set B, same question for students with baseline low and high absences.)


	*make sub groups previously mentored vs not previously mentored 
	
	reg score program if pastment ==0
	outreg2 using "m.doc"
			* estimating for if not past mentoring and in the program coef = 17.7, highly statistically significant at the 1% confidence interval, means for kids who were not previously mentored and then in program, scores went up significantly.

	reg score program if pastment ==1 
	outreg2 using "y.doc"
		* estimating for if did have past mentoring and in the program coef = 4.3 highly statistically significant. Shows when had previous mentoring, not as much boost in score when also in this new program.

	
	
		*takeaway: when never past mentored and in the program, the magnitude of the effect of the program on scores is much larger (17.3) compared to the coeficient on program if have been mentored before (4.3), both cases, these coeficents are highly statistically significant at 1% level.
	
	
	*Set B:  Students with high versus low absences at baseline (pastab, where "low" is lower than the mean, and "high" is higher than the mean.	
	
	*make sub groups above and below average absent pre-program, and how this subgroup effected score
	
	mean pastab 
	*mean pre-program absents round to = 17 
		
	gen lowmeanpastab = 1 if (pastab <17)
	replace lowmeanpastab  = 0 if (pastab <17)
		*means if lowmeanpastab = 0, then less then average absents
	tab1 lowmeanpastab
		
	*check done correctly
	tab2 pastab lowmeanpastab
		*see assiged to 0 when absents are below 17 and assigned to 1 when values above 17
		
	sort lowmeanpastab
	by lowmeanpastab: summarize pastab
		* we see here because doing >,< miss 5 observations that =17

	gen highmeanpastab = 0 if (pastab <17)
	replace highmeanpastab  = 1 if (pastab >17)
	tab1 highmeanpastab
		* tells how many pre treatment absenses were above the mean = 118 or 50%
	
	*check done correctly: 
	sort highmeanpastab
	by highmeanpastab: summarize pastab
	

reg score program if lowmeanpastab == 0
	*program coef is 11.2, highly statistically significant at 1% level
	outreg2 using "1.doc"
reg score program if highmeanpastab== 1
	* program coef 17.7 highly statistically significant at 1% level
	outreg2 using "2.doc"
	
*Then, for each of the two sets individually, create an interaction variable to test whether the program impact was significantly different within the two subgroups in the set.(For Set A, was the program impact different for students who were and were not previously mentored;  for Set B, same question for students with baseline low and high absences.)

* Formula: Score = trt subgroup trt*subgroup

*Set A: 

	gen yespastmentprogram = (pastment*program)
	reg score program pastment yespastmentprogram
	outreg2 using "3.doc"
		*interaction coefficent = -13, 
		*for those with past mentoring vs those not past mentoring there is different impact when program is applied
			*- Those with pastmentoring in program had less of an affect on score than those without past mentoring in the program. 
			
*Set B:
	
gen highmeanpastabprogram = (highmeanpastab*program)	
reg score program highmeanpastab highmeanpastabprogram 
	outreg2 using "4.doc"
	* 6.6 = interaction term but not statistically significant
		*remember interaction term tells Difference in the impact of TRT in the subgroups SUBGRP = 0 and SUBGRP = 1
		* no difference in how the treatment affected those with high vs low meanpastab
