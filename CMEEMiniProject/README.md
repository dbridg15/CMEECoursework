#CMEE MiniProject

**Author:** David Bridgwood _(dmb2417@ic.ac.uk)_

**Description:** words...


##Dependancies

####python 3.6
- pandas 0.20.3 - data manipulation
- numpy 1.13.3 - numerical operations
- scipy 0.19.1 - scientific operations
- sys - interaction with operating system
- lmfit 0.9.7 - model fitting with NLLS
- datetime - timing scripts

####R 3.4.2
- ggplot2 2.2.1 - for plotting
- dplyr 0.7.4 - datawrangling
- tidyr 0.7.1 - datawrangling
- gridExtra 2.3 - for producing tables
- grid 3.4.2 - for arranging plots in grid on page

## How to run
To run the entire project with default parameters (see below) execute the 'run_project.sh' file from the Code directory.

	bash run_MiniProject.sh
	
This take approximately 12 minutes to run (depending on computer speed). Once complete the Results directory will populate (see below) and a pdf of the project report will be produced within the CMEEMiniProject directory.

To run the project with chosen parameters execute each script separately.

- 01_sort_data.py takes the path to a csv file.
- 02_NLLS.py takes min_tries and max_tries (defaults are 3 and 5 respectivly)
- 03_plots.R either takes a number of random plots to produce or 'All' to print curves for all groups.	

##File Structure

CMEEMiniProject/
├── Code
│   ├── 01_sort_data.py
│   ├── 02_NLLS.py
│   ├── 03_plots.R
│   ├── 04_figures.R
│   ├── modelfuncs.py
│   ├── plotfuncs.R
│   ├── run_MiniProject.sh
│   ├── writeup.bib
│   └── writeup.tex
│
├── Data
│   ├── GrowthRespPhotoData.csv
│   ├── GrowthRespPhotoData_new.csv ------- Data used by default
│   ├── ThermResp.csv
│   ├── ThermRespData.csv
│   └── TraitInfo.csv
│
├── Results ---------------------------------------------- Populated when project is run
│   ├── arrhenius_model.csv
│   ├── cubic_model.csv
│   ├── figure2.pdf
│   ├── figure3.pdf
│   ├── figure4.pdf
│   ├── full_scholfield_model.csv
│   ├── noh_scholfield_model.csv
│   ├── nol_scholfield_model.csv
│   ├── plots.pdf
│   ├── sorted_data.csv
│   └── writeup.pdf
│
└── Sandbox
