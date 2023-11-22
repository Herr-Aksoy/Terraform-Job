terraform {
  required_providers {             
    aws = {
      source = "hashicorp/aws"
      version = "5.25.0"        ##Aws Provider versionu. Azure de kullanirken bu kisma ekleme yapilmasi gerekiyor.cd
    }
  }
}
provider "aws" {
  region = "us-east-1"
  # Configuration options
}


data "aws_ami" "amzn-linux-kernel" {          ## Bu sekilde de amazon kernel 5.10 oluyor.
  most_recent = true    
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.*-x86_64-gp2"]        # amazon/amzn2-ami-kernel-5.10-hvm-2.0.20231116.0-x86_64-gp2
  }
}

resource "aws_instance" "ins_erste" {
  ami           = data.aws_ami.amzn-linux-kernel.id #data.aws_ami.amzn-linux-2023-ami.id  #data.aws_ami.linux.id   #data.aws_ami.ubuntu.id   ubuntu icin
  instance_type = "t2.micro"
  key_name = "neu"

  tags = {
    Name = "Andere"
  }

  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install -y docker
    sudo amazon-linux-extras install ansible2 -y
    # Diğer gereken komutlar veya betikler burada
    # Örneğin, Docker ve Ansible yüklemeleri gibi
  EOF
}