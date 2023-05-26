#!/bin/bash

failedFiles=() # Array to store failed JIL files
successfulFiles=() # Array to store successful JIL files

USERNAME="${USERNAME}"
PASSWORD="${PASSWORD}"

target_branch=${GIT_BRANCH}
echo "target branch is : ${target_branch}"

# Get a list of JIL files in the directory
jilFiles=$(find ${jilDirectory} -name '*.jil')

# Iterate over the JIL files and make POST requests
for jilFile in ${jilFiles}; do
    echo "Processing file: ${jilFile}"
    if [ "${target_branch}" = "test" ]; then
        # Replace string in the JIL file for the "test" branch
        sed -i 's/d2compaus/t2compaus/g' "${jilFile}"
        sed -i 's/D2COMPAUS/T2COMPAUS/g' "${jilFile}"
        sed -i 's/amrvopsfa000001/amrvotpa000001/g' "${jilFile}"
        sed -i 's/pa_matillion_master.ksh PALIGN DEV PFZALGN_DEV PFZALGN_DEV/pa_matillion_master.ksh PALIGN TEST PFZALGN_TEST PFZALGN_TEST/g' "${jilFile}"
        sed -i 's/pa_postgresql_master.ksh PFZALGN DEV/pa_postgresql_master.ksh PFZALGN TEST/g' "${jilFile}"
        sed -i 's/pa_snowflake_master.ksh cometl_pa_ods_dev/pa_snowflake_master.ksh cometl_pa_ods_test/g' "${jilFile}"
    fi
    if [ "${target_branch}" = "sit" ]; then
        # Replace string in the JIL file for the "test" branch
        sed -i 's/t2compaus/s2compaus/g' "${jilFile}"
        sed -i 's/T2COMPAUS/S2COMPAUS/g' "${jilFile}"
        sed -i 's/amrvotpa000001/amrvoupa000001/g' "${jilFile}"
        sed -i 's/pa_matillion_master.ksh PALIGN TEST PFZALGN_TEST PFZALGN_TEST/pa_matillion_master.ksh PALIGN SIT PFZALGN PFZALGN/g' "${jilFile}"
        sed -i 's/pa_postgresql_master.ksh PFZALGN TEST/pa_postgresql_master.ksh PFZALGN SIT/g' "${jilFile}"
        sed -i 's/pa_snowflake_master.ksh cometl_pa_ods_test/pa_snowflake_master.ksh cometl_pa_ods/g' "${jilFile}"
    fi
    if [ "${target_branch}" = "uat" ]; then
        # Replace string in the JIL file for the "test" branch
        sed -i 's/s2compaus/u2compaus/g' "${jilFile}"
        sed -i 's/S2COMPAUS/U2COMPAUS/g' "${jilFile}"
        sed -i 's/amrvoupa000001/amrvospa000002/g' "${jilFile}"
        sed -i 's/a_matillion_master.ksh PALIGN SIT PFZALGN PFZALGN/pa_matillion_master.ksh PALIGN UAT PFZALGN_STG PFZALGN_STG/g' "${jilFile}"
        sed -i 's/pa_postgresql_master.ksh PFZALGN SIT/pa_postgresql_master.ksh PFZALGN UAT/g' "${jilFile}"
        sed -i 's/pa_snowflake_master.ksh cometl_pa_ods/pa_snowflake_master.ksh cometl_pa_stg/g' "${jilFile}"
    fi
    if [ "${target_branch}" = "prod" ]; then
        # Replace string in the JIL file for the "test" branch
        sed -i 's/u2compaus/p2compaus/g' "${jilFile}"
        sed -i 's/U2COMPAUS/P2COMPAUS/g' "${jilFile}"
        #sed -i 's/amrvoupa000001/amrvospa000002/g' "${jilFile}"
        sed -i 's/pa_matillion_master.ksh PALIGN UAT PFZALGN_STG PFZALGN_STG/pa_matillion_master.ksh PALIGN PROD PFZALGN PFZALGN/g' "${jilFile}"
        sed -i 's/pa_postgresql_master.ksh PFZALGN UAT/pa_postgresql_master.ksh PFZALGN PROD/g' "${jilFile}"
        sed -i 's/pa_snowflake_master.ksh cometl_pa_stg/pa_snowflake_master.ksh cometl_pa_prod/g' "${jilFile}"
    fi
    # Perform the curl command
    response=$(curl -X POST -H 'Content-Type: text/plain' --upload-file "${jilFile}" ${apiEndpoint} -k --user "${USERNAME}:${PASSWORD}" -i)
    
    # Print the response
    echo "Response: ${response}"
    
    # Extract the value of the "status" field from the JSON response
    statusMatch=$(echo "${response}" | grep -o '"status"\s*:\s*"[^"]*"' | awk -F'"' '{print $4}')
    
    if [ -n "${statusMatch}" ]; then
        if [ "${statusMatch}" = "failed" ]; then
            echo "Deployment of ${jilFile} failed"
            failedFiles+=("${jilFile}") # Add failed JIL file to the array
        else
            echo "Deployment of ${jilFile} successful"
            successfulFiles+=("${jilFile}") # Add successful JIL file to the array
        fi
    else
        echo "Unable to determine the status from the response"
        failedFiles+=("${jilFile}") # Assume failure if status extraction fails
    fi
done

if [ ${#failedFiles[@]} -gt 0 ]; then
    echo "Failed JIL files: ${failedFiles[@]}"
    exit 1 # Exit with a non-zero status to mark the script as failed
else
    echo "All JIL files deployed successfully"
fi

echo "Successful JIL files: ${successfulFiles[@]}"
