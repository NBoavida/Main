pipeline {
  agent none
  stages {
    stage('dev') {
      parallel {
        stage('dev') {
          steps {
            echo 'hello'
            input 'lets go?'
            catchError() {
              sleep 5
            }

          }
        }
        stage('qa') {
          steps {
            echo 'this is qa'
          }
        }
      }
    }
  }
}