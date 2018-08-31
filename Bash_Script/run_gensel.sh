#!/bin/bash

#==============================================================================#
# Setup
#==============================================================================#

# Author: Austin Putz (putz dot austin at gmail dot com)
# Created:  Dec 29, 2017
# Modified: August 31, 2018
# License: GPLv2

#==============================================================================#
# Description
#==============================================================================#

# This script is loop through all traits given in the data folder that have
# individual data files. It will use a common parameter file unless 
# options are given to change it. 

#------------------------------------------------------------------------------#
#
# SETUP:
# 
# 1) Place all your datafiles in a directory within your working directory
# 		- I call mine "Data". Loop through traits in R to setup your datasets
# 		named trait1.dat, trait2.dat (for example ADG.dat, BF.dat, etc)
# 		- Use the na.omit() function on the dataset to remove all missing
# 		  after subsetting. 
# 
# 2) Write a template .inp (parameter file) for GenSel
# 		Add keywords 
#			TRAIT.EXT
#			CAT
#			a_var
#			e_var
#
# 3) Write a file to indicate the traits and their starting values
#
#----------------------------------------#
# Examples of traits file (-t option)
# Format:
# SPACE Delimited
# NO HEADER
# column 1 = Trait, column 2 = a_var, column 3 = e_var, column 4 = is_cat (is categorical? yes/no)
#----------------------------------------#
#
# Mortality 0.05 0.4 yes
# ADG 0.1 0.9 no
# Backfat 0.5 0.5 no
# Loindepth 0.4 0.6 no
# FeedIntake 0.5 0.5 no
# etc...
# 
#----------------------------------------#
#
# 4) I like to add the script to my ~/bin folder to have access 
# 	from anywhere by adding the PATH to my .bash_profile
# 
# export PATH=$HOME/bin:$PATH
# 
#------------------------------------------------------------------------------#

#==============================================================================#
# Options and some documentation
#==============================================================================#

# set data file name
CUR_DIR=`pwd`

# move into current directory
cd $CUR_DIR

#------------------------------------------------------------------------------#
# OPTIONS:
#
#   -n          = name of gensel program (will try to find the path if it exists)
# 	-d			= data file directory (named trait1.dat, trait2.dat, etc)
# 	-o 			= output directory (will create one directory per trait)
# 	-f 			= force delete output directory
# 	-t			= file for starting values of traits
# 	-i			= .inp file (template)
#					- Has keywords 
#						TRAIT = to substitute the current trait
# 						a_var = to substitute the additive var starting value
# 						e_var = to substitute the residual var starting value
# 	-ext 		= extension on datasets (default = dat)
#
#------------------------------------------------------------------------------#

#----------------------------------------#
# RUN EXAMPLE:
#
# run_gensel.sh -n gensel -d Data -o Output -t traits.txt -f -i template.inp
#
#----------------------------------------#





#==============================================================================#
# Set Options
#==============================================================================#

# set options
delete=0
ext="dat"
GENSEL="gensel"

# loop through positional variables to set variables
if [ -z $1 ]; then    # if there are no variables given, stop and warn

	# print usage to STDERR
	printf "\nUsage: run_gensel.sh -n [name of your gensel program] -d [data sets directory] -o [output directory] -t [traits file with starting values] -i [template .inp file] -f -ext [extension on datasets]\n" 1>&2

	# print options to STDERR
	printf "\n\t-n	= Name of YOUR GenSel program" 1>&2
	printf "\n\t-d	= Directory name with datasets present (name them trait1.dat, trait2.dat, etc..)" 1>&2
	printf "\n\t-o 	= Directory for output" 1>&2
	printf "\n\t-f 	= Force delete output directory" 1>&2
	printf "\n\t-t	= File with traits and starting values (Trait a_var e_var, new trait on each line)" 1>&2
	printf "\n\t-i 	= File for template .inp file" 1>&2
	printf "\n\t-ext 	= Extension on dataset files (default = dat)\n\n" 1>&2

	exit 1

else
	while [[ $# -gt 0 ]]; do
		case $1 in

		# set variables
		-n)		shift
				GENSEL=$1
				;;
		-d) 	shift
				DATA_DIR=$1      # set data directory to find data files
				;;
		-o)		shift
				OUTPUT_DIR=$1    # set output directory to move files
				;;
		-f)		delete=1
				;;
		-t)		shift
				traits=$1      # set file for finding starting values
				;;
		-i) 	shift
				template=$1
				;;
		-ext)	shift
				ext=$1
				;;
		esac  # end case
		shift # start new search
	done
fi





#==============================================================================#
# Print checks
#==============================================================================#

echo -e "\n--------------------------------------------------------------------------------"
echo "-----  Checking Options -----"
echo "--------------------------------------------------------------------------------"

#----------------------------------------#
# Check gensel executable
#----------------------------------------#

printf "\n----- GENSEL EXECUTABLE -----\n"

PATH_GENSEL=`which $GENSEL`

if [[ -z $GENSEL ]]; then

	# print error
	printf "\n\tCannot find your GenSel Program (specify with -n) or change your PATH variable to find it.\n" >&2
	exit 1

else

	# print gensel location
	printf "\n\tGenSel Program Location: %s\n" $PATH_GENSEL

fi


#----------------------------------------#
# Check Current directory
#----------------------------------------#

printf "\n----- CURRENT DIRECTORY -----\n"

if [[ -d $CUR_DIR ]]; then

	# print directory
	printf "\n\tCurrent Directory: %s\n" $CUR_DIR

else

	# print error
	printf "\n\tERROR: Can't find current working directory\n\n" >&2
	exit 1

