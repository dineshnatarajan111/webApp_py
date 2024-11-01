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
            container("py"){
                sh"""
                . ${WORKSPACE}/venv/bin/activate && pytest --maxfail=1 --disable-warnings -v
                """
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