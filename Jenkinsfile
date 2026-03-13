pipeline {
    agent any
    options {
        ansiColor('xterm')
        buildDiscarder(logRotator(numToKeepStr: '5'))
        disableConcurrentBuilds()       // At a time 2 Jobs will not run, useful for locking terrafomr apply 
    }
    parameters {
        choice(name: 'environment', choices: ['dev', 'prod'], description: 'Select the environment')
        choice(name: 'action', choices: ['apply', 'destroy'], description: 'Select the action')
    }
    environment {
        vault_token = credentials('vault_token') 
    }
    stages {
        stage('Terraform Init') {
            steps {
                sh "terraform --version"
                sh "rm -rf .terraform*"
                sh "terraform init  -backend-config=env-${params.environment}/state.tfvars -var-file=env-${params.environment}/main.tfvars -var token=${vault_token}"
            }
        }
        stage('Terraform Plan') {
            steps {
                sh "terraform plan -var-file=env-${params.environment}/main.tfvars -var token=${vault_token}"
            }
        }
        stage('Terraform Apply') {
            steps {
                sh "terraform ${params.action} -var-file=env-${params.environment}/main.tfvars -var token=${vault_token} -auto-approve"
                sh "echo Apply Completed"
            }
        }
    }
}