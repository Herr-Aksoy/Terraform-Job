resource "aws_security_group" "example" {
  name        = "example-security-group"
  description = "Allow all traffic"

  # Gelen ve giden tüm trafiği kabul etmek için "0.0.0.0/0" olarak belirtilir.
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}