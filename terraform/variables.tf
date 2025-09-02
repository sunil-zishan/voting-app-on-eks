variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  default = "10.0.1.0/24"
}

variable "private_subnet_b_cidr" {
  default = "10.0.2.0/24"
}

variable "private_subnet_c_cidr" {
  default = "10.0.3.0/24"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_name" {
  default = "sunil-key"
}

variable "ami_id" {
  default = "ami-00ca32bbc84273381"
}