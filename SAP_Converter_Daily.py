import io
import os
import datetime
from textwrap import wrap

encoded = "utf-16-le" #unicode, utf-16, utf-16-le, utf-16-be, utf-8

srcPath = "/home/oc" #Audit log files path

audFile = srcPath + "/audit_" + datetime.datetime.now().strftime("%Y%m%d") + ".log"

stateFile = srcPath + "/audit.stat"

if os.path.exists(audFile):
    audSize = os.path.getsize(audFile)
    if os.path.exists(stateFile):
        sf = open(stateFile,"r+")
        stSize = int(sf.read().strip())
        if audSize > stSize:
            af = open(AUDfile,mode="r", encoding=encoded)
            lf = open(str(AUDfile).split('.log')[0]+'.aud',"w+")
            content = af.read()
            for i in range(0,len(content),200):
                lf.write(content[i:i+200]+"\n")
            sf.write(stSize)
            sf.close()
            af.close()
            lf.close()
        quit(0)
    else:
        sf = open(stateFile,"w+")
        af = open(audFile,mode="r", encoding=encoded)
        lf = open(str(audFile).split('.log')[0]+'.aud',"w+")
        content = af.read()
        for i in range(0,len(content),200):
            lf.write(content[i:i+200]+"\n")
        sf.write(str(audSize))
        sf.close()
        af.close()
        lf.close()
        quit(0)
    
else:
    quit(0)