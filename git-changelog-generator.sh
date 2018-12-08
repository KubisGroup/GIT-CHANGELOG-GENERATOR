#!bash

# = = = FOREGROUND COLOR = = =
BLACK=`tput setaf 0`;
RED=`tput setaf 1`;
GREEN=`tput setaf 2`;
ORANGE=`tput setaf 3`; #LOGO KUBIS
STEELBLUE=`tput setaf 4`; #LOGO GROUP
PURPLE=`tput setaf 5`; #LINES
BLUE=`tput setaf 6`; #notification
WHITE=`tput setaf 7`; #NORMAL TEXT
NO_COLOR=`tput setaf 8`; #NO SET
RESET_COLOR=`tput setaf 9`; #RESER COLOR TEXT

# = = = Settings = = = 
fileName="CHANGELOG"
lastDate=`ls -l $fileName | awk '{print $6,  $7, $8}'`
actualDate=`git log -1 --format="%at" | xargs -I{} date -d @{} +'%b%_d %H:%M'`
appversion="1.0.0"

# = = = GIT = = =
gitVersion=`git log --pretty="%h" -n1 HEAD | awk '{print $0}'`
gitCommitCount=`git rev-list HEAD --count | awk '{print $0}'`
# = = = Version counting = = = 
path=`printf "%.0f" $(($gitCommitCount % 1000));`;
minor=`printf "%.0f" $((($gitCommitCount / 1000) % 1000));`;
major=`printf "%.0f" $(($gitCommitCount / 1000000));`;

# = = = TEXTS = = =
templateVersion=`printf "%s.%s.%s" $major $minor $path;`
welcomeText="Kubis Group CHANGELOG ($appversion)"
consoleWelcomeText="${ORANGE}Kubis ${STEELBLUE}Group ${WHITE}CHANGELOG ($appversion)"
consoleVersionText="GIT version ${BLUE}$templateVersion${WHITE} (${GREEN}$gitVersion${WHITE})${WHITE}"
versionText="GIT version $templateVersion ($gitVersion)"

# = = = FILE HEADER = = = 
function head() {
    echo "$welcomeText" > $fileName
    echo "_____" >> $fileName
}

# = = = FILE FOOTER = = =
function footer() {
    echo "_____" >> $fileName
    git log --format='-- %aN (%aE)' | sort -u  >> $fileName
    echo "$versionText"  >> $fileName

}

echo "$consoleWelcomeText"
#printf "\tfile date: $lastDate | git date: $actualDate\n" # uncomment if do you want know this

if [[ ($lastFileCommit != $gitVersion) ]]; then
    # add commit 
    if [[ ($lastDate < $actualDate) ]]; then
        echo "${PURPLE}ADD CHANGELOG to GIT${WHITE}";
        git add $filename;
        git commit -m "autogenerating CHANGELOG and update version to $templateVersion";
    fi
    
    # generate changelog
    echo "${ORANGE}generating CHANGELOG${WHITE}"
    head;
    git log --format='    * %s (%aD)' --no-merges >> $fileName
    footer;
else
    echo "${GREEN}$fileName is actual${WHITE}"
fi
echo "Now we have a $consoleVersionText"

# = = = VERSION BANNER = = =
if command -v figlet>/dev/null; then
    #Show banner
    figlet "version $templateVersion"
else
    # = = = FOR DEBIAN/UBUNTU SYSTEMS = = =
    # = = = change it for right install into your system = = =
    sudo apt-get -y install figlet;
fi

