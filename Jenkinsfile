pipeline {
	agent any
	stages {
		stage ('Checkout') {
			steps {
				echo "test"
				checkout scm	
			}
		}
		stage ('Build') {
			steps {
				echo "Build"
				bat "dotnet publish \"${workspace}\\frontend\\frontend.csproj\" -c Release -o out"
			}
		}	
		stage ('Test') {
			steps {
				echo "Test"
				snykSecurity(
                    snykInstallation: 'snyk@latest',
                    snykTokenId: 'b003fbea-48ef-4ded-9e53-c4b490da2dc4',
                    targetFile: 'TBM-EasyDevOps.sln'
                )
			}
		}
	}
}