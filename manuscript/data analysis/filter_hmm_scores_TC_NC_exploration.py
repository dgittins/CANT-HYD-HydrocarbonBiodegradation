#!usr/pyenv/python3
#this script is for EXPLORATION - will filter everything above NOISE CUTOFF and appends the oxygen use and HC_type (aerobic aromatic etc)

import sys, csv, argparse, itertools
#cutoff_file=sys.argv[1] #comma seperated file of HMM name and max possible scores and degradation types
#hmm_file=sys.argv[2] #HMM search table output
#out_file=sys.argv[3] #output file


parser=argparse.ArgumentParser(description='This script normalizes domain scores for hmmsearch results to the HC_degradation hmm database')


parser.add_argument('-c','--csv',help='csv file of max possible scores and degradation types')
parser.add_argument('-t','--tbl',help='tblout file from hmmsearch')
parser.add_argument('-o','--output',help='output file for normalized results')

args=parser.parse_args()
cutoff_file=args.csv
hmm_file=args.tbl
out_file=args.output

max_score={}

with open(cutoff_file, 'r') as score:
    for line in score:
        col=line.strip().split(',')
        max_score[col[0]]=[col[1],col[2],col[3],col[4]] #adds hmm name as key and Trusted and noise cutoffs and degradation type as values (Group13_con1_AC_PrmA: [1000,890,aerobic,aromatic])
#print(max_score)

with open (hmm_file, 'r') as hmm, open (out_file, 'a', newline= '') as out:
    linewriter=csv.writer(out, delimiter ='\t')#,quoting=csv.QUOTE_NONE, quotechar='',escapechar='')
    linewriter.writerow(["Query","-","HMM","-","E-value","Score","Bias","Domain_E-value","Domain_Score","Domain_Bias","Oxygen_Use","HC_Type"])
    for line in hmm:
        if not line.startswith('#'):
            cols = line.strip('\n').split() #splits on whitespace
#            print(cols)
            line_new='\t'.join(cols[0:10])
#            print(line_new)
            if cols[2] in max_score.keys():
                if float(cols[8]) >= float(max_score[cols[2]][1]): #if the domain score is greater than the noise cutoff (for exploration)
                    metabol=max_score[cols[2]][2]
                    HC_type=max_score[cols[2]][3]
#                   linewriter.writerow([line_new,str(round(nor_score,3)),metabol,HC_type])
                    out.write(line_new + '\t' + metabol +'\t' + HC_type+ '\n') #writes line and normalized score and degradation type at the end
                    continue
print("Finished normalizing " + hmm_file)
