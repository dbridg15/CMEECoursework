#CMEE MiniProject

**Author:** David Bridgwood _(dmb2417@ic.ac.uk)_

**Description:** Something...


##Dependancies

####python 3.6
- pandas
- numpy
- scipy
	- .constants 
	- .stats
- sys
- lmfit
	- .minimize
	- .Pamameters
	- .report_fit

####R
- ggplot2
- dplyr
- gridExtra
- grid

## How to run

To run the entire project with default parameters (see below) execute the 'run_project.sh' file from the Code directory.

	bash run_project.sh
	
This take approximately X minutes to run. Once complete the Results directory will populate (see below) and a pdf of the project report will be produced within the CMEEMiniProject directory.

To run the project with chosen parameters execute each script separately as below.

	python3 sort_data.py 
	
	python3 NLLS.py
	
	Rscript plots.R
	
	Rscript compare.R

##File Structure

CMEEMiniProject/
│ 
├──code
│      ├── compare.R
│	├── modelfuncs.py
│      ├── NLLS.py
│      ├── plotfuncs.R
│      ├── plots.R
│      └── sort\_data.py
│
├── Data
│      ├── GrowthRespPhotoData.csv
│      ├── GrowthRespPhotoData\_new.csv
│      ├── ThermResp.csv
│      ├── ThermRespData.csv
│      └── TraitInfo.csv
│
├── Results
│      ├── arrhenius\_model.csv
│      ├── cubic\_model.csv
│      ├── full\_scholfield\_model.csv
│      ├── noh\_scholfield\_model.csv
│      ├── nol\_scholfield\_model.csv
│      ├── plots.pdf
│      └── sorted\_data.cs 
│
└── Sandbox