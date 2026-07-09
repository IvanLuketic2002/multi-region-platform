variable "primary_region" {
  type        = string
  default     = "eu-central-1"
  description = "Primarni AWS region (Evropa - Frankfurt)"
}

variable "environment" {
  type        = string
  default     = "production"
  description = "Okruženje u kome se resursi podižu"
}

