pipeline {
    agent any

    environment {
        PATH = "/opt/apache-maven-3.9.9/bin:$PATH"
    }

    stages {
        stage("Checkout Code") {
            steps {
                git branch: 'main', url: 'https://github.com/mayurchaudhari083/tweet-trend-for-Project2.git'
            }
        }
        stage("Build") {
            steps {
                echo "Build started"
                sh 'mvn clean package'  // Change to 'mvn clean deploy' if needed
                echo "Build completed"
            }
        }
    }
}
