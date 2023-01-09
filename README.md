# EggSizeBiosorterProtocol

This folder contains all the scripts needed to reproduce the results in Barghi N and Ramirez-Lanzas C. (2022). High throughput size measurements of Drosophila eggs using large particle flow cytometry. bioRxiv: https://doi.org/10.1101/2022.09.13.507758

## 1. Reference beads
This notebook is a step by step guide that describes how to convert time of flight (TOF) to size (μm) using the reference beads. The computed slope and intercept of these reference beads are used to convert TOF of all subsequent Biosorter® runs to size. 

The required data is the Biosorter® output that contains information about TOF and Extinction (summary file). Note that for this analysis the original Biosorter data is copied to an Excel file. Data can be accessed here: ./data/Drosophila_eggs_OD1_5_1xPBS_26-03-2021.zip. All the file and folder names are the same as used in the script.

In other scripts the conversion of TOF to size (μm) using reference beads is done through function **compute_append_size**.

```
ref_bead_size.ipynb
```
## 2. In silico filtering of the Biosorter® data

This notebook is a step by step guide that describes the in silico filtering steps on Biosorter® data. The 1st filtering step is based on the size. The filtered objects at this step are mostly egg debris. The second filtering step involved removing the misaligned eggs based on ellipticalness index (EI) and the ratio of the maximum optical density of an object to its time of flight (W/L) values estimated from the optical density data. The last filtering step is to remove the objects in the first peak of distribution after removal of the misaligned eggs. 

For each sample two datasets are required: The first file is the Biosorter® output that contains information about TOF, Extinction and fluorescence absorbance (summary file). The second file contains the optical density data. Data can be accessed here: ./data/Drosophila_eggs_OD1_5_1xPBS_21-12-2021_1.zip and ./data/Drosophila_eggs_OD1_5_1xPBS_21-12-2021_2.zip. All the file and folder names are the same as used in the script. This script generated **Fig. 1C**.

In other scripts the filtering of Biosorter® data is done through function **filter_size_EI_WL_size**.

```
filter_size_optical_density.ipynb
```

## 3. Comparison of egg size distribution laid by females of different age 

We ran few samples on two consecutive days meaning the eggs were laid by females of different age (4 and 5 days old). In this notebook we filter all datasets and compare the size distribution of eggs laid by females of different age. The estimated size distributions are comparable and datasets can be pooled.

For each sample two datasets are required: The first file is the Biosorter® output that contains information about TOF, Extinction and fluorescence absorbance (summary file). The second file contains the optical density data. Data can be accessed here: ./data/Drosophila_eggs_OD1_5_1xPBS_21-12-2021_1.zip, ./data/Drosophila_eggs_OD1_5_1xPBS_21-12-2021_2.zip and ./data/Drosophila_eggs_OD1_5_1xPBS_22-12-2021.zip. All the file and folder names are the same as used in the script.

In other scripts the filtering of two datasets for each sample is done through function **filter_size_EI_WL_size_pool**.

```
duplicate_runs.ipynb
```
## 4. Egg size distribution using methyl cellulose (MC) as sheath solution

We used a more viscous sheath solution, e.g. 1x PBS with 4% methyl cellulose, to reduce the flow rate and facilitate the alignment of objects along their long axis when passing through the laser path. In this notebook, we filter data with different concentrations of MC and observe that as the concentration of MC increases the sheath buffer becomes more viscous which will reduce the flow rate. The slower flow rate facilitates the alignment of objects along the long axis while passing through the laser path. However, the increased viscosity of the sheath buffer dramatically reduces the speed of analysis. 

For each sample two datasets are required: The first file is the Biosorter® output that contains information about TOF, Extinction and fluorescence absorbance (summary file). The second file contains the optical density data. Data can be accessed here: ./data/Drosophila_eggs_OD1_5_1xPBS_20-06-2022.zip. All the file and folder names are the same as used in the script. This script generated **Fig. S3**.

```
methyl_cellulose.ipynb
```
## 5. Manual egg size measurement

To validate the estimated egg size using Biosorter®, we sorted eggs from 6 gates corresponding to 400-600 µm in three 96-well plates and manually measured the eggs. We observed a high correlation between the manual and biosorter® size measurements.

For each sample two datasets are required: The first file is the Biosorter® output that contains information about TOF, Extinction and fluorescence absorbance (summary file). The second file contains the optical density data. 

biosorter® data and the manual measurements can be accessed here: ./data/biosorter_plus_manual_measurement_3plates.csv
The columns in this dataset are 'Row', 'Column', 'plate', 'TOF', 'Size', ''Length'.
'Row' and 'Column' correspond to the row and column on the 96-well plate. 'plate' refers to the number of 96-well plate. 'TOF' is the time-of-flight measurement from large particle flow cytometry. 'Size' is the estimated size using 'TOF'. You can refer to section Reference beads for the details of the conversion. 'Length' is the manually measured egg length using ImageJ. The units of 'Size' and 'Length' are in μm. This script generated **Fig. 2A**.

```
manual_measurement.ipynb
```

## 6. Sort recovery

