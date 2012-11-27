#!/usr/bin/env python 
import os 
import socket
import sys
import pwd
import time
import re

def release():
	for distro in ['redhat','debian','gentoo','slackware']:
		try:
			f = open('/etc/'+distro+'-release')
			return f.read().rstrip()
			close(f)
		except:
			continue	
	raise "Couldn't find a distro" 

#def sysdisk():
	# lame!
	# return os.system('df --si /')	

def meminfo():
	try:
		f = open('/proc/meminfo')
		return str(int(f.readline().rstrip().split()[1])/1024/1024 + 1)
		close(f)
	except:
		raise "Couldnt get RAM info"	

def rtime():
	try:
		f = os.popen('rdate nist1-chi.ustiming.org')
		return " ".join(f.read().split()[2:9])
	except:
		raise "Couldn't check against remote time server"

print "\n#### Basic Information ####"
print "Running as user:     " + pwd.getpwuid(os.getuid())[0] 
print "Running on host:     " + socket.gethostname()
print "Working directory:   " + os.getcwd()

print "\n### Expanded Information ###"
print "Kernel release:      " + os.uname()[2] 
print "System arch:         " + os.uname()[4]
print "Python version:      " + " ".join(sys.version.split()) 
print "Distro release:      " + release() 
print "System time:         " + time.asctime(time.localtime(time.time())) 
print "Remote time (NIST):  " + rtime()
print "Total RAM:           " + meminfo() + "GB" 
print "Load avg. (15 min):  " + str(round(os.getloadavg()[2]))
