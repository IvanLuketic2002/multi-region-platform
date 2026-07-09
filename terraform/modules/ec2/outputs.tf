output "public_ip" {
  value       = aws_instance.web.public_ip
  description = "Public IP adresa EC2 instance"
}
