# data "aws_ami" "ubuntu" {       ## Burasi Ubuntu icin gecerli. 
#   most_recent = true

#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }

#   owners = ["099720109477"] # Canonical
# }

# data "aws_ami" "linux" {                  ## Linux icin ama saglamasini yapamadim
#   most_recent = true                      ## Sanirim buda Ubuntu geliyor.

#   filter {
#     name = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*", "*linux*"]
#   }

#   owners = ["099720109477"]  
# }

# data "aws_ami" "amzn-linux-2023-ami" {
#   most_recent = true
#   owners      = ["amazon"]

#   filter {
#     name   = "name"
#     values = ["al2023-ami-2023.*-x86_64"]     # amazon/al2023-ami-2023.2.20231113.0-kernel-6.1-x86_64
#   }
# }


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
  key_name = "FileKey"
  subnet_id     = aws_subnet.PublicSubnet.id
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  # depends_on = [aws_instance.linux]  sira ile kalkmalari icin kullanilabilir.

  tags = {
    Name = "TerraTeams"
  }
}