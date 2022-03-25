#!/usr/bin/env python3

import os
import sys
import subprocess

if len(sys.argv) > 1:
    dirs = [os.path.abspath(d) for d in sys.argv[1:]]
else:
    dirs = [os.getcwd()]

for work_dir in dirs:
    result_os = subprocess.run(["git", "-C", work_dir, "status", "-s"], capture_output=True)
    if result_os.returncode:
        print(f"'{work_dir}' is not Git repository!")
    else:
        for record in result_os.stdout.decode("utf8").splitlines():
            status, file = record.split()
            if status == 'M':
                print(work_dir+"/"+file)
