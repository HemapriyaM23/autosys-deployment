

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
                        sh "curl -u 'SRVAMR-SFAOPS:${{ secrets.DEV_DEPLOY_ROLE }}' -k -X GET https://amraelp00011055:9443/AEWS/job/test"
                        //sh "ssh -i /var/lib/jenkins/.ssh/palign_id_rsa srvamr-palign@amer@amrvopsfa000001 'ls -l / '"
                        //sh "scp  -i /var/lib/jenkins/.ssh/palign_id_rsa -r test.jil srvamr-palign@amer@amrvopsfa000001:/home/srvamr-palign/"
                        //sh "ssh -i /var/lib/jenkins/.ssh/palign_id_rsa srvamr-palign@amer@amrvopsfa000001 'jil < /home/srvamr-palign/test.jil'"

                        sh "pwd"
          
                        }
                }
        }
    }
}
