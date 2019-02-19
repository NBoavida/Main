pipeline {
  agent none
  stages {
    stage('dev') {
      steps {
        echo 'hello'
        input 'lets go?'
        catchError() {
          sleep 5
        }

      }
    }
  }
}