pipeline {
  agent any
  stages {
    stage('dev') {
      steps {
        echo 'hello'
        powershell(script: 'dir c:\\', returnStdout: true, returnStatus: true)
      }
    }
    stage('qa') {
      steps {
        echo 'this is qa'
      }
    }
    stage('qs') {
      steps {
        echo 'qs'
      }
    }
    stage('test') {
      steps {
        echo 'test'
      }
    }
    stage('stage') {
      steps {
        echo 'this is stage'
      }
    }
    stage('prod') {
      steps {
        echo 'this is prod'
      }
    }
  }
}