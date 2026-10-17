# ========================================================
# 1. RÉCUPÉRATION DYNAMIQUE DE L'AMI (DATA SOURCE)
# ========================================================
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# ========================================================
# 2. INSTANCE PUBLIQUE (SERVEUR WEB APACHE)
# ========================================================
resource "aws_instance" "serveur_web_public" {
  ami                         = data.aws_ami.amazon_linux_2023.id
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.subnet_public_a.id
  vpc_security_group_ids      = [aws_security_group.sg_web_public.id]
  associate_public_ip_address = true

  # Script d'initialisation automatique (User Data)
  user_data = <<-EOF
              #!/bin/bash
              dnf update -y
              dnf install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo '<h1>Validation reussie : Deploiement Terraform automatise !</h1>' > /var/www/html/index.html
              EOF

  tags = {
    Name = "Serveur-Web-VPC-Demo"
  }
}

# ========================================================
# 3. INSTANCE PRIVÉE (SERVEUR ISOLÉ)
# ========================================================
resource "aws_instance" "serveur_prive" {
  ami                         = data.aws_ami.amazon_linux_2023.id
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.subnet_prive_a.id
  vpc_security_group_ids      = [aws_security_group.sg_prive.id]
  associate_public_ip_address = false

  tags = {
    Name = "Serveur-Prive-Demo"
  }
}