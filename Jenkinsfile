pipeline {
  agent { label 'go' }
  stages {
    stage('init') {
      when { changeset "modules/*" }
      steps {
          sh "echo 'hello world!'"
      }
    }
  } 
}