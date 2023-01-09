# EggSizeBiosorterProtocol

This folder contains all the scripts needed to reproduce the results in Barghi N and Ramirez-Lanzas C. (2022). High throughput size measurements of Drosophila eggs using large particle flow cytometry. bioRxiv.

## 1. Reference beads
This notebook is a step by step guide that describes how to convert time of flight (TOF) to size (μm) using the reference beads. The computed slope and intercept of these reference beads are used to convert TOF of all subsequent Biosorter® runs to size. 

The required data is the Biosorter® output that contains information about TOF and Extinction (summary file). Note that for this analysis the original Biosorter data is copied to an Excel file. Data can be accessed here: ./data/Drosophila_eggs_OD1_5_1xPBS_26-03-2021.zip. All the file and folder names are the same as used in the script.

In other scripts the conversion of TOF to size (μm) using reference beads is done through function **compute_append_size**.

```
ref_bead_size.ipynb
```
## 2. In silico filtering of the Biosorter® data

This notebook is a step by step guide that describes the in silico filtering steps on Biosorter® data. The 1st filtering step is based on the size. The filtered objects at this step are mostly egg debris. The second filtering step involved removing the misaligned eggs based on ellipticalness index (EI) and the ratio of the maximum optical density of an object to its time of flight (W/L) values estimated from the optical density data. The last filtering step is to remove the objects in the first peak of distribution after removal of the misaligned eggs. 

For each sample two datasets are required: The first file is the Biosorter® output that contains information about TOF, Extinction and fluorescence absorbance (summary file). The second file contains the optical density data. Data can be accessed here: ./data/Drosophila_eggs_OD1_5_1xPBS_21-12-2021_1.zip and ./data/Drosophila_eggs_OD1_5_1xPBS_21-12-2021_2.zip. All the file and folder names are the same as used in the script.

In other scripts the filtering of Biosorter® data is done through function **filter_size_EI_WL_size**.

```
filter_size_optical_density.ipynb
```

## 3. Comparison of egg size distribution laid by females of different age 

We ran few samples on two consecutive days meaning the eggs were laid by females of different age. In this notebook we filter all datasets and compare the size distribution of eggs laid by females of different age. The estimated size distributions are comparable and datasets can be pooled.

For each sample two datasets are required: The first file is the Biosorter® output that contains information about TOF, Extinction and fluorescence absorbance (summary file). The second file contains the optical density data. Data can be accessed here: ./data/Drosophila_eggs_OD1_5_1xPBS_21-12-2021_1.zip, ./data/Drosophila_eggs_OD1_5_1xPBS_21-12-2021_2.zip and ./data/Drosophila_eggs_OD1_5_1xPBS_22-12-2021.zip. All the file and folder names are the same as used in the script.

In other scripts the filtering of two datasets for each sample is done through function **filter_size_EI_WL_size_pool**.

```
duplicate_runs.ipynb
```
## 4. Egg size distribution using methyl cellulose (MC) as sheath solution

We used a more viscous sheath solution, e.g. 1x PBS with 4% methyl cellulose, to reduce the flow rate and facilitate the alignment of objects along their long axis when passing through the laser path. In this notebook, we filter data with different concentrations of MC and observe that as the concentration of MC increases the sheath buffer becomes more viscous which will reduce the flow rate. The slower flow rate facilitates the alignment of objects along the long axis while passing through the laser path. However, the increased viscosity of the sheath buffer dramatically reduces the speed of analysis. 

For each sample two datasets are required: The first file is the Biosorter® output that contains information about TOF, Extinction and fluorescence absorbance (summary file). The second file contains the optical density data. Data can be accessed here: ./data/Drosophila_eggs_OD1_5_1xPBS_20-06-2022.zip. All the file and folder names are the same as used in the script.

```
methyl_cellulose.ipynb
```
## 5. Manual egg size measurement

To validate the estimated egg size using Biosorter®, we sorted eggs from a gate corresponding to 400-500 µm in a 96-well plate and manually measured the eggs. We observed a high correlation between the manual and biosorter® size measurements.

For each sample two datasets are required: The first file is the Biosorter® output that contains information about TOF, Extinction and fluorescence absorbance (summary file). The second file contains the optical density data. Biosorter® data can be accessed here: ./data/Drosophila_eggs_OD1_5_1xPBS_20-06-2022.zip and ./data/Drosophila_eggs_OD1_5_1xPBS_12-04-2022.zip and the manual measurements can be accessed here: ./data/manual_egg_size_12042022.xlsx and ./data/manual_egg_size_20062022.xlsx. All the file and folder names are the same as used in the script.

