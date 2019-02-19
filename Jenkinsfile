pipeline {
  agent none
  stages {
    stage('dev') {
      parallel {
        stage('dev') {
          steps {
            echo 'hello'
            catchError() {
              sleep 5
            }

          }
        }
        stage('step2') {
          steps {
            echo 'this is step2'
          }
        }
        stage('step3') {
          steps {
            sleep(time: 5, unit: 'MILLISECONDS')
          }
        }
      }
    }
    stage('qa') {
      parallel {
        stage('qa') {
          steps {
            echo 'this is qa'
          }
        }
        stage('') {
          steps {
            echo 'step1 qa'
          }
        }
      }
    }
    stage('qs') {
      parallel {
        stage('qs') {
          steps {
            echo 'qs'
          }
        }
        stage('') {
          steps {
            echo 'step1 qs'
          }
        }
      }
    }
    stage('test') {
      parallel {
        stage('test') {
          steps {
            echo 'test'
          }
        }
        stage('') {
          steps {
            echo 'step1 test'
          }
        }
      }
    }
    stage('stage') {
      parallel {
        stage('stage') {
          steps {
            echo 'this is stage'
          }
        }
        stage('') {
          steps {
            echo 'step 1 stage'
          }
        }
      }
    }
    stage('prod') {
      parallel {
        stage('prod') {
          steps {
            echo 'this is prod'
          }
        }
        stage('') {
          steps {
            echo 'step 1'
          }
        }
        stage('') {
          steps {
            echo 'deploy'
          }
        }
      }
    }
  }
}