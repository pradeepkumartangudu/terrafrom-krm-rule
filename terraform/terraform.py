import argparse
import os
import sys
import json
from subprocess import call

# Make sure to place your credentials inside credentials.json
credentials = None 

parser = argparse.ArgumentParser(
   description='Apply or test the terraform plans against one or many environments.')
parser.add_argument('--action', type=str, nargs='?',
                   help='test or apply. (default: test)', default="test")
parser.add_argument('--env', metavar='environment', type=str, nargs='+',
                   help='name of account(s) or "all" (default: all)', default=["all"])
parser.add_argument('--debug', type=bool, nargs='?',
                   help='optional debug mode', default=False)

args = parser.parse_args()
print(args.action + " " + ", ".join(args.env))

def getCredentials(): # Validate credentials.json
    with open('credentials.json') as json_data:
        global credentials
        credentials = json.load(json_data)

def validateDirs():  # Validate inputs
    for dir in args.env:
        # Dir exsists
        if os.path.isdir(dir) != True:
            sys.exit("Can't find directory for " + dir)
        # Has Credentials
        if credentials[dir] == None:
            sys.exit("Cant find credentials for " + dir)

def getAllEnvs():  # Walk the dir to build a list of environments to use
    dirs = filter(os.path.isdir, os.listdir(os.getcwd()))
    result = []
    for item in dirs:
        if item[0] == "_":
            continue
        if item[0] == ".":
            continue
        result.append(item)
    for dir in result:
        if credentials[dir] == None:
            sys.exit("Cant find credentials for " + dir)
    return result

# Main
getCredentials()
if args.env[0] != 'all':
    validateDirs()
    envs = args.env
else:
    envs = getAllEnvs()

basePath = os.path.dirname(os.path.realpath(__file__))
for env in envs:
    print "Running " + env
    os.chdir(basePath + "/" + env)

    keyText = '-var "access_key=' + \
        credentials[env]["access_key"] + '" -var "secret_key=' + \
        credentials[env]["secret_key"] + '"'

    backendText = ' -backend-config "access_key=' + \
        credentials[env]["access_key"] + '" -backend-config "secret_key=' + \
        credentials[env]["secret_key"] + '"'
    
    return_code = call('terraform init ' + keyText + backendText, shell=True)
    if return_code != 0:
        sys.exit("There was an issue initializing terraform")
    if args.action == "test":
        return_code = call('terraform plan ' + keyText, shell=True)
    if return_code != 0:
        sys.exit("There was an planning terraform")
    if args.action == "apply":
        return_code = call('terraform apply ' + keyText, shell=True)
    if return_code != 0:
        sys.exit("There was an issue applying terraform")