```
manual_measurement.ipynb
```

## 6. Sort recovery

We evaluated the efficiency of sorting as the sort recovery which is the percentage of objects that were sorted and dispensed as a fraction of all the objects fulfilling sorting criteria, i.e. size. 

The required data is the Biosorter® output that contains information about TOF, Extinction and sort status (summary file). Note that for this analysis the original Biosorter data is copied to an Excel file. A total of 8 datasets have been used for each gate category: R10R11 (200-400 μm), R12 (400-500 μm), R13plus (> 500 μm) and R19 (200 to >500 μm). Each dataset is stored in a separate sheet. Data can be accessed here: ./data/sort_recovery_data.xlsx. All the file and folder names are the same as used in the script.

```
sort_recovery.ipynb
```

## 7. Variation in egg size distribution among *Drosophila* strains

We have measured the egg size distributions in *D. simulans* (12 strains), *D. melanogaster* (1 strain), *D. erecta* (1 strain), *D. santomea* (1 strain) and *D. mauritiana* (1 strain). in section **4. The size distribution of Drosophila inbred lines** on the notebook, each data set is filtered using the procedure described in *filter_size_optical_density.ipynb*. 

In section **4.4 Comparison of egg size distributions based on filtering thresholds** of the notebook we performed size filtering steps (the 1st and last steps deccribed in **2. In silico filtering of the Biosorter® data** above) using both a sample-specific threhsold and a constant threshold computed as the average threshold across all datasets. We computed summary statistics for each filtered dataset and observed a high correlation in the number and average size of the filtered small objects, the number of eggs and mean, and median of their distribution. Therefore, for all the subsequent analysis sample-specific thresholds were used. We then compute the speed of measurement for all the datasets in section **4.5 Compute the measurement speed** of the notebook. 

For each sample two datasets are required: The first file is the Biosorter® output that contains information about TOF, Extinction and fluorescence absorbance (summary file). The second file contains the optical density data. Biosorter® data can be accessed here: ./data/Drosophila_eggs_OD1_5_1xPBS_21-12-2021_1.zip, ./data/Drosophila_eggs_OD1_5_1xPBS_21-12-2021_2.zip and ./data/Drosophila_eggs_OD1_5_1xPBS_22-12-2021.zip. All the file and folder names are the same as used in the script.

```
Eggsize.ipynb
```

## 8. Egg-to-adult viability assay

We performed egg-to-adult viability assay to determine the effect of submersion in PBS and passing through the flow cell in the Biosorter® on the development of eggs to adults.

Data can be accessed here: ./Data/PBS_viability_Nov242022_mod.txt. There are 9 columns in the file: vial_num, replicate, flies_1stcount, flies_2ndcount, flies_3rdcount, flies_4thcount, total_fly, treatment, egg_num. 
PBS_expo (the duration of immersion in PBS, 4, 6, and 8 hours), subreplicate (different sets for each treatment), egg_num (number of eggs in each vial), fly_num (number of eclosed flies), and sort (the sort status, whether the eggs were sorted by Biosorter® or not).
vial_num	replicate	flies_1stcount	flies_2ndcount	flies_3rdcount	flies_4thcount	total_fly	treatment	egg_num

```
PBS_assay_hatch_stat_final.R
```
## 9. Biosorter® output files

For the description of the data in summary file of Biosorter®, please refer to pages 77-78 in Biosorter® manual  that can be accessed here: https://med.stanford.edu/content/dam/sm/htbc/documents/eq/BioSorter-manual.pdf

We couldn't find a proper documentation of optical density files generated by Biosorter®. In brief, the optical density outputs contain measurements along each object’s
time of flight (TOF) for each of the four optical parameters: extinction and three fluorescence channels. Therefore, each object has 4 optical density reading (each stored as a column in optical density file labeled as Id, Id.1, Id.2 and Id.3). Id in the optical density file and summary file are identical and are used to match the optical density of each object. We only use the first column which corresponds to Extinction. 

---------------------------------------------

The scripts were written in Python 3 and R version 3.6.3. 

For any questions please contact me at barghi.neda@gmail.com. 
