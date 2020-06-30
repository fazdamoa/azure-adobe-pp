pipeline {
  agent { label 'go' }
  stages {
    stage('init') {
      //when { changeset "modules/*" }
      steps {
        withCredentials([azureServicePrincipal(credentialsId: 'b2f506a9-444e-4fed-9c4a-77b3a2224528',
                        subscriptionIdVariable: 'ARM_SUBSCRIPTION_ID',
                        clientIdVariable: 'ARM_CLIENT_ID',
                        clientSecretVariable: 'ARM_CLIENT_SECRET',
                        tenantIdVariable: 'ARM_TENANT_ID')]) {
          sh "./files/test.sh"
        }
      }
    }
  }
}