# Minecraft Server Deployment on AWS EC2
## Introduction
In this tutorial, we will walk through the process of deploying a Minecraft server on an AWS EC2 instance. This includes setting up the EC2 instance, configuring security groups, installing necessary dependencies, and ensuring the server starts automatically. By the end, you'll be able to connect to your Minecraft server from the Minecraft client.

## Setup AWS EC2 Instance
- Navigate to the [AWS Management Console](https://aws.amazon.com/console/).
- Select the search icon and enter **EC2**.
- Select the first search result to open the **EC2 Dashboard**
- Select **Launch Instance**

### Configure the EC2 Instance:
#### Name and tags
- Choose a name for the EC2 instance (e.g., Minecraft Server).

#### Application and OS Images (Amazon Machine Image)
- From the **Quick Start** menu, select **Amazon Linux**.
- From the dropdown menu, choose **Amazon Linux 2023 AMI**.
- Under **Architecture**, choose **64-bit (Arm)**.

#### Instance type
- Choose **t4g.small** from the dropdown.

#### Key pair (login)
- Select **Create new key pair** and enter the following:
  - **Key pair name**: Choose a key pair name (e.g., mcServer).
  - **Key pair type**: Select **RSA**.
  - **Private key file format**: Select **.pem**.
- Select **Create key pair**.

#### Network settings
- Select **Edit** and enter the following:
  - **VPC - _required_**: Choose the option labelled **(default)**.
  - **Subnet**: Choose **No preference**.
  - **Auto-assign public IP**: Choose **Enable**.
  - **Firewall (security groups)**: Choose **Create security group**.
  - **Security group name - _required_**: Enter a security group name (e.g., mcServer)
  - **Description - _required_**: Enter a security group description (e.g., Security group for Minecraft server)
- Select **Add security grou rule** and enter the following:
  - **Type**: Choose **Custom TCP**.
  - **Protocol**: Choose **TCP**.
  - **Port range**: Enter **25565**.
  - **Source type**: Choose **Anywhere**
 
#### Configure storage
- Skip this section
 
#### Advanced details
- Skip this section

#### Summary
- Under **Number of instances**, enter **1**.
- Select **Launch instance**.

## Setup Minecraft Server
### SSH into the EC2 Instance
1. Select **Instances** from the **EC2 Navigation Menu**.
2. Select the **Instance ID** to view the instance. (Note the Public IPv4 address for a later step)
3. Select **Connect** and navigate to the **SSH client** tab.
4. Follow the on screen instructions to SSH into the server.

### Update and Install Dependencies
1. Update the system:
```
sudo yum update -y
```

2. Install Java:
```
sudo yum install -y java-17-amazon-corretto-headless
```

### Install Minecraft Server
1. Create a Minecraft directory and navigate to it:
```
mkdir minecraft && cd minecraft
```

2. Download Minecraft Server:
```
wget https://piston-data.mojang.com/v1/objects/84194a2f286ef7c14ed7ce0090dba59902951553/server.jar
```

3. Accept the End User License Agreement:
```
echo "eula=true" > eula.txt
```

### Setup Auto-Start for Minecraft Server
1. Create a Systemd Service File:
```
sudo nano /etc/systemd/system/minecraft.service
```

2. Add the following configuration to the file
```ini
[Unit]
Description=Minecraft Server
Wants=network-online.target

[Service]
User=ec2-user
WorkingDirectory=/home/ec2-user/minecraft
ExecStart=/usr/bin/java -Xmx1300M -Xms1300M -jar server.jar nogui
StandardInput=null

[Install]
WantedBy=multi-user.target
```
3. Reload Systemd and enable the service:
```
sudo systemctl daemon-reload
sudo systemctl enable minecraft.service
sudo systemctl start minecraft.service
```

### Start the Minecraft Server
- Run the Minecraft Server:
```
java -Xmx1300M -Xms1300M -jar server.jar nogui
```

## Test Minecraft Server
Run the following command from your preferred local shell (Replace <addr> with the Public IPv4 address from earlier):
```
nmap -sV -Pn -p T:25565 <addr>
```
