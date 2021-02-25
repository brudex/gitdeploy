#!/bin/bash
echo -n "Enter repo name :"
read repoName
echo -n "Enter app name :"
read appName
echo -n "Deploy script file. Located in project root- Default 'run.sh' : "
read scriptFile
if [ -z $scriptFile]; then
  scriptFile="run.sh"
fi
cd /var
#create repo dir if not exist
if [[ ! -d repo ]]; then
  mkdir repo
fi
cd repo
mkdir "${repoName}.git" && cd "${repoName}.git"
git init --bare
cd hooks
mkdir -p "/var/www/${appName}"
echo "#!/bin/sh
git --work-tree=/var/www/${appName} --git-dir=/var/repo/${appName}.git checkout -f
sleep 5
chmod +x /var/www/${appName}/${scriptFile}
export SRCDIR=/var/www/${appName}
. /var/www/${appName}/${scriptFile}
" >> post-receive
chmod +x post-receive