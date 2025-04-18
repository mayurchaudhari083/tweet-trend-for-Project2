def registry = 'https://fqts01punam.jfrog.io/'
pipeline {
    agent {
        node {
            label 'maven'
        }
    }
environment {
    PATH = "/opt/apache-maven-3.9.9/bin:$PATH"
    DOCKER_TAG = '2.1.4'
    DOCKER_IMAGE_NAME = 't-trend'
    JFROG_REGISTRY = 'https://fqts01punam.jfrog.io'
    ARTIFACTORY_REPO = 'fqts01punam.jfrog.io/fqts-o1punam-docker-local'  
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
                withSonarQubeEnv('fqts-sonar-server') { 
                sh "${scannerHome}/bin/sonar-scanner"
                }
            }
        }
     stage("Jar Publish") {
          steps {
            script {
                    echo '<--------------- Jar Publish Started --------------->'
                     def server = Artifactory.newServer(url: registry + "/artifactory", credentialsId: "jenkins-jfrog-creds")
                     def properties = "buildid=${env.BUILD_ID},commitid=${GIT_COMMIT}";
                     def uploadSpec = """{
                          "files": [
                            {
                              "pattern": "jarstaging/(*)",
                              "target": "fqts-01punam-libs-release/{1}",
                              "flat": "false",
                              "props" : "${properties}",
                              "exclusions": [ "*.sha1", "*.md5"]
                            }
                         ]
                     }"""
                     def buildInfo = server.upload(uploadSpec)
                     buildInfo.env.collect()
                     server.publishBuildInfo(buildInfo)
                     echo '<--------------- Jar Publish Ended --------------->'  
            
                   }
              }   
           }
           stage('Build Docker Image') {
            steps {
                script {
                    sh """
                    docker build -t ${DOCKER_IMAGE_NAME}:${DOCKER_TAG} .
                    """
                }
            }
        }
        stage('Publish Docker Image to Artifactory') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId:'jenkins-jfrog-creds', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                    sh """
                    echo $PASSWORD | docker login $JFROG_REGISTRY --username $USERNAME --password-stdin
                    echo '<--------------- docker login done --------------->' 
                    docker tag ${DOCKER_IMAGE_NAME}:${DOCKER_TAG} ${ARTIFACTORY_REPO}/${DOCKER_IMAGE_NAME}:${DOCKER_TAG}
                    docker push ${ARTIFACTORY_REPO}/${DOCKER_IMAGE_NAME}:${DOCKER_TAG}
                    """
                    }
                }
            }
        }
        //stage('deploy'){
        //    steps {
        //        script{
        //            sh """
        //            chmod 777 deploy.sh
        //            ./deploy.sh
        //            """
        //        }
        //    }
        // }
            stage(" Deploy ") {
                  steps {
                     script {
                         echo '<--------------- Helm Deploy Started --------------->'
                         sh 'helm install ttrend t-trend-0.1.0.tgz'
                         echo '<--------------- Helm deploy Ends --------------->'
           }
        }
      }
    }
}