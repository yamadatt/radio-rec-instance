# ENI

resource "aws_network_interface" "raido-rec" {
  subnet_id       = aws_subnet.public_subnet_1a.id
  security_groups = [aws_security_group.radio_sg.id]

  tags = {
    Name = "radio"
  }
}


data "aws_ssm_parameter" "amzn2_latest_ami" {
  #  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-6.1-x86_64"



}

resource "aws_instance" "raido-rec" {
  ami = data.aws_ssm_parameter.amzn2_latest_ami.value # last parameter is the default value
  #  ami = "ami-0821549eeea15770b" #ubunt20.04
  instance_type           = "t3.nano"
  disable_api_termination = false
  monitoring              = false
  key_name                = "radio"
  network_interface {
    network_interface_id = aws_network_interface.raido-rec.id
    device_index         = 0
  }
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  root_block_device {
    volume_size           = 8
    volume_type           = "gp2"
    delete_on_termination = true
    tags = {
      Name = "radio-ebs"
    }
  }

  iam_instance_profile = aws_iam_instance_profile.ec2_s3_profile.name


}



output "server_public_ip" {
  description = "The public IP address assigned to the instanceue"
  value       = aws_instance.raido-rec.public_ip
}


resource "aws_iam_instance_profile" "ec2_s3_profile" {
  name = aws_iam_role.ec2_s3_role.name
  role = aws_iam_role.ec2_s3_role.name
}

# IAM Role

resource "aws_iam_role" "ec2_s3_role" {
  name               = "yamada_ec2_s3_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# IAM Policy

resource "aws_iam_policy" "ec2_s3_policy" {
  name        = "yamada_ec2_s3_policy"
  description = "Allows EC2 instances to have full access to S3"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": "*"
    }
  ]
}
EOF
}

# IAM Role Policy Attachment

resource "aws_iam_role_policy_attachment" "ec2_s3_role_attachment" {
  role       = aws_iam_role.ec2_s3_role.name
  policy_arn = aws_iam_policy.ec2_s3_policy.arn
}


