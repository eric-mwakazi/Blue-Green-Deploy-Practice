## 🚀 Install Jenkins Plugins
Jenkins plugins enhance the functionality of Jenkins to support various use cases, including CI/CD pipelines, integration with different tools, and more. The following plugins are essential for your DevOps setup:

- **SonarQube Scanne**: Allows Jenkins to integrate with SonarQube for code quality checks.
- **Config File Provider**: Helps manage external configuration files within Jenkins.
- **Maven Integration**: Provides Maven support for building Java projects in Jenkins.
- **Pipeline Maven Integration**: Enables Maven support within Jenkins Pipeline for Java projects.
- **Pipeline: StageView**: Visualizes the stages of a pipeline in the Jenkins UI.
- **Docker Pipeline**: Adds Docker support to Jenkins pipelines, useful for building and running Docker containers.
- **Kubernetes (k8s)**: Allows Jenkins to run jobs inside a Kubernetes cluster.
- **Kubernetes CLI (k8s cli)**: Provides the ability to run `kubectl` commands within Jenkins.
- **Kubernetes Credentials**: Manages Kubernetes credentials for secure access within Jenkins.
- **Kubernetes Credentials Provider**: Manages Kubernetes service account credentials.

### ⚙️To install the plugins, follow these steps:

1. Go to **Jenkins Dashboard** > **Manage Jenkins** > **Manage Plugins**.
2. In the **Available** tab, search for the plugins listed above and install them.
3. After installation, restart Jenkins to apply the changes.

## ⚙️ Connecting Jenkins to Kubernetes Cluster
Follow these steps on **Jenkins Dashboard** server:
* Manual Link: [jenkins_rbac_guidlines.md](jenkins_rbac_guidlines.md)

## 🔐 Adding Secret Tokens to Jenkins
To integrate GitLab and DockerHub securely with Jenkins pipelines, you need to store your access tokens as credentials. Here's how to create and add GitLab and DockerHub tokens to Jenkins using the Username and Password credential type, with "Treat username as a secret" enabled.
 ### 🔑 Step 1: Create below Access Tokens
 1. ✅ GitLab Personal Access Token (PAT)
<!--#### ✅ GitLab Personal Access Token (PAT)
 1. **Go to your GitLab account.**

2. **Navigate to:** 
User Settings > Access Tokens

3. **Fill in:**

    * Name: e.g., jenkins-git-token

    * Scopes: Check at least read_repository, write_repository, and optionally api.

    * Click Create personal access token.

    * Copy the token – it will be shown once only. -->
2. ✅ DockerHub Access Token
<!-- #### ✅ DockerHub Access Token
1. **Go to your DockerHub account.**

2. **Navigate to:**
Account Settings > Security > New Access Token

3. **Fill in:**

    * **Token description: e.g., jenkins-docker-token**

    * **Select appropriate permissions (for pushing/pulling from repos).**

4. **Click Generate.**

5. **Copy the token.** -->
3. ✅ Sonarqube Access Token
<!-- #### ✅ Sonarqube Access Token
1. **Go to your sonarqube dashboard.**

2. **Generate a New Access Token** -->

### 🛠️ Step 2: Add Tokens to Jenkins
1. **Open your Jenkins Dashboard.**
2. **Navigate to:
Manage Jenkins > Credentials > (select scope, e.g., Global) > Add Credentials.**
3. **📌Add all the tokens to jenkins.**
    * Gitlab/github token
    * DockerHub Token
    * Sonarqube Token
<!-- 3. **Choose Kind: Username with password.**
4. **📌 Add GitLab Token
Username: The GitLab Personal Access Token (paste the token here).** 
5. **Password: paste the token created in gitlab.**
6. **✅ Check "Treat username as a secret".**

7. **ID: gitcred-blue-green-cicd**

8. **Description: GitLab token for Blue-Green CI/CD pipelines and Click OK to save.**

#### 📌 Add DockerHub Token
1. **Username: Your DockerHub username.**
2. **Password: Your DockerHub token (not your DockerHub password!).**
3. **✅ Check "Treat username as a secret".**
4. **ID: docker-blue-green-cicd.**
5. **Description: DockerHub token for Blue-Green CI/CD pipelines.**
6. **Click OK to save.**

#### 📌 Add Sonarqube Token -->


## 🛠️ Add sonarqube server and configure maven n jenkins
#### 📍 Navigate to Jenkins Settings
From the Jenkins Dashboard, go to:
Manage Jenkins > Tools

#### 🔧 Configure SonarQube Server
* Scroll to SonarQube Servers.
* Click Add SonarQube:
* Name: sonarqube
* Server URL: http://localhost:9000 (or your SonarQube IP)
* Server authentication token:
* Click Add > Jenkins
* Kind: Secret text
* Secret: (your SonarQube token)
* ID: sonarqube-token
* Description: SonarQube token for Jenkins
* Back in SonarQube section:
* Select sonarqube-token from the dropdown
* ✅ Enable: "Environment variable injection"
* Scroll down and Save.

### ⚙️ Configure Maven in Jenkins
* Still in Configure System, scroll to the Maven section.
* Click Add Maven:
* Name: maven3
* ✅ Check Install automatically
* Version: Select 3.x (e.g., 3.8.8)
* Save the configuration.



## 🛠️ Configure Nexus in Jenkins
### 🧾 Configure settings.xml via Config File Provider (Optional but useful)
* Navigate to:
Manage Jenkins > Managed files > Add a new Config
* Select Maven Global Maven settings.xml, Scroll to bottom a give ID of the config file name you will remember i.e "Set the ID to: nexus-settings" and configure it like this:
```
    <server>
      <id>maven-releases</id>
      <username>admin_user</username>
      <password>nexus_password</password>
    </server>    <server>
      <id>maven-snapshots</id>
      <username>admin_user</username>
      <password>nexus_password</password>
    </server>
```
### 🔧 Modify pom.xml in java-bankapp
Open the pom.xml of your project (java-bankapp) and add or update the <distributionManagement> section like so:
```
<distributionManagement>
    <repository>
        <id>maven-releases</id>
        <url>http://192.168.1.85/repository/maven-releases/</url>
    </repository>
    <snapshotRepository>
        <id>maven-snapshots</id>
        <url>http://192.168.1.85/repository/maven-snapshots/</url>
    </snapshotRepository>
</distributionManagement>
```
Make sure the id values match the ones in your settings.xml.

## 👨‍💻 Author

Generated by [@Eric mwakazi](https://www.linkedin.com/in/eric-mwakazi)  – Automating cloud-native infrastructure in homelabs and production.