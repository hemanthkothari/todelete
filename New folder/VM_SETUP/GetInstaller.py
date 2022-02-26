"""
This script is mainly intended to get the installed packages from
the given log file.
Q:\temp_share\software_stack.txt is the same share location "\\us-aus-rtweb2\Resources\temp_share\software_stack.txt"
"""

import sys
import os

def ReadFileLines(filepath):
    lines = []
    with open(filepath) as f:
        lines = f.readlines()
    return lines

def main():
    filepath = sys.argv[1]
    lvversion = sys.argv[2]
    if os.path.isfile(filepath):   
        fileLines = ReadFileLines(filepath)
        outputFilePath = r"Q:\temp_share\software_stack.txt"
        with open(outputFilePath,'a+') as f:
            for inst in fileLines:
                if 'GetLatestInstaller' in inst and lvversion in inst:
                    lvinstpath = inst
                    newlvinstpath = os.path.join(lvinstpath[22:-3].strip(),r"meta-data\buildInfo.ini")
                    newfile = open(newlvinstpath,'r')
                    for line in newfile:
                        if 'myC' in line or 'lvV'  in line or 'lvC' in line:
                           f.write(line)
            for line in fileLines:
                if 'GetLatestInstaller' in line:
                    f.write(line)

    else:
        print("File path {} does not exist. Exiting...".format(filepath))
        sys.exit()
if __name__ == '__main__':  
   main()