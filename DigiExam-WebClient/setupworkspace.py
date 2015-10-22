#! /usr/bin/python

import urllib
import zipfile
import os.path

PROJECT = "github.com/digiexam/DigiExam-Web"

GAE_DOWNLOAD_URL = "https://storage.googleapis.com/appengine-sdks/featured/go_appengine_sdk_darwin_amd64-1.9.8.zip"
GAE_TEMP_LOCATION = "/tmp/go_appengine_sdk_darwin_amd64-1.9.8.zip"
GAE_UNZIP_DIRECTORY = "/Applications/"
GAE_PATH = GAE_UNZIP_DIRECTORY + "go_appengine/"

WORKSPACE_DIRECTORY = os.path.dirname(os.path.realpath(__file__))
PROJECT_FULL_PATH = WORKSPACE_DIRECTORY + "/src/" + PROJECT


def unzip(zipFilePath, destDir):
	zfile = zipfile.ZipFile(zipFilePath)
	for name in zfile.namelist():
		(dirName, fileName) = os.path.split(name)
		if fileName == '':
			# directory
			newDir = destDir + '/' + dirName
			if not os.path.exists(newDir):
				os.mkdir(newDir)
		else:
			# file
			fd = open(destDir + '/' + name, 'wb')
			fd.write(zfile.read(name))
			fd.close()
	zfile.close()

print ""
print "This script will setup the following directories:"
print "GAE-Go dev server at: " + GAE_PATH
print "Go Workspace (gopath) at: " + WORKSPACE_DIRECTORY
print ""

print "Downloading App Engine..."
urllib.urlretrieve(GAE_DOWNLOAD_URL, GAE_TEMP_LOCATION)

print "Unzipping App Engine..."
unzip(GAE_TEMP_LOCATION, GAE_UNZIP_DIRECTORY)

print "Setting execute permission..."
os.system("chmod -R 770 " + GAE_PATH)

print "Adding App Engine and Go workspace environment variables to ~/.bash_profile ..."
with open(os.path.expanduser("~/.bash_profile"), "r+") as profile:
	if "Added by go workspace setup" in profile.read():
		print "Skipping, found that they where already added."
	else:
		profile.write("\n\n")
		profile.write("# Added by go workspace setup \n")
		profile.write("export PATH=" + GAE_PATH + ":$PATH \n")
		profile.write("export GOPATH=" + WORKSPACE_DIRECTORY + "\n")


if not os.path.isdir(PROJECT_FULL_PATH):
	print "Creating directory for project: " + PROJECT_FULL_PATH
	os.makedirs(PROJECT_FULL_PATH)
else:
	print "Directory already exists:" + PROJECT_FULL_PATH

REPO_ADDR = "https://" + PROJECT + ".git"
os.system("git clone " + REPO_ADDR + " " + PROJECT_FULL_PATH)

print ""
print ""
print "Your workspace and project has been setup!"
print "Go Workspace: " + WORKSPACE_DIRECTORY
print "Project folder: " + PROJECT_FULL_PATH
print ""
print "Just restart the terminal or reload the bash profile with 'source ~/.bash_profile' ."
print ""