fi

#----------------------------------------#
# Check Data directory
#----------------------------------------#

printf "\n----- DATA DIRECTORY -----\n"

if [[ -d $DATA_DIR ]]; then

	# print directory
	printf "\n\tData Directory:\t%s\n" $DATA_DIR

else

	# print error
	printf "\n\tERROR: Can't find data directory\n\n" >&2
	exit 1

fi

#----------------------------------------#
# Check Output directory
#----------------------------------------#

printf "\n----- OUTPUT DIRECTORY -----\n"

# check to see if a name was given
if [[ -z $OUTPUT_DIR ]]; then

	printf "\nERROR: Output Direcotory not given\n\n" >&2
	exit 1

fi

# delete directory if specified
if [[ $delete==1 ]]; then

	# delete the output directory
	rm -rf $OUTPUT_DIR

fi

# print error or name of output directory
if [[ -d $OUTPUT_DIR ]]; then

	# print error
	printf "\n\tERROR: Output file exists, please rename, move, or delete!\n\n" >&2
	exit 1

else

	# print directory
	printf "\n\tOutput Directory: %s\n" $OUTPUT_DIR

fi

#----------------------------------------#
# Check Traits file
#----------------------------------------#

printf "\n----- TRAITS FILE -----\n"

# Find traits file
if [[ -f $traits ]]; then

	# print file 
	printf "\n\tTraits file: %s\n" $traits

else

	# print error
	printf "\n\tERROR: Can't find traits file\n\n" >&2
	exit 1

fi

#----------------------------------------#
# Check Template file
#----------------------------------------#

printf "\n----- TEMPLATE FILE -----\n"

if [[ -f $template ]]; then

	# print file 
	printf "\n\tTemplate file: %s\n" $template

else

	# print error
	printf "\n\tERROR: Can't find template file\n\n" >&2
	exit 1

fi

#----------------------------------------#
# Check Extension
#----------------------------------------#

printf "\n----- EXTENSION ON DATASETS -----\n"

	# print file 
	printf "\n\tExtension on datasets: %s\n" $ext





#==============================================================================#
# Set new variables
#==============================================================================#

printf "\n----- ADDING VARIABLES -----\n"

# set number of traits to run
n_traits=`awk ' END { print NR }' ${traits}`
printf "\n\tNumber of traits: %s\n" $n_traits





#==============================================================================#
# Create Output direcotry
#==============================================================================#

mkdir $OUTPUT_DIR






#==============================================================================#
# Run program
#==============================================================================#

# List Current files
CUR_FILES=`ls`

printf "\n----- BEGIN LOOP -----\n"

# Loop through traits
for i in $(seq 1 $n_traits); do

	# get trait name from traits file
	cur_trait=`awk ' { print $1 }' $traits | awk ' NR=='""$i""' '`
	cur_a_var=`awk ' { print $2 }' $traits | awk ' NR=='""$i""' '`
	cur_e_var=`awk ' { print $3 }' $traits | awk ' NR=='""$i""' '`
	cur_type=`awk ' { print $4 }' $traits  | awk ' NR=='""$i""' '`

	printf "\n\n\n------------------------------ $cur_trait ------------------------------\n\n"

	printf "\n\tAnalysis number: %s" $i

	# print trait name
	printf "\n\tCurrent Trait is: %s" $cur_trait
	printf "\n\tCurrent additive var starting value is: %s" $cur_a_var
	printf "\n\tCurrent residual var starting value is: %s" $cur_e_var
	printf "\n\tCurrent type (categorical?): %s\n" $cur_type
	
	# copy data to current directory
	cp $CUR_DIR/Data/$cur_trait.${ext} $CUR_DIR

	# create directory in Output
	mkdir ${OUTPUT_DIR}/$cur_trait

	# print message
	printf "\n\tReplacing keywords in template file\n\n"

	# change name in template.inp file
	sed 's/TRAIT/'""$cur_trait""'/g'  $template            > ${cur_trait}.inp
	sed 's/EXT/'""$ext""'/g'          ${cur_trait}.inp     > ${cur_trait}.inpabc2
	sed 's/a_var/'""$cur_a_var""'/g'  ${cur_trait}.inpabc2 > ${cur_trait}.inpabc3
	sed 's/e_var/'""$cur_e_var""'/g'  ${cur_trait}.inpabc3 > ${cur_trait}.inpabc4
	sed 's/CAT/'""$cur_type""'/g'     ${cur_trait}.inpabc4 > ${cur_trait}.inp

	# remove intermediate inp files
	rm -f ${cur_trait}.inpabc2
	rm -f ${cur_trait}.inpabc3
	rm -f ${cur_trait}.inpabc4

	# describe data set
	nrows=`awk ' END { print NR } ' ${cur_trait}.${ext}`
	ncols=`awk ' END { print NF } ' ${cur_trait}.${ext}`

	# print data dimensions
	printf "\n\tCurrent dataset n rows: %s" $nrows
	printf "\n\tCurrent dataset n cols: %s\n" $ncols

	# starting GENSEL
	printf "\n\tSTARTING GENSEL!!!\n\n\n"

	# run gensel
	#gensel ${cur_trait}.inp
	${GENSEL} ${cur_trait}.inp

	# move files that are newer than checkmark.txt to correct directory
	mv $cur_trait.* ${OUTPUT_DIR}/$cur_trait/

	# move traits file back if moved (can't figure out why this happened)
	#mv ${OUTPUT_DIR}/$cur_trait/$traits $CUR_DIR

	# move to working directory
	cd $CUR_DIR

done








