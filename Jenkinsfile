

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

		sh '/var/lib/jenkins/workspace/dbox_test_autosys_deployment_dev/script/deploy.sh'
												 				
                }
				
        }
    }
}
