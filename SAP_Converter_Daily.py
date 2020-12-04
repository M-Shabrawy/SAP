import io
import os
import datetime
from pathlib import Path
from textwrap import wrap

encoded = "utf-16-le" #unicode, utf-16, utf-16-le, utf-16-be, utf-8

#Audit log files path
srcPath = "/home/oc"

#Original SAP Genrated audit log file
logFile = srcPath + "/audit_" + datetime.datetime.now().strftime("%Y%m%d") + ".log"
#Converted audit fule
audFile  = srcPath + "/audit_" + datetime.datetime.now().strftime("%Y%m%d") + ".aud"
#State File
stateFile = srcPath + "/audit.state"

if os.path.exists(logFile):
    logSize = os.path.getsize(logFile)
    if not os.path.exists(audFile) and os.path.exists(stateFile):
        os.remove(stateFile)
        print ("Deleted old state file")
    elif os.path.exists(stateFile):
        sf = open(stateFile,"r+")
        print ("State file found")
        stSize = int(sf.read().strip())
        if logSize > stSize:
            print ("log file changed")
            af = open(logFile,mode="r", encoding=encoded)
            lf = open(logFile+'.aud',"w+")
            content = af.read()
            for i in range(0,len(content),200):
                lf.write(content[i:i+200]+"\n")
            sf.write(str(logSize))
            print ("File converted " + logFile)
            sf.close()
            af.close()
            lf.close()
        quit(0)
    else:
        print ("new log file")
        sf = open(stateFile,"w+")
        af = open(logFile,mode="r", encoding=encoded)
        lf = open(logFile+'.aud',"w+")
        content = af.read()
        for i in range(0,len(content),200):
            lf.write(content[i:i+200]+"\n")
        sf.write(str(logSize))
        sf.close()
        af.close()
        lf.close()
        quit(0)
    
else:
    print ("Nothing to do")
    quit(0)