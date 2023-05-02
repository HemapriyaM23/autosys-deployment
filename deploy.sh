 #!/bin/ksh



gitclonebasepath=`pwd`
echo "into sh"

#Defining the work folder
workfolder="${gitclonebasepath}/../../../deployfolder"
echo "${workfolder}"
scpfolder="${workfolder}/autosys_scp"
autosyslistfile="${scpfolder}/autosysfile.jil"
echo "${autosyslistfile}"
deploystatus=0


#Paths for list and Autosys Base path
listfile="${gitclonebasepath}/ListFiles/autosys_param.lst"
echo "ls ${listfile}"
dos2unix ${listfile}
autosysbasepath="${gitclonebasepath}/Autosys"

`touch ${autosyslistfile}`
echo "autosyslistfile created"
