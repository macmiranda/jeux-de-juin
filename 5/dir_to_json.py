import os
import sys
import json
rootdir = sys.argv[1]
dict={}
for dir in os.listdir(rootdir):
    if len(os.listdir(os.path.join(rootdir,dir))) > 0: dict[dir]={} 
    for file in os.listdir(os.path.join(rootdir,dir)):
        with open(os.path.join(os.path.join(rootdir,dir),file)) as fp:
            list = [line.rstrip('\n').lower() for line in fp if len(line) > 1]
            r="\n".join(list)
        dict[dir].update({file:r})
print(json.dumps(dict,indent=2,ensure_ascii=False))