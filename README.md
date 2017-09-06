# GenSel
Anything related to GenSel program from Iowa State

## About

GenSel was created and written at Iowa State University by Rohan Fernando ([here](https://www.linkedin.com/in/rohan-fernando-b2123520/)) and Dorian Garrick (now at Massey University in New Zealand, see [here](https://www.linkedin.com/in/dorian-garrick-7a248667/)). 

## Downloading/Installing

You should be able to contact Dorian Garrick (d.garrick@massey.ac.nz) for information on the download. 

You need two more packages as well to run on a Mac/Linux (don't know about Windows). To get GenSel libraries you need to go to this link and get the correct version [here](https://www.dropbox.com/sh/vdaafp5v1hwc75e/AADVDWfmMnPzM18FUbhLF0bia?dl=0). 

For Mac, I believe you need this [link](http://hpc.sourceforge.net/). But it's been awhile so I forget, but you need to download the gfortran I believe. 

For Linux, you need to create an environmental variable in your bash_profile that sets LD_LIBRARY_PATH. So in your `.bash_profile` (create with `touch` or `vim`). 

Add:
```bash
LD_LIBRARY_PATH=/home/amputz/bin/GenSel/
export LD_LIBRARY_PATH
```

I also add this line to find the directories. I put in my `~/bin/` folder. 
```bash
export PATH=$HOME/bin/GenSel:$PATH
```

## Getting Started





