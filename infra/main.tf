################## Provision EC2/SG/EIP ##################
resource "aws_instance" "myec2" {
  ami             = "ami-09f765d333a8ebb4b"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.web_ssh_traffic.name]
  user_data       = file("./install-docker.sh")
  tags = {
    Name        = "RealEstate app - Django"
    Environment = "Production"
  }
  root_block_device {
    delete_on_termination = false
  }
}

resource "aws_eip" "elastic_ip" {
  instance = aws_instance.myec2.id
}

variable "ingress_rules" {
  type    = list(number)
  default = [80, 443, 22]
}

variable "egress_rules" {
  type    = list(number)
  default = [80, 443, 22]
}

resource "aws_security_group" "web_ssh_traffic" {
  name = "Allow HTTP/HTTPS/SSH"

  dynamic "ingress" {
    iterator = port
    for_each = var.ingress_rules
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  dynamic "egress" {
    iterator = port
    for_each = var.egress_rules
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

output "public_ip" {
  value = aws_eip.elastic_ip.public_ip
}


################## Auto start&stop EC2 ##################
