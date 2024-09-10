# DevOps Project: BirdApi
[![Version](https://img.shields.io/badge/version-1.4.0-blue.svg)](https://example.com/version)



  * [Project Overview](#project-overview)
  * [Architecture](#architecture)
  * [Features](#features)
  * [Prerequisites](#prerequisites)
  * [Installation](#installation)
    + [1. Clone the Repository](#1-clone-the-repository)
    + [2. SSH key](#2-ssh-key)
    + [3. Infrastructure setup](#3-infrastructure-setup)
    + [4.  Outputs](#4--outputs)
- [Usage](#usage)
    + [BirdAPI](#birdapi)
    + [BirdAPI metrics](#birdapi-metrics)
- [Monitoring and Logging](#monitoring-and-logging)
  * [Overview](#overview)
  * [Grafana](#grafana)
    + [Usage](#usage-1)
  * [Prometheus](#prometheus)
    + [Usage](#usage-2)
- [EC2 - Instance](#ec2---instance)
  * [Overview](#overview-1)
  * [What gets installed on the server](#what-gets-installed-on-the-server)
- [Versions](#versions)
    + [v 1.0](#v-10)
    + [v1.2](#v12)
    + [v1.3](#v13)
    + [v1.4 (current one)](#v14--current-one-)
- [Contact](#contact)

<small><i><a href='http://ecotrust-canada.github.io/markdown-toc/'>Table of contents generated with markdown-toc</a></i></small>



---



## Project Overview

This project automates the deployment and management of BirdApp, utilizing DevOps best practices. It deploys the application and all the necessary tools to the cloud, leveraging tools like Terraform and Kubernetes. 

Terraform provisions AWS infrastructure, creating an EC2 instance and necessary network components. Ansible is responsible for installing and configuring dependencies on the EC2 instance, including Docker, k3s, and Helm. Kubernetes (k3s) is used for container orchestration, while Helm charts are employed to deploy the BirdApp, Prometheus, and Grafana.

What is BirdApp you might ask? BirdApp consists of two APIs that provide information about various bird species. This project demonstrates infrastructure provisioning, CI pipeline automation, and monitoring tools in a DevOps environment.
**Plus, it gives us Birds—and that's awesome!**

If you want to understand how the app works, consult the following diagram:

<img src="./assets/birdapp.svg" alt="BirdApp" style="zoom:30%;" />

## Architecture

<img src="./assets/terraform.png" alt="Infrastructure diagram" style="zoom:30%;" />

- **Infrastructure as Code (IaC)**: Provisioned using Terraform.
- **Configuration Management**: Managed with Ansible.
- **Continuous Integration (CI)**: Built using Github Actions.
- **Cloud Provider**: Running on AWS.
- **Monitoring**: Implemented using Prometheus and Grafana.

## Features

- **Infrastructure as Code**: Entire infrastructure is defined and version-controlled using Terraform.
- **Monitoring**: Real-time metrics and alerting.

## Prerequisites

Before you begin, ensure you have met the following requirements:

- An AWS cloud account
- Installed the following tools:
  - [Terraform](https://www.terraform.io/downloads.html)
  - [Aws CLI](https://aws.amazon.com/cli/)

## Installation

### 1. Clone the Repository

```bash
git clone https://github.com/rdg5/devops-challenge.git
cd devops-challenge
```

### 2. SSH key

After generating the SSH key using `ssh-keygen`, ensure that the key is either added to your AWS key pairs or stored securely. You will need to provide the path to this key in the `terraform.tfvars` file under the `ssh_key_path` variable in the next step.

### 3. Infrastructure setup

Ensure your cloud provider credentials are configured (e.g., `~/.aws/credentials` for AWS) and your environment variables are stored under `repo/infra/terraform.tfvars`. Please make sure that your AWS credentials and sensitive information (such as SSH keys) are stored securely using environment variables, or secret management tools such as AWS Secrets Manager. Never hard-code sensitive data in the repository.

Ensure that your AWS CLI is configured with the correct credentials by running `aws configure` and setting the appropriate access keys. The AWS CLI will store this information in `~/.aws/credentials`.

For reference check the `infra/example.terraform` file on what variables you are expected to provide:

```
aws_region         =
vpc_cidr_block     =
public_subnet_cidr =
ssh_key_path       =
allowed_ssh_cidr   =
instance_type      =
ami_id             =
```

If the setup is complete, run the following commands:

```
# Initialize Terraform
terraform init

# Apply the Terraform configuration
terraform apply
```

Running `terraform apply` will provision an EC2 instance with a security group, a VPC, and a subnet as defined in the `terraform.tfvars` file. Terraform will also output the public IP address of the EC2 instance once provisioning is complete.

### 4.  Outputs

When the setup completes you will find the public ip address of the server as well as the number of generated resources. (e.g.)

```
Apply complete! Resources: 8 added, 0 changed, 0 destroyed.

Outputs:

ec2_instance_public_ip = "34.254.158.66"
```

# Usage

### BirdAPI 

After the installation is complete you can access the BirdAPI on NodePort 30001. (e.g. `34.254.158.66:30001/bird`).  

 Sending a GET request will respond with a JSON of a given bird: 

```
{"Name":"Eagle","Description":"Eagles are large birds of prey known for their powerful beaks and keen eyesight.","Image":"\"https://images.unsplash.com/photo-1481883814866-f6e972dd8916?crop=entropy\\u0026cs=tinysrgb\\u0026fit=max\\u0026fm=jpg\\u0026ixid=M3w2Mzg4NzZ8MHwxfHNlYXJjaHwxfHxFYWdsZXxlbnwwfHx8fDE3MjU5NzMxNjJ8MA\\u0026ixlib=rb-4.0.3\\u0026q=80\\u0026w=200\"\n"}
```

### BirdAPI metrics

If you are interested in the metrics regarding the API you can access them on the `/metrics` endpoint. (e.g. `34.254.158.66:30001/metrics)

Sending a GET request will respond with the metrics used by Prometheus e.g.:

```
# TYPE http_requests_total_birdapi counter
http_requests_total_birdapi{endpoint="/bird",method="GET"} 2
# HELP process_cpu_seconds_total Total user and system CPU time spent in seconds.
# TYPE process_cpu_seconds_total counter
process_cpu_seconds_total 0.3
# HELP process_max_fds Maximum number of open file descriptors.
# TYPE process_max_fds gauge
process_max_fds 1.048576e+06
# HELP process_network_receive_bytes_total Number of bytes received by the process over the network.
# TYPE process_network_receive_bytes_total counter
process_network_receive_bytes_total 55794
# HELP process_network_transmit_bytes_total Number of bytes sent by the process over the network.
# TYPE process_network_transmit_bytes_total counter
process_network_transmit_bytes_total 213836
# HELP process_open_fds Number of open file descriptors.
# TYPE process_open_fds gauge
process_open_fds 10
# HELP process_resident_memory_bytes Resident memory size in bytes.
# TYPE process_resident_memory_bytes gauge
process_resident_memory_bytes 1.4819328e+07
```

# Monitoring

## Overview

If you are interested in the API metrics, the project comes with Prometheus and Grafana installed with Helm and connected to Kubernetes.

## Grafana

There is a precreated Dashboard that showcases the total number of HTTP requests received by the two API's. e.g.

<img src="./assets/dashboard.png" alt="Grafana login" style="zoom:30%;" />

### Usage

In order to access Grafana visit NodePort 30002. ( e.g. `34.254.158.66:30002/`).  

You will be presented with the following login form

<img src="./assets/grafana.png" alt="Grafana login" style="zoom:40%;" />

You can use the precreated admin account, the credentials for it are:

```
username: admin
password: your-admin-password
```

After logging in visit the Dasboards in the menu to see the prebuilt HTTP request tracker. 

## Prometheus

### Usage

In order to access Prometheus visit NodePort 30003. ( e.g. `34.254.158.66:30003/`).  

If you want to query the API metrics directly, you can do it under the `Graph` if you are interested in the services, Prometheus monitors the API's as well as the Kubernetes cluster.

<img src="./assets/prometheus.png" alt="Prometheus services" style="zoom:40%;" />

Alerts can be set up using Prometheus Alertmanager to notify you when certain conditions (e.g., high CPU usage, memory exhaustion) are met. It is recommended to monitor both infrastructure metrics (CPU, memory, disk) as well as application-specific metrics (HTTP response times, request rates).

# EC2 - Instance

## Overview

Terraform creates one `t3.medium` instance running `Ubuntu 20.04` in the `eu-west-1` region on AWS.

## What gets installed on the server

With the help of Ansible the following steps will happen after the instance is created: 

1. Installing Docker
2. Installing k3s
3. Installing Helm
4. Cloning repository
5. Provisioning Grafana dashboard
6. Installing Prometheus
7. Installing Grafana
8. Deploy BirdAPI
9. Deploy BirdImageAPI
10. Reinforcing the instance:
    1. Disabling root login over SSH, 
    2. Setting up a firewall to limit open ports
    3.  Enabling automatic security updates.

Everything is deployed with helm on the default k3s namespace. 

At the end of the installation process the following pods will be running:

<img src="./assets/kubectl-get-pods.png" alt="Kubectl get pods" style="zoom:40%;" />

You can also see the deployments using Helm:

<img src="./assets/helm.png" alt="Helm list" style="zoom:30%;" />

# Versions

You might've noticed that there are multiple branches in the repository that are meant to showcase the evolution of the project. 

If you are interested in the order of the tasks completed, you can consult the commits belonging to those particular branches.

 Here is a quick overview on what each version does:

### v 1.0

The app can be deployed to an AWS EC2 instance using Terraform and Docker as the Infrastructure as Code tool.  
All the necessary files can be found in the `infra/` folder.  
The required steps are [installing Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) and then creating your own version of the `terraform.tfvars` file, you can use the `example.terraform` file found in the `infra\` folder to see what variables you will need.  
To run simply initialize a new Terraform project using `terraform init` and then apply the configuration with `terraform apply`. The instance takes a little bit of time to install the necessary programs, but once its done, you can access the bird api on the `publicIP:4201`.

### v1.2

The app can be run using helm charts.  
For easier deploy apply the two deployments and the two services from the `helm-charts/bird/` and `helm-charts/birdImage/` folders. The birdapi can be reached through the `localhost:30001` nodeport. Please note that the birdimageapi is running in ClusterIP mode, if you want to access the api externally, you need to change the `birdimageapi-service.yaml` type to NodePort.

### v1.3

The app deployment is completely automated, by using Terraform we can deploy the api's on an ec2 instance. You can access the birdAPI on the publicIP:30001NodePort. 

### v1.4 (

The automated app deployment now includes Prometheus & Grafana with auto configured data source and a dashboard to monitor the http requests for both api's.

# Contact

You can reach me on [linkedin](www.linkedin.com/in/sandorvass)! Thanks for checking out the project, you are awesome! 