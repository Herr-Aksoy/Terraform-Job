terraform {
  required_providers {             
    aws = {
      source = "hashicorp/aws"
      version = "5.25.0"        ##Aws Provider versionu. Azure de kullanirken bu kisma ekleme yapilmasi gerekiyor.cd
    }
  }
}
provider "aws" {
  # Configuration options
}

  ##provider "aws" {
  ##region = "us-east-1"  # Kullanmak istediğiniz AWS bölgesini belirtin.
  ##access_key = "Aws den"
  ##secret_key = "Aws den"
  ## profile = ".aws nin altinda olusan config icerisine farkli profiller olusturabilirsin."
  ## Komut satirindan export ilede atanabiliyor.
  ## Yada actigimiz makinaya rol atayabiliriz.

resource "aws_default_vpc" "default" {      ## Bu kisim ile direk default Vpc ye baglaniyor yada olusturuyor
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_default_subnet" "default_az1" {   ## Default subnet kismi özellikle belirtmemiz gerekiyor mu?
  availability_zone = "us-west-2a"

  tags = {
    Name = "Default subnet for us-west-2a"
  }
}






resource "aws_instance" "TemaZ2H" {
  ami           = "ami-0e8a34246278c21e4"  # Kullanmak istediğiniz Amazon Machine Image (AMI) ID'sini belirtin.
  instance_type = "t2.micro"  # Kullanmak istediğiniz örnek tipini belirtin.
  key_name = "FileKey"
  # count = 5                   Bu bilgi ile istedigimiz kadar Ec2 ayaga kaldiriyoruz.
  vpc_security_group_ids = [aws_security_group.example.id]
  

  tags = {
    Name = "My-terra"
  }
}


# resource "aws_s3_bucket" "ilk_s3_terraform" {
#   bucket = "TeamZ2H"
  
# }

resource "aws_s3_bucket" "ilk_s3_terraform" {
  bucket = "benzersizbirisim"         ## Bu isim AWS müsterileri arasinda benzersiz olmasi gerek

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair#example-usage
# key_pair linki

resource "aws_key_pair" "Mykeypair" {
  key_name   = "FileKey"
  public_key = tls_private_key.rsa.public_key_openssh   #"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDax5ObisiESJa/u1/TK7mcDe2s+C9SFzaw3cRzZ0DyI41hyHH4H+s3O34Rxc4SjwWadQ99Gqi/GlMKCvyNSYs7HWfBCMi593ccHmIynqMvwoL5ufycLf18c5fGoKnVDo1pdWJLxCEjIf7NjB1w9S0d5AmGHILJcOchzzawrocGHOPt2V8NoctiOAKuJLkoyJY6+tRbMHl2SyuOiDAGf9V/bGWD96sBHYhqOtnytGslP0Zyt5vxis6rXgOIt+a5ALnhBJoZU3yAgObxClIsKlf2ZfFTQSqOLIG1oqa87HY1VDDm7qtWdi9B79om4rLSIkCtSTFvqUIZ6OVtUG0ATmn/ neu"
}

# https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key#example-usage
# privat-keyy linki

resource "tls_private_key" "rsa" {      ## otomatik public key olusturuyor.
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "Mykeypair" {
  content  = tls_private_key.rsa.private_key_pem    ## file yüklenecek icerik..
  filename = "FileKey.pem"
}

resource "aws_security_group" "example" {
  name        = "Terra_icin"
  description = "Ec2 direk baglaniyor"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}