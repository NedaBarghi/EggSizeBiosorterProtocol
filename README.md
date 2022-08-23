# EggSizeBiosorterProtocol

This folder contains all the scripts needed to reproduce the results in Barghi N and Ramirez-Lanzas C. (2022). High throughput and accurate size measurements of Drosophila eggs using large particle flow cytometry. bioRxiv.

## 1. Reference beads
This notebook is a step by step guide that describes using the reference beads to convert time of flight (TOF) to size (μm). The computed slope and intercept of these reference beads are used to convert TOF of all subsequent Biosorter runs to size. 

This script is not a prerequisite of the rest of the pipeline. In other scripts the conversion of TOF to size (μm) using reference beads is done through function **compute_append_size**.

```
ref_bead_size.ipynb
```
## 2. In silico filtering of the Biosorter data

This notebook is a step by step guide that describes the in silico filtering steps on Biosorter data. The 1st filtering step is based on the size. The filtered objects at this step are mostly egg debris. The second filtering step involved removing the misaligned eggs based on ellipticalness index (EI) and the ratio of the maximum optical density of an object to its time of flight (W/L) values estimated from the optical density data. The last filtering step is to remove the objects in the first peak of distribution after removal of the misaligned eggs. 

For each sample two datasets are required: The first file is the Biosorter output that contains information about TOF, Extinction and fluorescence absorbance (summary file). The second file contains the optical density data. Data can be accessed here:
All the file and folder names in the script and Zenodo repository are the same.

This script is not a prerequisite of the rest of the pipeline. In other scripts the filtering of Biosorter data is done through function **filter_size_EI_WL_size**.

```
filter_size_optical_density.ipynb
```

## 3. 



```
```


```
```
## 4. 



The scripts were written in Python 3. 

For any questions please contact me at barghi.neda@gmail.com. 
