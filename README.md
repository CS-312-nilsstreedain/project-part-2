# Minecraft Server Deployment Automation
## Introduction
In this tutorial, we will walk through the process of automatically deploying a Minecraft server on an AWS EC2 instance using Terraform and Ansible. This includes setting up the EC2 instance, configuring security groups, installing necessary dependencies, and ensuring the server starts automatically. By the end, you'll be able to connect to your Minecraft server from the Minecraft client.

## Requirements
- AWS CLI configured with your credentials
- Terraform
- Ansible

## Diagram
<img width="1019" alt="image" src="https://github.com/CS-312-nilsstreedain/project-part-2/assets/25465133/0d25e5b0-6dc3-43fd-a8e3-da5be65c798e">


## Steps
1. Clone the repository and navigate to the project directory.
```
git clone git@github.com:CS-312-nilsstreedain/project-part-2.git
```

```
cd project-part-2
```

2. Add AWS CLI Credentials
```
nano aws_credentials
```

3. Run `setup.sh` to provision the infrastructure and configure the server.
```
chmod +x setup.sh
```

```
./setup.sh
```

## How to Test
- Retrieve the public IP from the Terraform output.
- Run nmap on the IP
```
nmap -sV -Pn -p T:25565 <instance_public_ip>
```

## How to Connect
- Retrieve the public IP from the Terraform output.
- Connect to the server using the Minecraft client at `<Public_IP>:25565`.

## Resources
- [AWS CLI](https://aws.amazon.com/cli/)
- [Terraform](https://www.terraform.io/)
- [Ansible](https://www.ansible.com/)
