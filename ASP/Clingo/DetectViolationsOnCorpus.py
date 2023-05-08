import sys
import clingo
from os import listdir
from os.path import isfile, join

class Application:
    def __init__(self, name):
        self.program_name = name

    def main(self, ctl, files):
        if len(files) > 0:
            for f in files:
                ctl.load(f)
        else:
            ctl.load("-")
        ctl.ground([("base", [])])
        ctl.solve()

corpusDirectory = sys.argv[2:3][0]
corpusfiles = [join(corpusDirectory, f) for f in listdir(corpusDirectory) if isfile(join(corpusDirectory, f))]
for f in corpusfiles:
    print("------------------------------------------------------------------------------------------------------------------------------------------------", flush=True)
    print("FILE: "+f+"\n", flush=True)
    clingo.clingo_main(Application(sys.argv[0]), [sys.argv[1:2][0], f])
    print("\n", flush=True)