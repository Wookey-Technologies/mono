#!/usr/bin/awk BEGIN{a=ARGV[1];for(i=1;i<ARGC;i++){b=b"\t"ARGV[i];}sub(/[^\/]+$/,"../Python/Linux/python",a);system(a""b)}
import sys
import os
import subprocess
import traceback

if os.path.exists(os.getcwd() + "/ThirdPartyBuilder/LindenBuilder.py"):
    sys.path.insert(0, os.path.realpath(os.getcwd() + "/ThirdPartyBuilder/"))
    from LindenBuilder import main,LindenBuilder
elif os.path.exists(os.getcwd() + "/../../Buildtools/ThirdPartyBuilder/LindenBuilder.py"):
    sys.path.insert(0, os.path.realpath(os.getcwd() + "/../../Buildtools/ThirdPartyBuilder/"))
    from LindenBuilder import main,LindenBuilder
else:
    sys.exit("ERROR: Need to sync ThirdPartyBuilder scripts either under current directory or in original BuildTools path")


class MonoBuilder(LindenBuilder):
    def __init__(self, options):
        LindenBuilder.__init__(self, options)

    def build_win64(self):
        try:
            for file in self.files:
                if os.path.exists(os.path.abspath(file)):
                    os.remove(os.path.abspath(file))

            os.chdir("Linden")
            subprocess.check_call("msbuild.exe build.target /p:PlatformToolset=v140", shell=True)
            os.chdir("../")
        except:
            print( "EXCEPTION: %s\n%s" % (sys.exc_info()[1],traceback.format_exc()) )
            os.chdir("../")
            return False
        return True

    def build_linux(self):
        try:
            os.chdir("Linden")
            subprocess.check_call("/bin/bash linux_build.sh", shell=True)
            os.chdir("../")
        except:
            print( "EXCEPTION: %s\n%s" % (sys.exc_info()[1],traceback.format_exc()) )
            os.chdir("../")
            return False
        return True

if __name__ == "__main__":
    sys.exit(main(MonoBuilder))