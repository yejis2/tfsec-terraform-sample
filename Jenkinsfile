pipeline {
    agent any
    parameters {
        string(name: 'environment', defaultValue: 'terraform', description: 'Workspace/environment file to use for deployment')
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
        choice(name: 'action', choices: ['apply','destroy'])
    }
  
    environment {
        def dockerHome = tool 'myDocker'
        PATH = "${dockerHome}/bin:${env.PATH}"
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        REGION = credentials('AWS_REGION')
    }

    options {
        skipDefaultCheckout(true)
    }

    stages {
        stage('clean workspace') {
            steps {
                cleanWs()
            }
        }

        stage('Initialize') {
            steps {
                echo "env ${env.PATH}"
            }
        }

        stage('checkout') {
            steps {
                checkout scm
            }
        }

        stage('Plan') {
            steps {
                sh 'terraform init -upgrade'
                sh "terraform validate"
                sh "terraform plan"
            }
        }

        stage('tfsec') {
            failFast true
            steps {
                echo "=========== Execute tfsec ================="
                sh 'chmod 755 ./tfsecw.sh'
                sh './tfsecw.sh'
            }

            post {
                always { 
                    echo "========= Check tfsec test results ========="
                    junit allowEmptyResults: true, testResults: 'tfsec_results.xml', skipPublishingChecks: true
                }
                success {
                    echo "Tfsec passed" 
                }
                unstable {
                    error "TfSec Unstable"
                }
                failure {
                    error "Tfsec failed"
                }
            }
        }

        stage('Approval') {
            when {
                not {
                    equals expected: true, actual: params.autoApprove
                }
            }

            steps {
                script {
                    input message: "Do you want to apply the plan?",
                    parameters: [text(name: 'Plan', description: 'Please review the plan')]
                }
            }
        }

        stage('Apply or Destroy') {
            steps {
                sh 'terraform ${action} --auto-approve'
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
