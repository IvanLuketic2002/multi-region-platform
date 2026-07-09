output "primary_instance_public_ip" {
  value       = module.ec2_primary.public_ip
  description = "Javna IP adresa EC2 servera u primarnom regionu"
}

output "secondary_instance_public_ip" {
  value       = module.ec2_secondary.public_ip
  description = "Public IP adresa EC2 instance u sekundarnom regionu"
}
