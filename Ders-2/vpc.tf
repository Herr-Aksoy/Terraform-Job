

# resource "aws_default_vpc" "default" {       default icin bu sekilde kullaniliyor
#   tags = {
#     Name = "Default VPC"
#   }
# }


# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
# link üstde

#Step 1: Create a VPC
resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "MyTerraformVPC"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
# üstdeki linkden


#Step 2: Create a public subnet
resource "aws_subnet" "PublicSubnet" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true          ## Ec2 ya Public IP atamasi icin gerekli. OLmayinca atamiyor

  tags = {
    Name = "PublicSubnet"
  }
}


#Step 3: create aprivate subnet
resource "aws_subnet" "PrivatSubnet" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.2.0/24"                        ## Ayni sekilde burasi degisik
  

  tags = {
    Name = "PrivatSubnet"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/3.6.0/docs/resources/internet_gateway
# link üste

#Step 4: Create IGW
resource "aws_internet_gateway" "igw" {
    vpc_id     = aws_vpc.myvpc.id
    
    tags = {
    Name = "internetgateway"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
# linkinden


#Step 5: route Tables for public subnet
resource "aws_route_table" "PublicRT" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"                          ## Bu kismi degistirdik
    gateway_id = aws_internet_gateway.igw.id
  }

  # route {                                         ## Bu kismi eleman yazmadi
  #   ipv6_cidr_block        = "::/0"
  #   egress_only_gateway_id = aws_egress_only_internet_gateway.example.id
  # }

   tags = {
    Name = "PublicRT"
   }
}

resource "aws_route_table" "PrivatRT" {     # Bunu olusturmamizin sebebi baska S3 vs baglatisi icinmis
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "10.0.0.0/16"  
    gateway_id = "local"              # Bu kisimi belirtmesekte otomatik local RT olusuyor sanirim.
  }

  tags = {
    Name = "team1_routetable_private"
  }
}



#Step 7: route table association public subnet
resource "aws_route_table_association" "PublicRTassociation" {
  subnet_id      = aws_subnet.PublicSubnet.id                   ## Neden public ID yazilyor
  route_table_id = aws_route_table.PublicRT.id
}


resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.PrivatSubnet.id
  route_table_id = aws_route_table.PrivatRT.id
}