

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

                        sh "ssh srvamr-sfaops@amer@euz1nldw110 'autostatus -m euz1nldw110'"
                        //sh "scp -r test.jil srvamr-sfaops@amer@euz1nldw110:/tmp"
                        sh "pwd"
          
                        }
                }
        }
    }
}
