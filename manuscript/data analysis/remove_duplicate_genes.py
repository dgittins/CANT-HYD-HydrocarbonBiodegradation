#! usr/pyenv/python3

import pandas as pd
from pandas import DataFrame

import csv, sys, re

infile=sys.argv[1]
outfile=sys.argv[2]

df=pd.read_csv(infile,sep='\t')
df['Domain_Score']=pd.to_numeric(df['Domain_Score'],errors='coerce')
df_sorted=df.sort_values(['Query', 'Domain_Score'], ascending=[True, False])
df_drop_dup=df_sorted.drop_duplicates(subset=['Query'],keep='first')

df_drop_dup.to_csv(outfile,sep='\t',header=True,index=False)
