variable "location" {
  description = "aws region"
  default = "us-east-1"
  type = string

}

variable "cidr" {
  description = "vpc cidr block"
  default = "10.0.0.0/24"
  type = string
  validation {
    condition = substr(var.cidr, 0, 1)=="1"
    error_message = "Not a valid cidr for vpc creation?"
  }
}

variable "cidr_subnet" {
  description = "subnet cidr block"
  type = string
}