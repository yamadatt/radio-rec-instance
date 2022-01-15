# ENI

resource "aws_network_interface" "raido-rec" {
  subnet_id       = aws_subnet.public_subnet_1a.id
  security_groups = [aws_security_group.radio_sg.id]

  tags = {
    Name = "radio"
  }
}

# EC2

data "aws_ssm_parameter" "amzn2_latest_ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

resource "aws_instance" "raido-rec" {
  ami           = data.aws_ssm_parameter.amzn2_latest_ami.value # last parameter is the default value
  instance_type = "t2.micro"
  disable_api_termination = false
  monitoring              = false
  key_name                = "radio"
  network_interface {
    network_interface_id = aws_network_interface.raido-rec.id
    device_index         = 0
  }
}


output "server_public_ip" {
  description = "The public IP address assigned to the instanceue"
  value       = aws_instance.raido-rec.public_ip
}

