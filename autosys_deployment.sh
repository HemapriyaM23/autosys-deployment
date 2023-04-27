 #!/bin/ksh

 

#############################################################################
#script Name:  deploy_autosys.ksh
#
# Author:       Abhilash Narayanan - Abhilash.KadampanalNarayanan@pfizer.com
#
# Purpose:      1. Copy the jil files to Informatica server
#                2. Call the Autosys deplyment script in corresponding environment
#                
###################################################################################

 


gitclonebasepath=`pwd`
timestamp=`date '+%Y%m%d%H%M'`

 

#Defining the work folder
workfolder="${gitclonebasepath}/../../../deploylogs"
logfile="${workfolder}/autosyslogfile_${timestamp}.log"
scpfolder="${workfolder}/autosys_scp"
autosyslistfile="${scpfolder}/autosysfile.jil"
deploystatus=0

 

#Paths for list and Autosys Base path
listfile="${gitclonebasepath}/ListFiles/autosys_param.lst"
dos2unix ${listfile}
autosysbasepath="${gitclonebasepath}/Autosys"

 

#Gathering the environment to deploy code
target_branch=`echo "${GITHUB_BASE_REF}"`

 

echo "${timestamp}|INFO Base Reference branch is :${target_branch} " >> $logfile
echo "${timestamp}|INFO Base Reference branch is :${target_branch} "

 

#Cleaning up files from previous run if any
`mkdir -p ${workfolder}`
`mkdir -p ${scpfolder}`
`find ${workfolder} -name "autosyslogfile*.log" -type f -mtime +60 -delete`
`rm -f ${autosyslistfile}`

 

echo "${timestamp}|INFO House keeping before deployment starts " >> $logfile
echo "${timestamp}|INFO House keeping before deployment starts "

 

#Defining the Remote server path
if [ "$target_branch" == "qa-env" ]
then
    servername="amraelp00010826"
    serveruser="cifadm"
    serverfolder="/app/cifadm/cicd_deploy/temp"

    #Defining the autosys specific variables for QA environment
    machine="amrvlp000006807.pfizer.com"
    ftpmachine="amrsoml097.pfizer.com"
    owner="cifadm"
    reponame="infa_repos_cdwsft"
    vvareponame="infa_repos_cdwvvasft"
elif [ "$target_branch" == "main" ]
then
    servername="amraelp00010891"
    serveruser="cifadm"
    serverfolder="/app/cifadm/cicd_deploy/temp"
    ftpmachine="amrndhl552.pfizer.com"

    #Defining the autosys specific variables for Prod environment
    machine="amrvlp000006846.pfizer.com"
    owner="cifadm"
    reponame="infa_repos_cdwsfp"
    vvareponame="infa_repos_cdwsfp"
fi

 

echo "${timestamp}|INFO Environment specific variables set " >> $logfile
echo "${timestamp}|INFO Environment specific variables set "

 

`touch ${autosyslistfile}`

 

# Check to see if list file exist
if test -f "$listfile";
then
    # Gathering the jil files to be copied over to a temporary folder
    for jil in $(cat ${listfile})
    do

 

        # Copying individual JIL files to a combined file
        jilfile="${autosysbasepath}/${jil}"
        `cat ${jilfile} >> ${autosyslistfile}`
        chk_ret_cd5=$?
        if [ $chk_ret_cd5 -ne 0 ];
        then
            echo "${timestamp}|ERROR copying the jil file ${jilfile} " >> $logfile
            echo "${timestamp}|ERROR copying the jil file ${jilfile} "
            deploystatus=$(( deploystatus + 1 ))

        else
            echo "${timestamp}|INFO ${jilfile} copied successfully" >> $logfile
            echo "${timestamp}|INFO ${jilfile} copied successfully"
        fi
    done
else
    echo "${timestamp}|INFO No new JIL scripts to deploy" >> $logfile
    echo "${timestamp}|INFO No new JIL scripts to deploy"
fi

 

if grep -Fq "job" $autosyslistfile
then
    echo "${timestamp}|INFO All new JILs copied" >> $logfile
    echo "${timestamp}|INFO All new JILs copied"
else
    echo "${timestamp}|INFO No new JIL scripts to deploy" >> $logfile
    echo "${timestamp}|INFO No new JIL scripts to deploy"
fi

 

echo "${timestamp}|INFO Update JIL scripts to deploy" >> $logfile
echo "${timestamp}|INFO Update JIL scripts to deploy"

 

# If the jil file have some jobs to be executed

 

if grep -Fq "job" $autosyslistfile
then

 

    `sed -i -e "s/##machine/${machine}/g" ${autosyslistfile}`
    `sed -i -e "s/##reponame/${reponame}/g" ${autosyslistfile}`
    `sed -i -e "s/##vvareponame/${vvareponame}/g" ${autosyslistfile}`
    `sed -i -e "s/##owner/${owner}/g" ${autosyslistfile}`
    `sed -i -e "s/##ftpmachine/${ftpmachine}/g" ${autosyslistfile}`

 

    echo "${timestamp}|INFO Placeholders replaced with actual values" >> $logfile
    echo "${timestamp}|INFO Placeholders replaced with actual values"

 

    #scp files to server as infcomm
    sudo -H -u infcomm scp -q -o StrictHostKeyChecking=no $scpfolder/* $serveruser@$servername:$serverfolder
    chk_ret_cd5=$?
    if [ $chk_ret_cd5 -ne 0 ];
    then
        echo "${timestamp}|ERROR copying the jil file to server:${servername}" >> $logfile
        echo "${timestamp}|ERROR copying the jil file to server:${servername}"
        deploystatus=$(( deploystatus + 1 ))

    else
        echo "${timestamp}|INFO copied the jil file to server:${servername}" >> $logfile
        echo "${timestamp}|INFO copyied the jil file to server:${servername}"
    fi

 


    #Running the JIL command in the Autosys Client machine
    sudo -H -u infcomm ssh -q $serveruser@$servername <<EOF
    jil < "${serverfolder}"/autosysfile.jil 
EOF
    chk_ret_cd5=$?
    if [ $chk_ret_cd5 -ne 0 ];
    then
        echo "${timestamp}|ERROR Autosys JIL failed deployment" >> $logfile
        echo "${timestamp}|ERROR Autosys JIL failed deployment"
        deploystatus=$(( deploystatus + 1 ))

    else
        echo "${timestamp}|INFO Autosys JIL deployed" >> $logfile
        echo "${timestamp}|INFO Autosys JIL deployed"
    fi

 

else
    echo "${timestamp}|INFO No Autosys Artifacts to be deployed" >> $logfile
    echo "${timestamp}|INFO No Autosys Artifacts to be deployed"
fi

 

# See if any steps failed
if [ $deploystatus -ne 0 ];
then
    echo "${timestamp}|ERROR Autosys Deployment script failed" >> $logfile
    echo "${timestamp}|ERROR Autosys Deployment script failed"
    exit 255            
else
    echo "${timestamp}|SUCCESS Autosys Deployment Complete" >> $logfile
    echo "${timestamp}|SUCCESS Autosys Deployment Complete"
    exit 0
fi
