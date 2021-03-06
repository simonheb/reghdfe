noi cscript "reghdfe: Stata 15 st_data() bug reported by Simon Heß" adofile reghdfe

* Dataset

	*set obs 10
	*gen byte y = int(runiform() * 50)
	*gen byte x = int(runiform() * 50)
	*gen byte year = ceil(_n/2)
	*list

	* Example generated by -dataex-. To install: ssc install dataex
	clear
	input byte(y x year)
	33  5 1
	17 20 1
	36  0 2
	 9 33 2
	15 17 3
	 6  3 3
	32  6 4
	13 11 4
	44 16 5
	28 20 5
	end


	local excluded ///
		macros: cmdline title marginsok cmd predict model estat_cmd marginsprop ///
		scalar: rank


* [TEST] 
	
	local lhs y
	local rhs i.year#c.x

	* 1. Run benchmark
	reg `lhs' `rhs'
	storedresults save benchmark e()

	* 2. Run reghdfe
	reghdfe `lhs' `rhs', noa
	storedresults compare benchmark e(), tol(1e-9) exclude(`excluded')

	* 2. Run reghdfe with pool(1)
	reghdfe `lhs' `rhs', noa pool(1) v(1)
	storedresults compare benchmark e(), tol(1e-9) exclude(`excluded')

	* 3. Run reghdfe with pool(5)
	reghdfe `lhs' `rhs', noa pool(5) v(1)
	storedresults compare benchmark e(), tol(1e-9) exclude(`excluded')

	* Done!
	storedresults drop benchmark


* [TEST] Additional test based on nlsw88.dta
* https://github.com/sergiocorreia/reghdfe/issues/43

	* Data
	clear
	input byte(x id) double y
	44 1 1.8115942
	34 1  2.508361
	35 2  5.016723
	43 2  6.505631
	44 3  2.801002
	35 3  2.801932
	38 4 1.0049518
	42 4   1.80602
	35 5  3.526568
	37 5  3.647342
	end

	local lhs y
	local rhs i.id#c.x

	* 1. Run benchmark
	reg `lhs' `rhs'
	storedresults save benchmark e()

	* 2. Run reghdfe
	reghdfe `lhs' `rhs', noa
	storedresults compare benchmark e(), tol(1e-9) exclude(`excluded')

	* 2. Run reghdfe with pool(1)
	reghdfe `lhs' `rhs', noa pool(1) v(1)
	storedresults compare benchmark e(), tol(1e-9) exclude(`excluded')

	* 3. Run reghdfe with pool(5)
	reghdfe `lhs' `rhs', noa pool(5) v(1)
	storedresults compare benchmark e(), tol(1e-9) exclude(`excluded')

	* Done!
	storedresults drop benchmark

exit
