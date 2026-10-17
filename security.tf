# ========================================================
# 1. SECURITY GROUP : SERVEUR WEB (PUBLIC)
# ========================================================
resource "aws_security_group" "sg_web_public" {
  name        = "SG-Web-Public-Demo"
  description = "Autorise le trafic HTTP entrant depuis Internet et tout le trafic sortant"
  vpc_id      = aws_vpc.vpc_demo.id

  # Règle entrante : HTTP (Port 80) ouvert au monde
  ingress {
    description = "Acces HTTP public"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Règle sortante : Autorise tout le trafic vers l'extérieur (mises à jour, requêtes web)
  egress {
    description = "Trafic sortant illimite"
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # -1 indique tous les protocoles
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SG-Web-Public-Demo"
  }
}

# ========================================================
# 2. SECURITY GROUP : SERVEUR ISOLÉ (PRIVÉ)
# ========================================================
resource "aws_security_group" "sg_prive" {
  name        = "SG-Prive-Demo"
  description = "Autorise le ping ICMP interne uniquement depuis la zone publique"
  vpc_id      = aws_vpc.vpc_demo.id

  # Règle entrante : ICMP (Echo Request / Ping) restreint au CIDR du sous-réseau public
  ingress {
    description = "Autorise le ping ICMP depuis le sous-reseau public uniquement"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.subnet_public_cidr] # Utilise 192.168.1.0/24 defini dans variables.tf
  }

  # Règle sortante par défaut
  egress {
    description = "Trafic sortant interne"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SG-Prive-Demo"
  }
}