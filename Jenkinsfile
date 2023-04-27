

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

                        sh "ssh srvamr-sfaops@amer@devserver"
                        sh "scp -r test.jil srvamr-sfaops@amer@devserver:/tmp"
          
                        }
                }
        }
    }
}
