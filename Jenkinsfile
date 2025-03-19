pipeline {
    agent {
        node {
            label 'maven'
        }
    }
   environment {
      PAth = "/opt/apache-maven-3.9.9/bin:$PATH"
   }
    stages {
        stage("build") {
            steps {
               // git branch: 'main', url: 'https://github.com/mayurchaudhari083/tweet-trend-for-Project2.git' 
               echo "build started"
               sh 'mvn clean deploy'
               echo "build completed" 

            }
        }
    }
}
