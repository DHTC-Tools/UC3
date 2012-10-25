#!/usr/bin/python

import optparse, os, sys, tempfile, ConfigParser, getpass, re

VERSION = '0.02'


def set_chirp_acls(directory, acl = 'r'):
  """
  Check acls for a directory and set it if needed
  """
  if not os.path.exists(directory) or not os.path.isdir(directory):
    return False
  acl_file = os.path.join(directory, '.__acl')
  user = getpass.getuser()
  acl_string = 'rl'
  if acl == 'w':
    acl_string = 'rwlda'
  if not os.path.exists(acl_file):
    acl_perms = "unix:%s rwlda\n" % (user)
    open(acl_file, 'w').write(acl_perms)
    return True
  buf = open(acl_file).read()
  match = re.search("unix:%s\s+([a-z]*)\s" % user, buf)
  if match is None:
    buf += "unix:%s %s\n" % (user, acl_string)
  elif acl in match.group(1):
    return True
  else:
    buf = re.sub("unix:%s\s+([a-z]*)\s" % user,  "unix:%s rwlda" % user, buf)
  
  open(acl_file, 'w').write(buf)
  return True  
  

def prefix_base(base_dir, path):
  
  if path == '/':
    return base_dir
  elif path[0] == '/':
    return os.path.join(base_dir, path[1:])
  return os.path.join(base_dir, path)
  
def get_chirp_host():
  """
  Get chirp host information, starting chirp if necessary
  """
  chirp_dir = os.path.expanduser('~/.chirp')
  if not os.path.exists(os.path.join(chirp_dir, 'chirp_running')):
    os.system('/usr/local/bin/chirp start')
  port = open(os.path.join(chirp_dir, 'chirp.port')).read().strip()
  return "uc3-data.uchicago.edu:%s" % port
  
  
def generate_xrootd_args(config):
  """
  Generate xrootd specific arguments for parrot_run based on config file
  """
  return ""

def generate_cvmfs_args(config):
  """
  Generate cvmfs specific arguments for parrot_run based on config file
  """
  args = " -r '<default-repositories>"

  if not config.has_section('CVMFS'):
    return ""
  
  repo_num = 1
  while True:
    repo_opt = "repo%s" % repo_num
    if not config.has_option('CVMFS', repo_opt):
      # no more repos to add
      args += "' "
      break
    args += " %s:%s" % (config.get('CVMFS', repo_opt), 
                        config.get('CVMFS', "%s_options" % repo_opt))
    
  return args
  
if __name__ == '__main__':
  parser = optparse.OptionParser(usage='Usage: %prog [options] arg1 arg2', 
                                 version='%prog ' + VERSION)
  
  parser.add_option('-c',
                    '--config-file',
                    action='store',
                    dest='config_file',
                    default='',
                    help='Configuration file')
  
  (options, args) = parser.parse_args()
  
  if options.config_file == '':
    parser.exit(msg='Must give a config file')
  
  
  if not os.path.exists(options.config_file) or not os.path.isfile(options.config_file):
    sys.stderr.write("Config file %s not found, exting...\n" % options.config_file)
    sys.exit(1)
  
  config = ConfigParser.SafeConfigParser()
  config.read(options.config_file)
  
  if config.has_option('Directories', 'read'):
    read_directories = config.get('Directories', 'read').split(',')
    read_directories = map(lambda x: x.strip(), read_directories)
  else:
    read_directories = ''
  
  if config.has_option('Directories', 'write'):
    write_directories = config.get('Directories', 'write').split(',')
    write_directories = map(lambda x: x.strip(), write_directories)
  else:
    write_directories = ''
  
  if config.has_option('Parrot', 'location') and config.get('Parrot', 'location') != '':
    parrot_url = config.get('Parrot', 'location')
  else:
    parrot_url = 'http://itbv-web.uchicago.edu/parrot.tar.gz'
    
  if not config.has_option('Application', 'script'):
    sys.stderr.write("Must give an script to run\n")
    sys.exit(1)

  base_dir = config.get('Directories', 'chirp_base')
  for directory in map(lambda x:  prefix_base(base_dir, x), read_directories):
    if not set_chirp_acls(directory, 'r'):
      sys.stderr.write("Can't set read acl for %s\n" % directory)
      sys.exit(1)
  
  for directory in map(lambda x:  prefix_base(base_dir, x), write_directories):
    if not set_chirp_acls(directory, 'w'):
      sys.stderr.write("Can't set write acl for %s\n" % directory)
      sys.exit(1)
  
  chirp_host = get_chirp_host()
  ticket_call = "chirp %s ticket_create -output myticket.ticket -bits 1024 -duration 86400 " % chirp_host
  
  for directory in read_directories:
    ticket_call += " %s rl " % directory
  for directory in write_directories:
    ticket_call += " %s rwl " % directory
  
  retcode = os.system(ticket_call)
  if os.WEXITSTATUS(retcode) != 0:
    sys.stderr.write("Can't create ticket\n")
  #  sys.exit(1)  
  ticket = open('myticket.ticket').read()
  os.unlink('myticket.ticket')
  
  
  script_contents = "#!/bin/bash\n"
  script_contents += "curr_dir=`cwd`\n"
  script_contents += "ticket='\n%s\n'\n" % ticket
  script_contents += "temp_directory='%s'\n" % tempfile.mktemp()
  script_contents += '''
  mkdir $temp_directory
  cd $temp_directory
  echo "$ticket" > chirp.ticket'''
  script_contents += "\nwget %s\n" % parrot_url
  script_contents += "tar xzf %s \n" % parrot_url.split('/')[-1] 
  if config.has_option('Application', 'location') and config.get('Application', 'location') != '':
    script_contents += "wget %s\n" % config.get('Application', 'location')
    script_contents += "tar xzf %s\n" % config.get('Application', 'location').split('/')[-1]
  arguments = ''
  if config.has_option('Application', 'arguments'):
    arguments = config.get('Application', 'arguments')
  cvmfs_arguments = generate_cvmfs_args(config)
  xrootd_arguments = generate_xrootd_args(config)
  script_contents += "export CHIRP_MOUNT=/chirp/%s\n" % chirp_host
  script_contents += "./parrot/bin/parrot_run -a ticket -i ./chirp.ticket"
  script_contents += "%s %s" % (cvmfs_arguments, xrootd_arguments)
  script_contents +=  "%s %s $@\n" % (config.get('Application', 'script'), arguments)  
  script_contents += "cd $curr_dir\n"
  script_contents += "rm -fr $temp_directory"
  open('job_script.sh', 'w').write(script_contents)
