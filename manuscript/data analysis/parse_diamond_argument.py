#! usr/pyenv/python3

import glob,re,os,sys
from pathlib import Path

blast_file="/gpfs/ebg_work/hackathon/diamond/diamondout_All_hydrocarbon_reference_sequences.txt"

def make_fasta(f_path,out):
    with open(f_path,'r') as group,open(blast_file,'r') as blast, open(out, 'a') as fasta:
        seqid=[]

        for line in group:
            line=line.strip('\n')
            seqid.append(line)
        print(seqid)

        for line in blast:
            cols=line.split('\t')
            #print(cols)
            if cols[0] in seqid:
                print(cols[0])
                fasta.write('>' + cols[1] + '\n' + cols[12] + '\n')
    return;

def main():
    import re
    directory=sys.argv[1]
    groups=[]
    for file in os.listdir(directory):
        if file.startswith("Homolog"):
            groups.append(file)
    print(groups)
    
    for f in groups:
        print(f)
        g_num=int(''.join(filter(str.isdigit,f)))
        fpath=f"{directory}/{f}"
        out=f"{directory}/Group{g_num}.faa"
        make_fasta(fpath,out)
main()
    
          
              


