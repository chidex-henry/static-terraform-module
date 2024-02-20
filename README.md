# Static Website Deployment on AWS with Terraform Modules

This project aims to deploy a static website on Amazon Web Services (AWS) using Terraform modules. Terraform modules provide a structured and reusable way to manage infrastructure resources on AWS.

## Project Overview

### Root Modules and Child Modules

- **Root Module:** The main directory containing Terraform configuration files.
- **Child Modules:** Sub-modules nested within the root module or another child module.

## Project Workflow

1. **GitHub Repository Setup:**
   - Created a GitHub repository to store Terraform infrastructures.
   - Cloned the repository to the local desktop and pushed changes from the local repository to the remote repository.

2. **IAM User Setup:**
   - Created an IAM user named Terraform-user with programmatic access.
   - Attached the `AdministratorAccess` permission policy to Terraform-user to allow creating AWS resources.
   
3. **AWS Credential Management:**
   - Created a named profile (terraform-user) for the IAM user to allow Terraform to authenticate with AWS environment using the user’s credentials.

4. **Terraform State Management:**
   - Created an S3 bucket named "chidex-terraform-remote-state1" to store the Terraform state file (`terraform.tfstate`).
   - Launched a DynamoDB table named "terraform-state-lock" to lock the state file and prevent concurrent modifications.

5. **AWS Resource Provisioning:**
   - Developed Terraform modules for the following AWS core services:
     - Virtual Private Cloud (VPC) with public and private subnets across two availability zones.
     - Internet Gateway for connectivity between VPC instances and the Internet.
     - Security Groups for network firewall mechanism.
     - ECS (Elastic Container Service) cluster, task definition, and service for containerized applications.
     - Application Load Balancer for evenly distributing web traffic.
     - Auto Scaling Group to manage EC2 instances for website availability, scalability, and fault tolerance.
     - Certificate Manager for securing application communication.
     - Simple Notification Service (SNS) for alerting activities within the Auto Scaling Group.
     - Route 53 for registering domain names and setting up DNS records.

## Challenges and Solutions

- **Resource Configuration:** Building and compiling resource arguments and attribute names posed challenges.
  - Solution: Debugging error messages and referencing AWS Management Console alongside Terraform documentation to align resource configurations.

## Conclusion

This project demonstrates the deployment of a static website on AWS using Terraform modules. By structuring infrastructure configurations into reusable modules, the project ensures scalability, reliability, and ease of management for AWS resources.

 ![image](https://github.com/chidex-henry/static-terraform-module/assets/77998377/52050121-5eae-4fd4-a2fd-c0bb3c2d3aa7)
