pipeline {
  agent none
  stages {
    stage('dev') {
      steps {
        echo 'hello'
        git(branch: 'my-new-config', url: 'https://github.com/fredericofrazao/Main/tree/my-new-config', changelog: true, poll: true)
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