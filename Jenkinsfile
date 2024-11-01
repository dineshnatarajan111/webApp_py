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
                usernameColonPassword(credentialsId: 'jenkins-github-pat', variable: 'GITHUB_TOKEN')
            ]){
                withEnv([
                    'GITHUB_REPO=dineshnatarajan111/webApp_py'
                ]){
                    
                    container("py"){
                        sh"""
                        . \${WORKSPACE}/venv/bin/activate && pytest --junitxml=report.xml
                        commitSHA=\${env.GIT_COMMIT}
                        tests=\$(xmllint --xpath 'string(//testsuite/@tests)' report.xml)
                        errors=\$(xmllint --xpath 'string(//testsuite/@errors)' report.xml)
                        failures=\$(xmllint --xpath 'string(//testsuite/@failures)' report.xml)
                        # Assuming "passed" means tests - (errors + failures)
                        passed=\$((tests - errors - failures))
                        githubComment="Test Results for commit ${commitSHA}: \n- Total Tests: ${tests}\n- Passed: ${passed}\n- Failed: ${failures}
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