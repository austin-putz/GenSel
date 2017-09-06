# GenSel
Anything related to GenSel program from Iowa State

## About

GenSel was created and written at Iowa State University by Rohan Fernando ([here](https://www.linkedin.com/in/rohan-fernando-b2123520/)) and Dorian Garrick (now at Massey University in New Zealand, see [here](https://www.linkedin.com/in/dorian-garrick-7a248667/)). 

## Downloading/Installing

You should be able to contact Dorian Garrick (d.garrick@massey.ac.nz) for information on the download. 

You need two more packages as well to run on a Mac/Linux (don't know about Windows). To get GenSel libraries you need to go to this link and get the correct version [here](https://www.dropbox.com/sh/vdaafp5v1hwc75e/AADVDWfmMnPzM18FUbhLF0bia?dl=0). 

### For Mac

I believe you need this [link](http://hpc.sourceforge.net/). But it's been awhile so I forget, but you need to download the gfortran I believe. 

### For Linux 

You need to create an environmental variable in your bash_profile that sets LD_LIBRARY_PATH. So in your `.bash_profile` (create with `touch` or `vim`). 

Add this to your `.bash_profile`:
```bash
LD_LIBRARY_PATH=/home/amputz/bin/GenSel/
export LD_LIBRARY_PATH
```

I also add this line to my `.bash_profile` to find the directory where I put my binary program in. I put them in my `~/bin/GenSel` folder. 
```bash
export PATH=$HOME/bin/GenSel:$PATH
```

## Getting Started

Once you have it downloaded, added to your path, and any other software needed installed, you can begin to run GenSel programs. 

You can get the manual [here](https://www.biomedcentral.com/content/supplementary/1471-2105-12-186-s1.pdf). It has some information in, but as a whole lacks a lot of information to get started such as file formats and that type of thing. The rest is learning how to tune GenSel to get the correct answers. 

### File Formats (txt, csv, tsv, etc)

It seems like either tab or spaces work fine from what I understand. I'd keep it simple and just use spaces. Most other programs, this is easiest. Whichever you use, be consistent (like always). 

### Data File

You need the first word in the phenotype/data file, map file (chromosome info file), and genotype file to all have the same word (although it doesn't make sense because for some it's a SNP and others it's an animal ID. I name this 'SNP' or 'ID' or whatever you want. 

An example (data_sub2.txt):

SNP Phenotype Group$ <br>
0001 0.3647 1A <br>
0002 0.5974 1A <br>
... <br>
1340 0.5173 3G <br>
1341 0.3967 3G <br>
1343 0.2509 3G <br>

The first column needs to be the ID matching the genotype file. The 2nd column needs to be the phenotype of interest (any column name). The `$` after Group tells GenSel that it's group/class/factor/etc not a covariate (linear). 

### Map File

An example:

SNP ALGP2_chr ALGP2_pos <br>
AX-116097596 1 5104 <br>
AX-116696855 1 11173 <br>
AX-116696856 1 11289 <br>
... <br>
AX-116627004 19 144283026 <br>
AX-116627005 19 144285591 <br>
AX-116799393 19 144287132 <br>

### Genotype File

An example (genotypes_imp_GenSel.txt):

SNP AX-116097596 AX-116696855 AX-116696856 AX-116696857 ... <br>
0185 10 10 10 10 ... <br>
0324 10 10 10 10 ... <br>
0332 10 10 10 10 ... <br>
.... <br>
0994 10 10 10 10 <br>
1007 10 10 10 10 <br>
1014 10 10 10 10 <br>

You need to have the same name in the top left (SNP for me). Then the SNP names cooresponding to the SNP in the map file as column names. ID's of animals should go in the first column. 

## GenSel Parameter File

This is a simple space/tab delimited file to add the inputs for GenSel like most of the software ran on the command line. Always name with the .inp extension for GenSel and to find them later. 

These are pretty easy in GenSel. Just use the keywords from the manual. `outputMarkerHeaderName` will indicate the first column name from the map, data, and genotype file. `linkageMap` will tell GenSel what the beginning of the chromosome and position column name is in the map file (see above). 

Example:
```
markerFileName genotypes_imp_GenSel.txt
phenotypeFileName data_sub2.txt
outputMarkerHeaderName SNP
linkageMap ALGP2
mapOrderFileName ChrInfoFinal_GenSel.txt
addMapInfoToMarkers yes
analysisType Bayes
bayesType BayesC
chainLength 50000
burnin 10000
probFixed 0
varGenotypic 0.00233
varResidual 0.00843
windowBV yes
```

## Output

GenSel outputs many different output files. It generally names them with a number behind it, in case you run multiple runs with the same parameter file. So if you title your parameter file ADG.inp (you should always name it with the .inp extension) the output will be ADG.out1, followed by ADG.out2, ADG.out3, etc. This will happen for all of the other output files as well. 






