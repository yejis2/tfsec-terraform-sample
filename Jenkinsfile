
pipeline {
  agent any
  parameters {
    string(name: 'environment', defaultValue: 'terraform', description: 'Workspace/environment file to use for deployment')
    booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
    choice(name: 'action', choices: ['apply','destroy']
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
  stages{
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
        // sh 'docker run --rm -i -v "$(pwd):/src" aquasec/tfsec /src --no-color'
        sh 'chmod 755 ./tfsecw.sh'
        sh './tfsecw.sh'
      }

      post {
        always { 
          echo "========= Check tfsec test results ========="
          junit allowEmptyResults: true, testResults: 'tfsec_results.xml', skipPublishingChecks: true
        }
        success {
          // slackSend channel: '', color: 'good', message: 'SUCCESSFUL', teamDomain: '', tokenCredentialId: 'secret-text'
          echo "Tfsec passed" 
        }
        unstable {
          // script {
          //   TFSEC_RESULTS = sh (
          //     script: 'cat tfsec_results.xml',
          //     returnStdout: true
          //   ).trim()
          //   slackSend channel: '', color: 'danger', message: "[tfsec terraform] Unstable: ${TFSEC_RESULTS}", teamDomain: '', tokenCredentialId: 'secret-text' 
          // }
          error "TfSec Unstable"
        }
        failure {
          // script {
          //   TFSEC_RESULTS = sh (
          //     script: 'cat tfsec_results.xml',
          //     returnStdout: true
          //   ).trim()
          //   slackSend channel: '', color: 'danger', message: "[tfsec terraform] Failed: ${TFSEC_RESULTS}", teamDomain: '', tokenCredentialId: 'secret-text' 
          // }
          error "Tfsec failed"
        }
      }
    }
    // stage('terraform') {
    //   failFast true
    //   steps {
    //     sh 'ls .'
    //     sh 'chmod 755 ./terraformw'
    //     sh './terraformw apply -auto-approve -no-color'
    //   }
    // }
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
    stage('Apply or Destroy') {
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
