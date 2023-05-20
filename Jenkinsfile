

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

				withCredentials([usernamePassword(credentialsId: 'sfaops', passwordVariable: 'pwd', usernameVariable: 'usr')]) {
				
					def response = sh(script: "curl -X POST -H 'Content-Type: text/plain' --upload-file '${jilFile}' ${apiEndpoint} -k --user \"${usr}:${pwd}\" -i" , returnStdout: true).trim()
				
					//sh """curl -X POST -H 'Content-Type: text/plain' --upload-file '${jilFile}' ${apiEndpoint} -k --user \"${usr}:${pwd}\" -i"""
					// Check if the response contains a success indicator (modify this condition based on your specific response format)
        				if (response.contains('success')) {
            					echo "Operation successful"
            					currentBuild.result = 'SUCCESS' // Update Jenkins job as success
        				} else {
            					echo "Operation failed"
            					currentBuild.result = 'FAILURE' // Update Jenkins job as failed
        				}
        
					// Print the response
					//echo "Response: $response"

				}
				
                    }                      
                        
          
                        }
                }
        }
    }
}
