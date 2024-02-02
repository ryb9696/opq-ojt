pipeline {
    agent any

    stages {

        stage('Checkout Source') {
            steps {
                git branch: "main",
                url: 'https://github.com/ryb9696/opq-ojt.git'
            }
        }

        stage('Install Packer') {
            steps {
                script {
                    sh '''
                        curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
                        sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
                        sudo apt-get update
                        sudo apt-get install -y packer
                    '''
                }
            }
        }

        stage('packer validate') {
            steps {
                script {
                    sh 'packer validate -var-file=vars.json template.json'
                }
            }
        }

        stage('packer build') {
            steps {
                script {
                    sh 'packer build -var-file=vars.json template.json'
                }
            }
        }

        // Add more stages as needed
    }
}
