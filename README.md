# GenSel

Anything related to GenSel program from Iowa State. Writen for genomic selection and GWAS analysis for linear and categorical traits. This program only handles animals with phenotypes **and** genotypes. Please refer to Hao Cheng's Julia package JWAS [here](https://github.com/reworkhow/JWAS.jl) for more information on this program. That package will handle more complex models (maternal, repeatability, etc) and single-step analyses based on their [GSE paper](https://gsejournal.biomedcentral.com/articles/10.1186/1297-9686-46-50). 

## About

GenSel was created and written at Iowa State University by Rohan Fernando ([here](https://www.linkedin.com/in/rohan-fernando-b2123520/)) and Dorian Garrick (now at Massey University in New Zealand, see [here](https://www.linkedin.com/in/dorian-garrick-7a248667/)). 

## Downloading/Installing

You should be able to contact Dorian Garrick (d.garrick@massey.ac.nz) for information on the download. 

You need two more packages as well to run on a Mac/Linux (don't know about Windows). To get GenSel libraries you need to go to this link and get the correct version [here](https://www.dropbox.com/sh/vdaafp5v1hwc75e/AADVDWfmMnPzM18FUbhLF0bia?dl=0). 

### For Mac

I believe you need this [link](http://hpc.sourceforge.net/). But it's been awhile so I forget, but you need to download the gfortran I believe. 

### For Linux

For Ubuntu, you need to create an environmental variable in your `.bash_profile` that sets LD_LIBRARY_PATH. You will need to modify or create a `.bash_profile` (create with `touch` or `vim`) that goes in your `$HOME` directory. On Linux this should look like `/home/yourname/`. I'm not sure about other flavors of Linux. 

Depending on where you put the program, ddd this to your `.bash_profile`:
```bash
LD_LIBRARY_PATH=/home/your_username/bin/GenSel/
export LD_LIBRARY_PATH
```

You will need to adjust the directory based on where you leave the binaries. I like to keep all mine within my `$HOME/bin/` folder. 

I also add this line to my `.bash_profile` to find the directory where I put my binary program. I put them in my `~/bin/GenSel/` folder. 
```bash
export PATH=$HOME/bin/GenSel:$PATH
```

## Getting Started

Once you have it downloaded, added to your path, and any other software needed installed, you can begin to run GenSel programs. 

You can get the manual [here](https://static-content.springer.com/esm/art%3A10.1186%2F1471-2105-12-186/MediaObjects/12859_2010_4655_MOESM1_ESM.PDF). It has some information in, but as a whole lacks a lot of information to get started such as file formats and that type of thing. The rest is learning how to tune GenSel to get the correct answers. 

### File Formats (txt, csv, tsv, etc)

It seems like either tab or spaces work fine from what I understand. I'd keep it simple and just use spaces. Most other programs, this is easiest. Whichever you use, be consistent (like always). 

### Data File

> IMPORTANT: You need the first word in the data file, map file (chromosome info file), and genotype file to all have the **same word** (although it doesn't make sense because for some it's a SNP for the map file and animal ID for the data and genotype files). I name this 'SNP' in my example. 

An example space delimited (data_sub2.txt):

| SNP  | Phenotype | Group$ | 
|------| -------| ----|
| 0001 | 0.3647 | 1A  |
| 0002 | 0.5974 | 1A  |
| ...  | ...    | ... |
| 1340 | 0.5173 | 3G  |
| 1341 | 0.3967 | 3G  |
| 1343 | 0.2509 | 3G  |

![Screenshot of Data File](/Screenshots/MSE_data.png?raw=true "Data file example")

The first column needs to be the animal ID matching the genotype file. The 2nd column needs to be the phenotype of interest (any column name). The `$` after Group tells GenSel that it's group/class/factor/etc not a covariate (linear). All columns in the datafile will be used, so don't add extra columns. I will try to write an external bash script or something to handle this I hope. 

### Map File

An example space delimited (ChrInfoFinal_GenSel.txt):

| SNP | ALGP2_chr | ALGP2_pos |
|--- | --- | --- |
| AX-116097596 | 1  | 5104   |
| AX-116696855 | 1  | 11173  |
| AX-116696856 | 1  | 11289  |
| ...          | ...| ...    |
| AX-116627004 | 19 | 144283026 |
| AX-116627005 | 19 | 144285591 |
| AX-116799393 | 19 | 144287132 |

![Screenshot of Map File](/Screenshots/MSE_map.png?raw=true "Map file example")

> IMPORTANT: Remember to add the same beginning to the 2nd and 3rd column names (Chromosome and Position). (I used ALGP2, see parameter file below to see how to specify this)

These don't have to be in order. You should be able to include more SNP than you have in your genotype file. GenSel will only use those it finds in the genotype file. This is nice if you have different subsets. 

### Genotype File

The first column name should match the other files (map and data files). The rest of the column names should be the SNP names from the map file. Genotypes need to be -10, 0, 10. Missing genotypes are not allowed (usually 5 or -1), but you can impute with the column average (or allele frequency) and GenSel will ignore them (I've been told, but I would suggest imputing with FImpute or something like this). 

An example space delimited (genotypes_imp_GenSel.txt):

| SNP | AX-116097596 | AX-116696855 | AX-116696856 | AX-116696857 | ... |
| --- | --- | --- | --- | --- | --- |
| 0185 | 10 | 10 | 10 | 10 | ... |
| 0324 | 10 | 10 | 10 | 10 | ... |
| 0332 | 10 | 10 | 10 | 10 | ... |
| .... | ... | ... | ... | ... | ... |
| 0994 | 10 | 10 | 10 | 10 | ... |
| 1007 | 10 | 10 | 10 | 10 | ... |
| 1014 | 10 | 10 | 10 | 10 | ... |

![Screenshot of Genotype File](/Screenshots/MSE_genotypes.png?raw=true "Genotypes file example")

You need to have the same name in the top left (SNP for me). Then the SNP names cooresponding to the SNP in the map file as column names. ID's of animals should go in the first column. 

Once you have ran the parameter file once, it will write out a binary file with the genotypes. This will be saved as `old_file_name.txt.newbin`. Use the `.newbin` file after you've read them in once. This will save some time (depending on the size of your file). 

## GenSel Parameter File

This is a simple space/tab delimited file to add the inputs for GenSel like most of the software ran on the command line. Always name with the .inp extension for GenSel and to find them later. One keyword per line. 

These are pretty easy in GenSel. Just use the keywords from the manual. `outputMarkerHeaderName` will indicate the first column name from the map, data, and genotype file. `linkageMap` will tell GenSel what the beginning of the chromosome and position column name is in the map file (see above). 

Example (MSE.inp):
```
# Files
phenotypeFileName data_sub2.txt               # Phenotype file
markerFileName genotypes_imp_GenSel.txt       # Genotype file
mapOrderFileName ChrInfoFinal_GenSel.txt      # Map/Chr file

# column names
outputMarkerHeaderName SNP                    # Name of first column name in all 3 files
linkageMap ALGP2                              # Beginning part of map file chromosome and position column names

# analysis
analysisType Bayes                            # Bayes analysis
bayesType BayesC                              # BayesC analysis (1 variance)
probFixed 0                                   # pi = 0 (all markers fit in the model)
chainLength 50000                             # 50,000 iterations
burnin 10000                                  # 10,000 samples to discard at start
varGenotypic 0.00233                          # prior for genetic variance (from GBLUP)
varResidual 0.00843                           # prior for residual variance (from GBLUP)

# other
addMapInfoToMarkers yes                       # Not sure...
windowBV yes                                  # Calculate Window variances (1 Mb by default)
```

![Screenshot of Parameter File](/Screenshots/MSE_inp.png?raw=true "Parameter file example in vim")

This analysis will run BayesC with pi = 0 for 50,000 iterations and 10,000 burnin samples. You need to set good starting values for priors for the genetic and residual variances. We like to use the results from BayesC pi = 0 for the other Bayesian analyses. 

## Output

GenSel outputs many different output files. It generally names them with a number behind it, in case you run multiple runs with the same parameter file. So if you title your parameter file `ADG.inp` (you should always name it with the .inp extension) the output will be `ADG.out1`, followed by `ADG.out2`, `ADG.out3`, etc. This will happen for all of the other output files as well (`.mrkRes1`, `.mrkRes2`, etc for example).

Main output files:
* **base.cgrResn**
* **base.cgrResSampelsn**
* **base.ghatRELn**
* **base.mrkResn**
* **base.outn**
* **base.outSamplesBINn**
* **base.winQTLn**
* **base.winVarn**

Where 'n' refers to the analysis number. They don't overwrite files like other programs, so they just keep numbering files 1,2,...,n. 




# Tips and Tricks

1. Remember to convert the file to unix if did the data or genotyping on Windows. Use `dos2unix` on the Linux command line if you have it available or find another way to remove the ^M from Windows. 




# Errors/Comments

As always, please email me if there are errors or you just have comments or suggestions about what to include in this help file. 





