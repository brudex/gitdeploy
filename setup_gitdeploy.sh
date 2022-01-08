#!/bin/bash
REPO_DIR=/var/repo
WWW_DIR=/var/www

echo -n "Use the default directories www=$WWW_DIR and repo=$REPO_DIR 'Y/n' :"
read useDirectoryDefaults
if [[ "$useDirectoryDefaults" == "n" ]]; then
  echo -n "Enter www directory :"
  read wwwDir
  WWW_DIR=$wwwDir
  echo -n "Enter repo directory :"
  read repoDir
  REPO_DIR=$repoDir
fi
echo $WWW_DIR;
echo $REPO_DIR;
echo -n "Enter repo name :"
read repoName
echo -n "Enter app name :"
read appName
echo -n "Deploy script file. Located in project root- Default 'run.sh' : "
read scriptFile
if [ -z $scriptFile]; then
  scriptFile="run.sh"
fi
#create repo dir if not exist
if [[ ! -d $REPO_DIR ]]; then
  mkdir -p $REPO_DIR
fi
cd $REPO_DIR
mkdir "${REPO_DIR}/${repoName}.git" && cd "${REPO_DIR}/${repoName}.git"
git init --bare
cd hooks
mkdir -p "${WWW_DIR}/${appName}"
echo "#!/bin/sh
git --work-tree=${WWW_DIR}/${appName} --git-dir=${REPO_DIR}/${repoName}.git checkout -f
sleep 5
chmod +x ${WWW_DIR}/${appName}/${scriptFile}
export SRCDIR=${WWW_DIR}/${appName}
. ${WWW_DIR}/${appName}/${scriptFile}
" >> post-receive
chmod +x post-receive