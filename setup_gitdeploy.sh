#!/bin/bash
echo -n "Enter repo name :"
read repoName
echo "Enter app name : "
read appName
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
chmod +x /var/www/${appName}/run.sh
export SRCDIR=/var/www/${appName}
. /var/www/${appName}/run.sh
" >> post-receive
chmod +x post-receive