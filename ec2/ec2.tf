resource "aws_instance" "web" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id = var.subnet_id
  user_data = file("scripts/web-server-setup.sh")
  vpc_security_group_ids = [aws_security_group.web-server_sg.id]

  tags = merge(var.tags, { 
    Name = "${var.tags["Project"]}-${var.tags["Application"]}-${var.tags["Environment"]}-server"
     })
}

resource "aws_security_group" "web-server_sg" {
  name        = "${var.tags["Project"]}-${var.tags["Application"]}-${var.tags["Environment"]}-web-server-sg"
  description = "Allow web traffic"
  vpc_id = var.vpc_id

  ingress {
    description      = "traffic port"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

    ingress {
    description      = "traffic port"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(var.tags, { 
    Name = "${var.tags["Project"]}-${var.tags["Application"]}-${var.tags["Environment"]}-web-server-sg"
})
}