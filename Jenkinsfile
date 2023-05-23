

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
		
		sh 'chmod +x script/deploy.sh' 
		withCredentials([usernamePassword(credentialsId: 'sfaops', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) {
			env.USERNAME = USERNAME
        		env.PASSWORD = PASSWORD
			sh "script/deploy.sh"
		}
                }
				
        }
    }
}
