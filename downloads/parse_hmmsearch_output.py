#Script to parse HMM search output to hits >= respective HMM cutoff score.

#! usr/pyenv/python3

import sys

cutoff_file=sys.argv[1] #comma seperated file of HMM name and cutoff value
hmm_file=sys.argv[2] #HMM search table output
out_file=sys.argv[3] #output file

cutoff = {} #create a dictionary
with open(cutoff_file, 'r') as score:
    for line in score:
        key, value = line.strip().split(',') #split lines by comma (HMM name, cutoff value)
        cutoff[key] = value #key:value pairs of HMM names and cutoff values

#print(cutoff.keys())
#print(cutoff.values())

with open(hmm_file, 'r') as hmm, open(out_file, 'w') as out:
    for line in hmm:
        cols = line.strip().split() #split HMM search table output by white space - do not specify split delimiter
        if cols[2] in cutoff.keys(): #cols[2] is the HMM name
            if float(cols[8]) >= float(cutoff[cols[2]]): #cols[8] is the HMM score, cutoff[cols[2]] is the cutoff value 
                out.write(line) #write the full matched line to the output file