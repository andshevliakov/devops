terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "devops" {
  ami           = "ami-0b93ce03dcbcb10f6"
  instance_type = "t2.small"
  security_groups = [aws_security_group.web_traffic.name]
  key_name = "shevliak"

  provisioner "remote-exec"  {
    inline  = [
      "sudo apt-get update -y",
      "sudo apt-get -y install ca-certificates curl gnupg lsb-release",
      "sudo mkdir -p /etc/apt/keyrings",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg",
      "echo \"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null",
      "sudo apt-get -y update",
      "sudo apt-get -y install docker-ce docker-ce-cli containerd.io",
      "sudo docker run --name jenkins -d -p 8080:8080 -p 50000:50000 --env GITLAB_TOKEN=${var.gitlab_token} --env JENKINS_HOST_IP=${self.public_ip} --env JENKINS_ADMIN_ID=${var.jenkins-creds.id} --env JENKINS_ADMIN_PASSWORD=${var.jenkins-creds.password} ${var.jenkins-config.image}:${var.jenkins-config.tag}",
    ]
  }
  connection {
    type         = "ssh"
    host         = self.public_ip
    user         = "ubuntu"
    private_key  = file("/Users/andrew/Downloads/shevliak.pem")
  }

  tags = {
    Name = "devopsLab"
  }
}
