#!/bin/bash
echo -n "Enter app name :"
read appName
echo -n "Enter git folder? /var/repo/${appName}.git: "
read repoName
echo -n "Deploy script file. Located in project root ? run.sh : "
read scriptFile

if [ -z $repoName ]; then
  repoName="/var/repo/${appName}.git"
fi
if [[ ${#repoName} > 4  && ${repoName: -4} != ".git" ]]; then
  echo "Adding .git to end of file name"
  repoName="${repoName}.git"
fi
#create repo dir if not exist
if [[ ! -d $repoName ]]; then
  mkdir -p $repoName
fi
cd $repoName && mkdir "${appName}_SRC_TREE"
if [ -z $scriptFile ]; then
  scriptFile="run.sh"
fi
srcDir="${repoName}/${appName}_SRC_TREE"
git init --bare
cd hooks
echo "#!/bin/sh
git --work-tree=${srcDir} --git-dir=${repoName} checkout -f
sleep 5
chmod +x ${srcDir}/${scriptFile}
export SRCDIR=${srcDir}
. ${srcDir}/${scriptFile} ${srcDir}
" >> post-receive
chmod +x post-receive