#!/bin/bash
# Read AWS credentials from the file
AWS_ACCESS_KEY_ID=$(awk -F'=' '/aws_access_key_id/ {print $2}' aws_credentials | xargs)
AWS_SECRET_ACCESS_KEY=$(awk -F'=' '/aws_secret_access_key/ {print $2}' aws_credentials | xargs)
AWS_SESSION_TOKEN=$(awk -F'=' '/aws_session_token/ {print $2}' aws_credentials | xargs)

# Generate SSH key pair if it doesn't exist
if [ ! -f "minecraft_key" ]; then
    ssh-keygen -t rsa -b 4096 -f minecraft_key -N ""
fi

# Navigate to the terraform directory
cd terraform

# Initialize and apply Terraform configuration
terraform init
terraform apply -auto-approve -var "aws_access_key=$AWS_ACCESS_KEY_ID" -var "aws_secret_key=$AWS_SECRET_ACCESS_KEY" -var "aws_session_token=$AWS_SESSION_TOKEN"

# Get the public IP of the instance and wait to init
instance_ip=$(terraform output -raw instance_public_ip)
echo "Initializing..."
sleep 10

# Update the Ansible inventory with the instance IP
echo "[minecraft]" > ../ansible/inventory
echo "${instance_ip} ansible_ssh_user=ec2-user ansible_ssh_private_key_file=$(pwd)/../minecraft_key" >> ../ansible/inventory

# Navigate to the ansible directory
cd ../ansible

# Run the Ansible playbook
ansible-playbook -i inventory playbook.yml
