#!/usr/bin/env python

import glob
import re
import subprocess
import sys

dockerfiles = glob.glob("*/*/Dockerfile")
pattern = '^(.+)\/(.+)\/'
buildImage = sys.argv[1] if len(sys.argv) >= 2 else None
buildTag = sys.argv[2] if len(sys.argv) >= 3 else None

for dockerfile in dockerfiles:
    a = re.search(pattern, dockerfile)
    image = a.group(1)
    tag = a.group(2)

    if buildImage is not None and buildImage != image:
        continue

    if buildTag is not None and buildTag != tag:
        continue

    print("Building {}:{}".format(image, tag))
    process = subprocess.Popen([
        "docker",
        "build",
        "-t",
        "{}:{}".format(image, tag),
        "{}/{}".format(image, tag)
    ], stdout=subprocess.PIPE)

    while True:
        output = process.stdout.readline()
        if output == b'' and process.poll() is not None:
            break
        if output:
            print(str(output.strip(), 'utf-8'))

    print("Created {}:{}".format(image, tag))
