pipeline {
    agent any

    
    environment {
        AWS_CREDENTIALS = credentials('packer')
    }

    stages {

        stage('Checkout Source') {
            steps {
                git branch: "main",
                url: 'https://github.com/ryb9696/opq-ojt.git'
            }
        }

        stage('packer plugin') {
            steps {
                script {
                    sh 'packer plugins install github.com/hashicorp/amazon'
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

                    // Fetch the latest AMI ID from the Packer manifest
                    def latestAmiId = sh(script: 'cat manifest.json | jq -r \'.builds[0].artifact_id\' | awk -F\':\' \'{print $NF}\' | tr -d \'"\'', returnStdout: true).trim()

                    // Store the AMI ID as an environment variable
                    env.LATEST_AMI_ID = latestAmiId

                    // Print the latest AMI ID for logging purposes
                    echo "Latest AMI ID: $latestAmiId"
                }
            }
        }

        // Add more stages as needed
    }
}
