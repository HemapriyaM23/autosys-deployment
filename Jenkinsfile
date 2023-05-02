

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

                        //sh 'ls -l ./script'
                        
                        sh "ssh srvamr-palign@amer@amrvopsfa000001 'ls /opt/CA/WorkloadAutomationAE/autosys'"
                        //sh "scp -r test.jil srvamr-sfaops@amer@amrvopsfa000001:/tmp"
                        sh "ssh srvamr-palign@amer@amrvopsfa000001 'jil < /tmp/test.jil'"

                        sh "pwd"
          
                        }
                }
        }
    }
}
