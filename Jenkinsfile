

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
                        //withCredentials([usernamePassword(credentialsId: 'sfaops', passwordVariable: 'pwd', usernameVariable: 'usr')]) {
                        //sh " curl -u \"${usr}:${pwd}\" -k -X GET https://amraelp00011055.pfizer.com:9443/AEWS/job/d2compaus_pa_dependency_job1
			    //def f= 'Autosys/Autosys_test.jil'   
			    //sh "curl -X POST -H 'Content-Type: text/plain' --upload-file '${f}' https://amraelp00011055.pfizer.com:9443/AEWS/jil -k --user \"${usr}:${pwd}\" -i  "  
			//}		
						
			def jilDirectory = 'Autosys'
			def apiEndpoint = 'https://amraelp00011055.pfizer.com:9443/AEWS/jil'

			// Get a list of JIL files in the directory
			def jilFiles = sh(script: "find ${jilDirectory} -name '*.jil'", returnStdout: true).trim().split('\n')
			echo "jilFiles is: ${jilFiles}"	
			// Iterate over the JIL files and make POST requests
			for (def jilFile in jilFiles) {
				echo "Processing file: $jilFile"
				// Read the file content
				//def jilContent = readFile(file: jilFile.trim()).trim()
				//echo "jilContent is: ${jilContent}"	
				// Make the POST request using curl
				//sh "sudo yum install -y jq"
				withCredentials([usernamePassword(credentialsId: 'sfaops', passwordVariable: 'pwd', usernameVariable: 'usr')]) {
				//def response = sh(script: "curl -u \"${usr}:${pwd}\" -k -X GET https://amraelp00011055.pfizer.com:9443/AEWS/job/d2compaus_pa_dependency_job1")
				//def response = sh(script: "curl -X POST -H 'Content-Type: text/plain' --upload-file '${jilFile}' ${apiEndpoint} -k --user \"${usr}:${pwd}\" -i" , returnStdout: true).trim()
				def encodedPassword = sh(script: 'printf "%s" "$pwd" | jq -s -R -r @uri', returnStdout: true).trim()
				sh """curl -X POST -H 'Content-Type: text/plain' --upload-file '${jilFile}' ${apiEndpoint} -k --user '${usr}:${encodedPassword}' -i"""
				}

				// Display the response
				//echo "Response:"
				//echo response
				//echo "------------------------------------"
				// Check the response for success
				//if (response.contains('SUCCESS')) {
				    //echo "Deployment successful for file: ${jilFile}"
				//} else {
				   // echo "Deployment failed for file: ${jilFile}"
				    //error("Deployment failed for file: ${jilFile}")
				//}
				
                    }                      
                        
          
                        }
                }
        }
    }
}
