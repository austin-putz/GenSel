# run_gensel.sh Bash Script

This directory has informaiton on how to run my script if you 
ever need to run 100 traits at a time back to back. Or you can split 
it up into a few directories and run them simultaneously. 

## Steps

In R (or your favorite program), loop and right out your datasets. 

```R
# list of files
  for (i in c("AMIRres", "CMIRres")){
   
    # pull out fixed effects and remove missing
    data.cur <- data.prod[, c("ID", i, "Batch", "EntryAge", "HIRTech")]
    
    # change names
    names(data.cur) <- c("SNP", i, "Batch$", "EntryAge", "HIRTech$")
    
    # remove missing
    data.cur <- na.omit(data.cur)
    
    # save to file
    write.table(data.cur, paste0(save_dir_gensel, i, ".dat"), 
      sep=" ", quote=FALSE, col.names = TRUE, row.names = FALSE)
    
  }

```

This will list files as trait1.dat, trait2.dat, etc. Just change 
to the names of your columns and your model. The $ after the 
variable name means it is a factor (class). 







