provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  token = var.aws_session_token
  region = "us-west-2"
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name = "name"
    values = ["amzn2-ami-hvm-*-arm64-gp2"]
  }
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet" "default" {
  filter {
    name = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

  filter {
    name = "default-for-az"
    values = ["true"]
  }

  filter {
    name = "availability-zone"
    values = ["us-west-2a"]
  }

  vpc_id = data.aws_vpc.default.id
}

resource "aws_key_pair" "generated_key" {
  key_name = "minecraft_key"
  public_key = file("${path.module}/../minecraft_key.pub")
}

resource "aws_security_group" "minecraft_sg" {
  name = "minecraft_sg"
  description = "Allow Minecraft traffic and SSH access"
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port = 25565
    to_port = 25565
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "minecraft" {
  ami = data.aws_ami.amazon_linux.id
  instance_type = "t4g.small"
  key_name = aws_key_pair.generated_key.key_name
  vpc_security_group_ids = [aws_security_group.minecraft_sg.id]
  subnet_id = data.aws_subnet.default.id

  tags = {
    Name = "Minecraft Server"
  }
}

output "instance_public_ip" {
  value = aws_instance.minecraft.public_ip
}
