variable "private_subnet1" {
    type = string
    description = "private subnet 1"
}

variable "private_subnet2" {
    type = string
    description = "private subnet 2"
}

variable "tags" {
    type = map(string)
    description = "tags"
}

variable "vpc_cidr" {
    type = string
    description = "vpc cidr range"
}

variable "vpc_id" {
    type = string
    description = "vpc id"
}