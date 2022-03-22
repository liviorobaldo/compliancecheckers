import os
import subprocess
import platform
import time
import argparse

parser = argparse.ArgumentParser()
output_options = parser.add_argument_group("Opzioni di output")
output_options.add_argument("-o", "--out", type=str, help="Specificare il nome di un file di output. L'output sarà stampato su file")
input_options = parser.add_argument_group("Opzioni di input")
input_options.add_argument("path", nargs='+', help="Path di uno o più file da eseguire")
execution_options = parser.add_argument_group("Opzioni di esecuzione")
execution_options.add_argument("-f", "--folder", type=str, help='Inserire path di una cartella contenente tutti gli input da eseguire separatamente sul programma logico')
dlv2_options = parser.add_argument_group("Opzioni di DLV2")
dlv2_options.add_argument("-n", type=int, default=1, help='Inserire il numero di answerset da calcolare (default=1, -n0 calcola tutti gli AS)')
dlv2_options.add_argument("--printonlyoptimum", action='store_true', help='Stampa solo gli answersets ottimi (utile in caso di presenza di weak constraints)')

args = parser.parse_args()

out_file = ""
if args.out != None:
    out_file = open(args.out, 'w')

def run(cmd):
    if args.out != None:
        out_file.writelines("INPUT: %s\n" % (cmd[-1]))
    else: print("INPUT: %s\n" % (cmd[-1]))

    dlv2_process = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)

    start = time.time()
    (out, err) = dlv2_process.communicate()
    elapsed = time.time() - start

    if args.out != None:
        out_file.writelines(out.decode())
        if platform.system()=="Linux":
            err = err.decode().splitlines()
            out_file.writelines("%s \n%s \n%s\n" % (err[1].lstrip(), err[2].lstrip(), err[4].lstrip()))
        elif platform.system()=="Windows":
            out_file.writelines("Time: " + str(round(elapsed,4)) + "s")
        out_file.writelines("\n")
    else:
        print(out.decode())
        if platform.system()=="Linux":
            err = err.decode().splitlines()
            print("%s \n%s \n%s\n" % (err[1].lstrip(), err[2].lstrip(), err[4].lstrip()))
        elif platform.system()=="Windows":
            print("Time: " + str(round(elapsed,4)) + "s")
        print("\n")


if platform.system()=="Linux":
    cmd = ["/usr/bin/time", "-v", "./executables/dlv2"]
elif platform.system()=="Windows":
    cmd = ["executables//dlv2.exe"]

if args.n != None:
    cmd.append("-n"+str(args.n))
if args.printonlyoptimum:
    cmd.append("--printonlyoptimum")

cmd.extend(args.path)


if args.folder:
    full_paths = os.path.join(os.getcwd(), args.folder)
    for root, dirs, files in os.walk(full_paths, topdown = False):
        for name in sorted(files):
            new_cmd = cmd + [str(os.path.join(root, name))]
            run(new_cmd)

else: 
    run(cmd)

if args.out != None:
    out_file.close()

