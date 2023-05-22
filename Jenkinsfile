

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
		sh 'pwd'
		sh 'chmod +x script/deploy.sh'    
		sh 'ls -la script/'    
		//sh 'script/deploy.sh'
												 				
                }
				
        }
    }
}
