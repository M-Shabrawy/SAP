import io
import os
from pathlib import Path
from textwrap import wrap

encoded = "utf-16-le" #unicode, utf-16, utf-16-le, utf-16-be, utf-8

SrcPath = "/usr/sap/dev/log" #Audit log files path

AUDFiles = Path(SrcPath).glob("audit*") #Get all files with the name audit

for file in AUDFiles:
    sf = open(file,mode="r", encoding=encoded)
    df = open(str(file).split('.log')[0]+'.aud',"w+")
    content = sf.read()
    for i in range(0,len(content),200):
        df.write(content[i:i+200]+"\n")
    sf.close()
    df.close()