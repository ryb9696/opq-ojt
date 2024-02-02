pipeline {

  agent any

  stages {

    stage('Checkout Source') {
      steps {

        git branch: "main",
        // create keygen in the ami to git clone
          url: 'https://github.com/ryb9696/opq-ojt.git'
      }
    }

    stage('Install Packer') {
      steps {
        script {

          sh'''#!/bin/bash 
                        curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
                        sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
                        sudo apt-get update && sudo apt-get install packer
                    '''
        }
      }
    }

    stage('packer validate') {
      steps {
        script {

          sh'''#!/bin/bash 
                        packer validate -var-file=vars.json template.json
                    '''
        }
      }
    }

    stage('packer build') {
      steps {
        script {

          sh'''#!/bin/bash 
                        packer build -var-file=vars.json template.json
                    '''
        }
      }
    }

  }

}
