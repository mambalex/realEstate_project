################## Provision EC2/SG/EIP ##################
resource "aws_spot_instance_request" "myec2" {
  ami                             = var.ec2.ami
  instance_type                   = var.ec2.instance_type
  spot_price                      = var.ec2.spot_price
  instance_interruption_behaviour = var.ec2.instance_interruption_behaviour
  vpc_security_group_ids          = [aws_security_group.web_ssh_traffic.id]
  user_data                       = file("./install-docker.sh")
  key_name                        = var.ec2.key_name
  subnet_id                       = var.ec2.subnet_id
  tags = {
    Name = var.ec2.name
  }
  root_block_device {
    delete_on_termination = var.ec2.ebs_delete_on_termination
  }
}


resource "aws_eip_association" "eip_association" {
  instance_id   = aws_spot_instance_request.myec2.spot_instance_id
  allocation_id = var.eip_allocation_id
}


resource "aws_security_group" "web_ssh_traffic" {
  name   = "Allow HTTP/HTTPS/SSH"
  vpc_id = var.default_vpc_id

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
  value = "13.211.99.69"
}
