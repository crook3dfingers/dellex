#!/usr/bin/python
# -*- coding: utf-8 -*-

import argparse
from subprocess import Popen, PIPE, STDOUT

def grabversions(searchpath, outputfile):
    process = Popen(["dellex.bat", searchpath, outputfile, "includeloc"], stdout=PIPE, stderr=STDOUT)

    while True:
        output = process.stdout.readline()
        if len(output) == 0 and process.poll() is not None:
            # Process is over, so break the loop.
            break
        if output:
            # Print anything that's been written to stdout or stderr 
            # (since stderr is being written to stdout).
            print(output.strip())

if __name__=="__main__":
    parser = argparse.ArgumentParser(usage='%(prog)s [options] searchpath', description='Dellex, the .dll and .exe version grabber.')

    parser.version = "0.1"
    parser.add_argument("searchpath", metavar="searchpath", type=str, help="where to recursively search for .dll and .exe files")
    parser.add_argument("-o", "--output", type=str, default="dellex-output.csv", help="where to save the csv file produced by dellex (default: ./dellex-output.csv)")
    parser.add_argument("-v", action="version")

    args = parser.parse_args()
    searchpath = args.searchpath
    outputfile = args.output

    grabversions(searchpath, outputfile)
