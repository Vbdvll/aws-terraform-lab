# AWS Infrastructure as Code with Terraform

Ce dépôt contient le code Terraform (HCL) permettant de provisionner automatiquement une architecture réseau et de calcul sécurisée sur AWS dans la région `eu-north-1`.

## 🏗️ Architecture déployée

- **VPC dédié** : Plage CIDR `192.168.0.0/16`.
- **Sous-réseau Public (DMZ)** : `192.168.1.0/24` avec Internet Gateway et table de routage (`0.0.0.0/0`).
- **Sous-réseau Privé** : `192.168.2.0/24` strictement isolé d'Internet.
- **Filtrage de sécurité (Security Groups)** :
  - Groupe Web public autorisant le port 80 (HTTP).
  - Groupe privé autorisant uniquement les requêtes ICMP (Ping) en provenance du sous-réseau public.
- **Compute (EC2)** :
  - Serveur Web public (`t3.micro`) déployé avec bootstrapping automatique via User Data (`httpd`).
  - Serveur privé (`t3.micro`) isolé sans adresse IP publique.

## 📁 Structure du projet

- `provider.tf` : Configuration du provider AWS et contraintes de version.
- `variables.tf` : Paramétrage dynamique des plages CIDR et de la région.
- `vpc.tf` : Définition du réseau, des sous-réseaux, de l'IGW et du routage.
- `security.tf` : Règles de pare-feu d'état (Security Groups).
- `ec2.tf` : Data source AMI Amazon Linux 2023 dynamique et instances EC2.
- `outputs.tf` : Exposition de l'URL publique et de l'IP privée.

## 🚀 Déploiement

```bash
# 1. Initialisation
terraform init

# 2. Validation & Planification
terraform validate
terraform plan

# 3. Déploiement
terraform apply -auto-approve

# 4. Destruction propre (FinOps)
terraform destroy -auto-approve