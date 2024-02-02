pipeline {
    agent any

    stages {

        stage('Checkout Source') {
            steps {
                git branch: "main",
                url: 'https://github.com/ryb9696/opq-ojt.git'
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