We evaluated the efficiency of sorting as the sort recovery which is the percentage of objects that were sorted and dispensed as a fraction of all the objects fulfilling sorting criteria, i.e. size. We also evaluated the speed of sorting. The required data is the Biosorter® output that contains information about TOF, Extinction and sort status (summary file). This script generated **Fig. 3B-C**.

A total of 28 datasets have been used. Data can be accessed here:
./data/Drosophila eggs_OD1_5_1xPBS_07-11-2022.zip
./data/Drosophila eggs_OD1_5_1xPBS_15-09-2022.zip
./data/Drosophila eggs_OD1_5_1xPBS_25-11-2022.zip
./data/Drosophila_eggs_OD1_5_1xPBS_25-07-2022.zip

All the file and folder names are the same as used in the script.

```
sort_recovery_speed.ipynb
```

## 7. Egg size distribution among *Drosophila* strains

We have measured the egg size distributions in *D. simulans* (12 strains), *D. melanogaster* (1 strain), *D. erecta* (1 strain), *D. santomea* (1 strain) and *D. mauritiana* (1 strain). in section **4. The size distribution of Drosophila inbred lines** on the notebook, each data set is filtered using the procedure described in *filter_size_optical_density.ipynb*. 

In section **4.2 Filtering the egg size datasets** of the notebook we performed size filtering steps (the 1st and last steps deccribed in **2. In silico filtering of the Biosorter® data** above). In section **4.3 Computation of summary statistics for egg size distribution after filtering** we computed summary statistics for each filtered dataset including the number and average size of the filtered small objects, the number of eggs and mean, and median of their distribution. We then compute the speed of measurement for all the datasets in section **5 Compute the measurement speed** of the notebook. 

For each sample two datasets are required: The first file is the Biosorter® output that contains information about TOF, Extinction and fluorescence absorbance (summary file). The second file contains the optical density data. Biosorter® data can be accessed here: ./data/Drosophila_eggs_OD1_5_1xPBS_21-12-2021_1.zip, ./data/Drosophila_eggs_OD1_5_1xPBS_21-12-2021_2.zip and ./data/Drosophila_eggs_OD1_5_1xPBS_22-12-2021.zip. All the file and folder names are the same as used in the script. This script generated **Table S1, Table S2, and Fig. 3A**.

```
Eggsize_speed.ipynb
```

## 8. Egg-to-adult viability assay

We performed egg-to-adult viability assay to determine the effect of submersion in PBS and passing through the flow cell in the Biosorter® on the development of eggs to adults. Data can be accessed here: ./Data/PBS_viability_Nov242022_mod.txt. There are 9 columns in the file: vial_num, replicate, flies_1stcount, flies_2ndcount, flies_3rdcount, flies_4thcount, total_fly, treatment, egg_num. 'vial_num' refers to the id of each vial and 'replicate' refers to the replicate number for each treatment. 'flies_1stcount', 'flies_2ndcount', 'flies_3rdcount' and 'flies_4thcount' correspond to the number of flies counted is 3 consecutive sessions. 'total_fly' is the total number of eclosed flies which is the sum of 'flies_1stcount', 'flies_2ndcount', 'flies_3rdcount' and 'flies_4thcount'. 'treatment' is the duration of immersion in PBS and sort status (no PBS: no submersion in PBS, 0-hour: only washed in PBS, 4-hour: 4 hours submersion in PBS, and sorted 4-hour: 4 hours submersion in PBS and sorted on Biosorter®). 'egg_num' is the number of eggs in each vial. This script generated **Fig. 4**.

```
PBS_assay_hatch_github.R
```

## 9. Variation of egg length and width in *Drosophila*

We measured the length and width of 160 eggs manually using ImageJ. Data can be accessed here: ./Data/manual_measurement_length_width_12042022.xlsx
This script generated **Fig. S1**.

```
length_width_distribution.ipynb
```

## 10. Egg size distribution after submersion in PBS

We assessed the effect of submersion in PBS on the egg size by measuring the egg size before and after submersion in PBS. The size of a total of 46 eggs were manually measured using ImageJ. The eggs were then submerged for 2.5 hours and their sizes were manually measured. This script generated **Fig. 2B**.

Data can be accessed here: 
./Data/merged_egg_size_beforeafterPBS_17112022.xlsx
./Data/merged_egg_size_beforePBS_29112022.csv
./Data/merged_egg_size_afterPBS_29112022.csv

```
PBS_submersion.ipynb
```

## 11. Biosorter® output files

For the description of the data in summary file of Biosorter®, please refer to pages 77-78 in Biosorter® manual  that can be accessed here: https://med.stanford.edu/content/dam/sm/htbc/documents/eq/BioSorter-manual.pdf

We couldn't find a proper documentation of optical density files generated by Biosorter®. In brief, the optical density outputs contain measurements along each object’s
time of flight (TOF) for each of the four optical parameters: extinction and three fluorescence channels. Therefore, each object has 4 optical density reading (each stored as a column in optical density file labeled as Id, Id.1, Id.2 and Id.3). Id in the optical density file and summary file are identical and are used to match the optical density of each object. We only use the first column which corresponds to Extinction. 

---------------------------------------------

The scripts were written in Python 3 and R version 3.6.3. 

For any questions please contact me at barghi.neda@gmail.com. 
