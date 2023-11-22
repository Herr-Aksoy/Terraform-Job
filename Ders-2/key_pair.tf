## key_name mi Ec2 nun altinda belirmelisin.

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

resource "local_file" "Mykeypair" {     ##File direk calistirdigin yerde olusturuyor
  content  = tls_private_key.rsa.private_key_pem    ## file yüklenecek icerik..
  filename = "FileKey.pem"                  # Buraya sanirim path uzanti yolu yazilabilir sanirim.
  # file_permission = "0400"  # Dosya iznini chmod 400 yapiyor
}

resource "null_resource" "change_permissions" {         # Bu resource ile localde olusturdugum seyleri degistirebiliyorum
  depends_on = [ local_file.Mykeypair ]                 # File bulamadigindan beklemesi icin yazdim
  provisioner "local-exec" {                            # Yine ayni chmod 400 yapiyoruz
    command = "chmod 400 /home/ec2-user/2.Bulusma/FileKey.pem"    # Buraya direk file yazsamda calisir muhtemelen.Ama denemedim.
  }
}
