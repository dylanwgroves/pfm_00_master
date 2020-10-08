/*______________________________________________________________________________

	Project: Pangani FM
	File: Merges Audio Screening Datasets
	Date: 8/22/2019
	Author: Dylan Groves, dgroves@poverty-action.org
	Overview: This merges and appends are relevant datasets
_______________________________________________________________________________*/


/* Introduction _______________________________________________________________*/

	clear all

/* Temfiles __________________________________________________________________*/
	
	tempfile temp_allvills
	tempfile temp_base
	tempfile temp_mid
	tempfile temp_rd_dist
	tempfile temp_rd_rand
	tempfile temp_rand
	
	tempfile temp_rd_ri
	tempfile temp_ri

/* Import Data ________________________________________________________________*/

/* NOTES: 
	- 	we might want to consider adding a prefix to each survey so we know where its
		coming from																*/


	/* Audio Screening */
	
		/* All villages */
		use "${data}/01_raw_data/pfm_allvills_clean.dta"
		sort village_id
		save `temp_allvills'
		
		/* Baseline */
		use "${data}/02_mid_data/pfm_as_baseline_clean.dta", clear
		rename * b_*
		rename b_village_id village_id
		rename b_resp_id resp_id
		sort village_id resp_id
		save `temp_base'
		
		/* Midline */
		use "${data}\01_raw_data\pfm_as_midline_clean.dta", clear
		sort resp_id 
		save `temp_mid', replace
		
		/* Village Randomization */
		use "${data}/02_mid_data/pfm_randomized_as.dta", clear
		save `temp_rand'
		
		/* Village RI */
		use "${data}/02_mid_data/pfm_ri_as.dta", clear
		save `temp_ri'
		
	/* Radio */
	
		/* Radio Distribution */
		use "${data}/02_mid_data/pfm_clean_rd_distribution_as.dta", clear
		sort resp_id 
		save `temp_rd_dist'
		
		/* Radio Randomization */
		use "${data}/02_mid_data/pfm_rd_randomization_as.dta", clear
		save `temp_rd_rand'
		
		/* Radio RI */
		use "${data}/02_mid_data/pfm_rd_ri_as.dta", clear
		save `temp_rd_ri'
		
		
	/* Merge */
	
		use `temp_allvills'
		merge 1:n village_id using `temp_base', force gen(merge_base)
			drop if merge_base == 1
		merge 1:1 resp_id using `temp_mid', force gen(merge_base_mid)
		merge 1:1 resp_id using `temp_rd_dist', force gen(merge_bas_mid_rd)
		merge 1:1 resp_id using `temp_rd_rand', force gen(merge_bas_mid_rd_rdrand)
		merge 1:1 resp_id using `temp_rd_ri', force gen(merge_rdri)
		merge n:1 village_id using `temp_rand', force gen(merge_bas_mid_rd_rdrand_rand)
	
		/* RI */
		merge 1:1 resp_id using `temp_rd_ri', force gen(merge_ri_rd)
		merge n:1 village_id using `temp_ri', force gen(merge_ri_as)
		
/* Save ______________________________________________________________________*/

	rename * as_*	
	rename as_id_* id_*
	save "${data}/03_final_data/pfm_as_merged.dta", replace
	
	


