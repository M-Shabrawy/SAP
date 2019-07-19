import io
import os
from pathlib import Path
from textwrap import wrap

unicode = False
utf16 = False
utf16le = False

SrcPath = "D:\\LogRhythm\\MPE\\SAP\\SIEM\\"

AUDFiles = Path(SrcPath).glob("*.AUD")

for file in AUDFiles:
    #print(file)
    sf = open(file,mode="r", encoding="utf-16-le")
    df = open(str(file).split('.AUD')[0]+'.log',"w+")
    content = sf.read()
    for i in range(0,len(content),200):
        df.write(content[i:i+200]+"\n")
    sf.close()
    df.close()