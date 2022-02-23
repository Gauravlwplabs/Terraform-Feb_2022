#for loop in terraform

variable "list" {
  type = list(string)
  default = [ "Name",23,true ]
}

variable "tuple" {
  type = tuple([string,number,bool])
  default = ["Name",34,false]
}

variable "set" {
  type = set(string)
  default=["Name","Python","AWS","Name"]
}

variable "map" {
  type = map(any)
  default = {
    "Name" = "Guarav"
    "Roll No"=102
    "flag"=true
  }
}

variable "object" {
  type = object({
      port=number
      protocol=string
      description=string
      cidr=string
  })
  default = {
    cidr = "10.0.0.0/24"
    description = "Opening port 22"
    port = 22
    protocol = "tcp"
  }
}



variable "map-object" {
  type = map(object({
      Name=string
      Roll=number
      flag=bool
  }))
  default = {
    "Studnet" = {
      Name = "Gaurav"
      Roll = 1
      flag = false
    }
  }  
}

variable "string" {
  type = string
  default = null
}

variable "Name" {
  type = string
}


