import glob
import argparse
import subprocess
import re
from termcolor import colored

parser = argparse.ArgumentParser(
    description='A utility for building Swift projects outside of XCode')
parser.add_argument('-r', default="main.swift",
                    help="The main project file (usually main.swift)")
parser.add_argument("-o", default="appBuild.swift",
                    help="What the resulting file should be called")
parser.add_argument("--no-compile", action="count",
                    help="Skip compiling the resulting file?")
parser.add_argument("--run", action="count",
                    help="Run the resulting file?")
parser.add_argument("--single", action="count",
                    help="Compile only the file specified by -r")

args = parser.parse_args()

files_content = []
project_files = [] if args.single else glob.glob("*.swift")

if args.r in project_files:
    project_files.remove(args.r)
if args.o in project_files:
    project_files.remove(args.o)

project_files.append(args.r)  # Put main swift file last

for swift_filepath in project_files:
    with open(swift_filepath) as sfile:
        files_content.append(sfile.read())

with open(args.o, "w") as outfile:
    outfile.write("\n".join(files_content))

errors = 0
if not args.no_compile:
    trace = subprocess.run(["swiftc", args.o], stderr=subprocess.PIPE).stderr
    trace = trace.decode()
    print()
    print(trace)
    errors = len(re.findall("error: ",trace))
    warnings = len(re.findall("warning: ",trace))
    error_stats = colored("{} errors".format(errors),["green","red"][errors>0])
    warn_stats = colored("{} warnings".format(warnings),["green","yellow"][warnings>0])
    
    print(colored("[PySwift] ","cyan")+ "Compiled with "+error_stats+" and "+warn_stats)
    print()

if args.run and errors == 0:
    subprocess.run("./"+args.o.strip(".swift"))

