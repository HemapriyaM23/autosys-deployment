

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
                        withCredentials([usernamePassword(credentialsId: 'sfaops', passwordVariable: 'pwd', usernameVariable: 'usr')]) {

                        sh 'curl -u "${usr}:${pwd}" -k -X POST https://amraelp00011055:9443/AEWS/job/d2compaus_pa_dependency_job1'
                        }
                        //sh "ssh -i /var/lib/jenkins/.ssh/palign_id_rsa srvamr-palign@amer@amrvopsfa000001 'ls -l / '"
                        //sh "scp  -i /var/lib/jenkins/.ssh/palign_id_rsa -r test.jil srvamr-palign@amer@amrvopsfa000001:/home/srvamr-palign/"
                        //sh "ssh -i /var/lib/jenkins/.ssh/palign_id_rsa srvamr-palign@amer@amrvopsfa000001 'jil < /home/srvamr-palign/test.jil'"

                        sh "pwd"
          
                        }
                }
        }
    }
}
