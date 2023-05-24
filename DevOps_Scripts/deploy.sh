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
    if [ "${target_branch}" = "dev" ]; then
        # Replace string in the JIL file for the "test" branch
        sed -i 's/insert/update/' "${jilFile}"
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
