output "url_serveur_web" {
  description = "URL publique pour tester le serveur Apache dans le navigateur"
  value       = "http://${aws_instance.serveur_web_public.public_ip}"
}

output "ip_privee_serveur_isole" {
  description = "Adresse IP privee interne du serveur prive"
  value       = aws_instance.serveur_prive.private_ip
}