variable "do_token" {
  description = "The provider token for DigitalOcean"
  type        = string
  sensitive   = true
}


variable "region" {
  default = "ams3"
}
