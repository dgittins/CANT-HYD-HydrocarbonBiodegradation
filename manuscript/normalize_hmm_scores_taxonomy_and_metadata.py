#! usr/pyenv/python3
#script normalizes the domain score by its max possible hit score and appends the normalized score (between 0-1) and also the oxygen use and HC_type (aerobic aromatic etc) to the summary table 

import sys, csv, argparse                  
#cutoff_file=sys.argv[1] #comma seperated file of HMM name and max possible scores and degradation types
#hmm_file=sys.argv[2] #HMM search summary table output (from summarize_hmm_results_gtdb.pl script)
#out_file=sys.argv[3] #output file


parser=argparse.ArgumentParser(description='This script normalizes domain scores for hmmsearch results to the HC_degradation hmm database')


parser.add_argument('-c','--csv',help='csv file of max possible scores and degradation types')
parser.add_argument('-t','--tbl',help='tblout file from hmmsearch')
parser.add_argument('-o','--output',help='output file for normalized results') 
parser.add_argument('-tax','--taxonomy',help='taxonomy key containing GTDB accessions and corresponding taxonomy') 

args=parser.parse_args()
cutoff_file=args.csv
hmm_file=args.tbl
out_file=args.output
tax_file=args.taxonomy

max_score={}

with open(cutoff_file, 'r') as score:
    for line in score:
        col=line.strip().split(',')
        max_score[col[0]]=[col[1],col[2],col[3]] #adds hmm name as key and list of max score and degradation type as values (Group10_con1_VK_TmoB: [200.7,aerobic,aromatic])
print(max_score)

tax_name={}
with open(tax_file, 'r') as tax:
    for line in tax:
        col=line.strip().split('\t')
        tax_name[col[0]]=[col[1]] #adds gtdb accession name as key and list of taxonomy as values (RS_GCF_000980155.1: [d__Archaea;p__Halobacteriota;c__Methanosarcinia;o__Methanosarcinales;f__Methanosarcinaceae;g__Methanosarcina;s__Methanosarcina mazei])
#print(tax_name)


with open (hmm_file, 'r') as hmm, open (out_file, 'a') as out:
    for line in hmm:
        if not line.startswith('#'):
            cols = line.strip().split('\t') #splits on whitespace
            if cols[1] in max_score.keys():
                nor_score=float(cols[3])/float(max_score[cols[1]][0]) #normalize the domain score by the max possible domain score for that HMM
                metabol=max_score[cols[1]][1]
                HC_type=max_score[cols[1]][2]
            if cols[0] in tax_name.keys():
                acc_tax=tax_name[cols[0]][0]
                out.write(line.strip('\n') + '\t'+ str(round(nor_score,3)) +'\t'+metabol +'\t'+HC_type+'\t'+acc_tax+ '\n') #writes line and normalized score and degradation type at the end
                continue 


