pipeline {
    agent any

    environment {
        REPORT_FILE = 'report.xml'
        RECIPIENTS = 'dineshnatarajan5@gmail.com'
        GITHUB_REPO = "dineshnatarajan111/webapp_deployment"
        GITHUB_TOKEN = credentials('github-token')
        NEW_VERSION = "${env.BRANCH_NAME}-${env.BUILD_NUMBER}" 
    }

    stages {
        stage('Setup') {
            steps {
                sh '''
                python3 -m venv venv
                source venv/bin/activate
                pip install -r requirements.txt
                '''
            }
        }

        stage('Test') {
            steps {
                script {
                    updateGitHubCommitStatus('pending', 'Running tests...')
                }
                sh '''
                source venv/bin/activate
                pytest --maxfail=5 --disable-warnings --junitxml=${REPORT_FILE}
                '''
            }
        }

        stage('Build Docker Image') {
            when {
                expression { env.BRANCH_NAME == 'main' || env.BRANCH_NAME == 'develop' && currentBuild.resultIsBetterOrEqualTo('SUCCESS') }
            }
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials-id', usernameVariable: 'DOCKER_USR', passwordVariable: 'DOCKER_PWD')]) {
                        sh """
                        ./build.sh
                        """
                    }
                }
            }
        }
    }

    post {
        always {
            junit "${REPORT_FILE}"
            script {
                def testResult = currentBuild.result == 'FAILURE' ? 'failure' : 'success'
                def description = testResult == 'failure' ? 'Tests failed' : 'Tests passed'
                updateGitHubCommitStatus(testResult, description)
            }
        }

        failure {
            emailext(
                subject: "Build Failed in ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: "Build failed. Check Jenkins for details.\n\n${env.BUILD_URL}",
                to: "${RECIPIENTS}",
                attachmentsPattern: "${REPORT_FILE}"
            )
        }

        success {
            emailext(
                subject: "Build and Docker Image Creation Succeeded in ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: "Build and Docker image creation succeeded.\n\n${env.BUILD_URL}",
                to: "${RECIPIENTS}"
            )
        }
    }
}

def updateGitHubCommitStatus(String state, String description) {
    step([
        $class: 'GitHubCommitStatusSetter',
        contextSource: [$class: 'ManuallyEnteredCommitContextSource', context: 'CI/Test Results'],
        statusResultSource: [$class: 'ConditionalStatusResultSource', results: [
            [$class: 'AnyBuildResult', state: state, message: description]
        ]]
    ])
}
