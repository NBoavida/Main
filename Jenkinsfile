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
        stage('step2') {
          steps {
            echo 'this is qa'
          }
        }
        stage('step3') {
          steps {
            sleep 5
          }
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