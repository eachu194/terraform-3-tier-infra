variable "instance_type" {
    type = string
    description = "instance type"
    default = "t2.micro"
}

variable "ami" {
    type = string
    description = "machine image"
    default = "ami-05c13eab67c5d8861"
}

variable "tags" {
    type = map(string)
    description = "tags"
}

variable "subnet_id" {
    type = string
    description = "public subnet to launch instance"
}

variable "vpc_id" {
    type = string
    description = "vpc id to launch sg"
}