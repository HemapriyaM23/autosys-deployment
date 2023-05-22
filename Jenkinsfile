

pipeline {
    agent any
    parameters {
        choice choices: ['No', 'Yes'], description: 'Mention if You want to Deploy into Autosys Environment', name: 'Deploy_to_Autosys'     
    }
    stages{
        
        stage ("Deploy to Autosys"){
            when {
                 expression { params.Deploy_to_Autosys == "Yes" }
            }
            steps{
                script{	
			def jilDirectory = 'Autosys'
			def apiEndpoint = 'https://amraelp00011055.pfizer.com:9443/AEWS/jil'
			def failedFiles = [] // List to store failed JIL files
			def successfulFiles = [] // List to store successful JIL files

			// Get a list of JIL files in the directory
			def jilFiles = sh(script: "find ${jilDirectory} -name '*.jil'", returnStdout: true).trim().split('\n')
			echo "jilFiles is: ${jilFiles}"	
			// Iterate over the JIL files and make POST requests
			for (def jilFile in jilFiles) {
				echo "Processing file: $jilFile"
				withCredentials([usernamePassword(credentialsId: 'sfaops', passwordVariable: 'pwd', usernameVariable: 'usr')]) {

					def response = sh(script: """curl -X POST -H 'Content-Type: text/plain' --upload-file '${jilFile}' ${apiEndpoint} -k --user \"${usr}:${pwd}\" -i""", returnStdout: true)

				// Print the response
				echo "Response: $response"

				// Extract the value of the "status" field from the JSON response
				def statusMatch = response =~ /"status"\s*:\s*"(\w+)"/
				if (statusMatch) {
					def status = statusMatch[0][1]
					if (status == 'failed') {
						echo "Deployment of $jilFile failed"
						failedFiles.add(jilFile) // Add failed JIL file to the list
					} else {
						echo "Deployment of $jilFile successful"
						successfulFiles.add(jilFile) // Add successful JIL file to the list
						}
					} else {
						echo "Unable to determine the status from the response"
						failedFiles.add(jilFile) // Assume failure if status extraction fails
						}

					}

				}
				if (failedFiles) {
					echo "Failed JIL files: $failedFiles"
					currentBuild.result = 'FAILURE' // Mark the Jenkins job as failed
					error("Deployment failed for some JIL files") // Mark the stage as failed
				} else {
					echo "All JIL files deployed successfully"
				}

				echo "Successful JIL files: $successfulFiles"		
		
												 				
                }
			}	
        }
    }
}
