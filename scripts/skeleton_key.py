#!/usr/bin/python

import optparse, os, sys, tempfile

VERSION = '0.02'
parser = optparse.OptionParser(usage='Usage: %prog [options] arg1 arg2', 
                               version='%prog ' + VERSION)

parser.add_option('-r',
                  '--read',
                  action='store',
                  dest='read',
                  default='',
                  help='Allow read only access to these directories')
parser.add_option('-w',
                  '--write',
                  action='store',
                  dest='write',
                  default='',
                  help='Allow write access to these directories')
parser.add_option('-e',
                  '--exec',
                  action='store',
                  dest='script_name',
                  default='',
                  help='Script to run')
(options, args) = parser.parse_args()

if options.read != '':
  read_dirs = options.read.split(',')
  for dir in read_dirs:
    if not os.path.exists(dir):
      sys.stderr.write("%s does not exist, please check argument to -r\n" % dir )
    else:
      
else:
  read_dirs = []

if options.read != '':
  write_dirs = options.write.split(',')
  for dir in write_dirs:
    if not os.path.exists(dir):
      sys.stderr.write("%s does not exist, please check argument to -w\n" % dir )
else:
  write_dirs = []

for dir in read_dirs:
  acl_script = "parrot_run parrot_setacl %s unix:user rl" % dir
  retcode = os.system(acl_script)
  if os.WEXITSTATUS(retcode) != 0:
    sys.stderr.write("Can't set read acl for %s\n" % dir )
    sys.exit(1)  

for dir in write_dirs:
  acl_script = "parrot_run parrot_setacl %s unix:user rwl" % dir
  retcode = os.system(acl_script)
  if os.WEXITSTATUS(retcode) != 0:
    sys.stderr.write("Can't set write acl for %s\n" % dir )
    sys.exit(1)  

ticket_call = "chirp uc3-data.uchicago.edu ticket_create -output myticket.ticket -subject unix:user -bits 1024 -duration 86400 "

for dir in read_dirs:
  ticket_call += " %s rl "
for dir in write_dirs:
  ticket_call += " %s rwl "

retcode = os.system(ticket_call)
if os.WEXITSTATUS(retcode) != 0:
  sys.stderr.write("Can't create ticket\n")
#  sys.exit(1)  
ticket = open('myticket.ticket').read()
os.unlink('myticket.ticket')

script_contents = "#!/bin/bash\n"
script_contents += "ticket=<<EOF\n%s\nEOF\n" % ticket
script_contents += "temp_dir='%s'\n" % tempfile.mktemp()
script_contents += '''
mkdir $temp_dir
cd $temp_dir
echo $ticket > chirp.ticket
wget http://itbv-web.uchicago.edu/parrot.tar.gz
tar xvzf parrot.tar.gz
./parrot/bin/parrot_run -a ticket ./chirp.ticket %s
''' % options.script_name

open('job_script.sh', 'w').write(script_contents)
