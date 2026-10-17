# ========================================================
# 1. LE VPC (VIRTUAL PRIVATE CLOUD)
# ========================================================
resource "aws_vpc" "vpc_demo" {
  cidr_block           = var.vpc_cidr # Utilise la variable définie dans variables.tf (192.168.0.0/16)
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "VPC-TP-Demo"
  }
}

# ========================================================
# 2. L'INTERNET GATEWAY (IGW)
# ========================================================
resource "aws_internet_gateway" "igw_demo" {
  # Référence croisée : on lie l'IGW à l'identifiant réel du VPC généré par AWS
  vpc_id = aws_vpc.vpc_demo.id

  tags = {
    Name = "IGW-TP-Demo"
  }
}

# ========================================================
# 3. LES SOUS-RÉSEAUX (PUBLIC & PRIVÉ)
# ========================================================

# Sous-réseau Public (DMZ)
resource "aws_subnet" "subnet_public_a" {
  vpc_id                  = aws_vpc.vpc_demo.id
  cidr_block              = var.subnet_public_cidr # 192.168.1.0/24
  availability_zone       = "${var.region}a"      # ex: eu-north-1a
  map_public_ip_on_launch = true                  # Attribution automatique d'IP publique !

  tags = {
    Name = "Subnet-Public-A"
  }
}

# Sous-réseau Privé (Zone isolée)
resource "aws_subnet" "subnet_prive_a" {
  vpc_id                  = aws_vpc.vpc_demo.id
  cidr_block              = var.subnet_prive_cidr # 192.168.2.0/24
  availability_zone       = "${var.region}a"      # Même zone de disponibilité
  map_public_ip_on_launch = false                 # Pas d'IP publique pour ce sous-réseau

  tags = {
    Name = "Subnet-Prive-A"
  }
}

# ========================================================
# 4. ROUTAGE POUR LE SOUS-RÉSEAU PUBLIC
# ========================================================

# Table de routage avec la route vers l'IGW
resource "aws_route_table" "rt_public" {
  vpc_id = aws_vpc.vpc_demo.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_demo.id
  }

  tags = {
    Name = "RT-Public"
  }
}

# Association explicite : on relie la table au Subnet-Public-A
resource "aws_route_table_association" "rta_public" {
  subnet_id      = aws_subnet.subnet_public_a.id
  route_table_id = aws_route_table.rt_public.id
}