podTemplate(
    inheritFrom: 'jenkins-inbound-agent',
    containers: [
        containerTemplate(
            name: 'py',
            image: 'dinesh1705/py-jenkins-slave:3.0.0',
            ttyEnabled: true,
            command: 'cat'
        )    
    ]
)
{
    node(POD_LABEL){
        stage("checkout"){
            checkout scm
        }
        stage("Get Dependencies"){
            container("py"){
                sh"""
                python3 -m venv ${WORKSPACE}/venv
                . ${WORKSPACE}/venv/bin/activate && pip3 install -r requirements.txt
                """
            }
        }
        stage("Unit Test"){
            withCredentials([
                usernameColonPassword(credentialsId: '', variable: 'GITHUB_TOKEN')
            ]){
                withEnv([
                    'GITHUB_REPO=dineshnatarajan111/webApp_py'
                ]){
                    container("py"){
                        sh"""
                        . ${WORKSPACE}/venv/bin/activate && pytest --junitxml=report.xml'
                        """
                        def commitSHA = sh(script: "git rev-parse HEAD", returnStdout: true).trim()
                        def testResults = readFile('report.xml')  // Replace with your test results file
                        def summary = testResults.count("tests=")
                        def successCount = testResults.count("passed=")
                        def failureCount = testResults.count("failed=")
                        def githubComment = """
                        Test Results for commit `${commitSHA}`:
                        - Total Tests: ${summary}
                        - Passed: ${successCount}
                        - Failed: ${failureCount}
                        """

                        // Post the comment using GitHub API
                        sh """
                        curl -H "Authorization: token ${env.GITHUB_TOKEN}" \
                                -X POST \
                                -d '{ "body": "${githubComment}" }' \
                                "https://api.github.com/repos/${env.GITHUB_REPO}/commits/${commitSHA}/comments"
                        """
                    }
                }
            }
        }
        stage("build"){
            container("py"){
                sh"""
                python3 --version
                """
            }
        }
    }
}