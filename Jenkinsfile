

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
		withCredentials([usernamePassword(credentialsId: 'sfaops', passwordVariable: 'pwd', usernameVariable: 'usr')]) {
			sh """
			export Username=\$usr
			export Password=\$pwd
			script/deploy.sh
			"""	
		}
                }
				
        }
    }
}
