# DevOps Project: Setting Up Jenkins, Ansible, and Terraform on Ubuntu EC2 Instance
This project aims to guide users through the process of setting up Jenkins, Ansible, and Terraform on an Ubuntu EC2 instance on AWS.

# EC2 Instance Setup

1. Create an Ubuntu EC2 Instance: Launch an Ubuntu EC2 instance on AWS.

2. SSH into the Instance: Use SSH to connect to your Ubuntu EC2 instance.

## Add Administrator Role

To add an administrator role in AWS IAM, follow these steps:

1. **Navigate to IAM Dashboard**: From the services menu, select IAM to navigate to the IAM dashboard.

2. **Create a New Role**: Click on "Roles" in the sidebar and then click on "Create role".

3. **Select Role Type**: Choose "AWS service" as the trusted entity and select EC2 as the service that will use this role. Click "Next: Permissions".

4. **Attach Administrator Policy**: In the permissions step, search for and select the "AdministratorAccess" policy. This policy grants full access to AWS services and resources.

5. **Review and Create**: Review the role configuration and click "Next: Tags" if you want to add tags. Otherwise, click "Next: Review".

6. **Name and Create Role**: Provide a name and description for the role and click "Create role" to create the role.

Once the role is created, you can assign it to your EC2 instance during or after the instance launch process. This will give the EC2 instance the necessary permissions to perform administrative tasks within your AWS account.


**Jenkins Installation**

1\. #sudo apt-get update

2\. #sudo apt install openjdk-11-jre-headless

3\. #sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

4\. #echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

5\. #sudo apt-get update

6\. #sudo apt-get install jenkins

Configure Jenkins: Open Jenkins in a web browser and complete the initial configuration. Install required plugins, including Git and SSH agent.

**Terraform Installation**
- Run the following commands to install Terraform:
```bash
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
```
# Create Jenkins Pipeline for Ansible-Infrastructure Creation
Create a new pipeline job in Jenkins to define your Ansible-infrastructure pipeline. You can use the provided example pipeline code and customize it according to your requirements.

**Ansible-Infrastructure Pipeline:**

```groovy
pipeline {
    agent any

    stages {
        stage('Git URL Clone') {
            steps {
                git 'https://github.com/rajujaat25/ansible-terraform.git'
            }
        }
        
        stage ("Terraform Init") {
            steps {
                sh ('terraform init -reconfigure') 
            }
        }
        
        stage ("Terraform Plan") {
            steps {
                sh ('terraform plan') 
            }
        }
                
        stage ("Terraform Apply") {
            steps {
                sh ('terraform apply --auto-approve') 
           }
        }
    }
}
```
**Configure SSH Server Credentials in Jenkins**
- Create Credentials: In Jenkins, go to Credentials, click on Add Credentials, and choose SSH Username with private key configuration. You can either use a username or private key.

# Create Jenkins Pipeline for Ansible-Playbook Run
- Create a new pipeline job in Jenkins to define your Ansible-playbook pipeline. Use the provided example pipeline code and customize it according to your requirements.

**Ansible-Playbook Pipeline:** 
```groovy
pipeline {
    agent any;
    stages {
        stage('Ansible-Playbook') {
            steps {
                sshagent(['ansible_keys']) {
                    sh 'ssh ubuntu@18.116.23.53 "mkdir -p playbook"'
                    sh 'ssh ubuntu@18.116.23.53 "git clone https://github.com/rajujaat25/ansible-nginx.git /home/ubuntu/playbook"'
                    sh 'ssh ubuntu@18.116.23.53 "ansible-playbook /home/ubuntu/playbook/deploymnet_nginx.yml"'
                }
            }
        }
    }        
}
```
- This project provides a comprehensive guide for setting up Jenkins, Ansible, and Terraform on an Ubuntu EC2 instance and creating pipelines to manage infrastructure and execute Ansible playbooks
