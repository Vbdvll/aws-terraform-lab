variable "region" {
  description = "Région AWS pour le déploiement"
  type        = string
  default     = "eu-north-1"
}

variable "vpc_cidr" {
  description = "Plage CIDR principale du VPC"
  type        = string
  default     = "192.168.0.0/16"
}

variable "subnet_public_cidr" {
  description = "Plage CIDR du sous-réseau public"
  type        = string
  default     = "192.168.1.0/24"
}

variable "subnet_prive_cidr" {
  description = "Plage CIDR du sous-réseau privé"
  type        = string
  default     = "192.168.2.0/24"
}