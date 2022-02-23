variable "location" {
  description = "aws region"
  default     = "us-east-1"
  type        = string

}

variable "cidr" {
  description = "vpc cidr block"
  default     = "10.0.0.0/24"
  type        = string
  validation {
    condition     = substr(var.cidr, 0, 1) == "1"
    error_message = "Not a valid cidr for vpc creation?"
  }
}

variable "cidr_subnet" {
  description = "subnet cidr block"
  type        = string
}


variable "type" {
  description = "Instance type"
  type        = string
  default     = "t2.micro"
}

variable "az" {
  description = "availibilty zone for subnet creation"
  type= string
  default = "ap-south-1a"
}

variable "env" {
  description = "Environemnt in which instance needs to be raised"
  type = map(string)
  default = {
    "Env1" = "DEV","Env2"="QA"
  }
}

variable "Ingress" {
  type = list(object({
    port=number
    protocol=string
    description=string
    cidr=list(string)
  }))
  default = [ {
    cidr = [ "0.0.0.0/0" ]
    description = "for port 22"
    port = 22
    protocol = "tcp"
  }, {
    cidr = [ "0.0.0.0/0" ]
    description = "for port 80"
    port = 80
    protocol = "tcp"
  }, {
    cidr = [ "0.0.0.0/0" ]
    description = "for port 8080"
    port = 8080
    protocol = "tcp"
  }]
}