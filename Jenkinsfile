pipeline {
    agent {
        node {
            label 'maven'
        }
    }
environment {
        PATH = "/opt/apache-maven-3.9.9/bin:$PATH"
}
        stages {
        stage("Build") {
            steps {
                echo "Build started"
                sh 'mvn clean package'  
                echo "Build completed"
            }
        }
        stage('SonarQube analysis') {
            environment {
            scannerHome = tool 'fqts-sonar-scanner'
                   }
            steps{
                withSonarQubeEnv('fqts-sonarqube-server') { 
                sh "${scannerHome}/bin/sonar-scanner"
                }
            }
        }

    }
}