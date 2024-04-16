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
  ami                     = data.aws_ssm_parameter.amzn2_latest_ami.value # last parameter is the default value
#  ami = "ami-0821549eeea15770b" #ubunt20.04
  instance_type           = "t3.small"
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
    volume_size           = 10
    volume_type           = "gp3"
    delete_on_termination = true
    tags = {
      Name = "radio-ebs"
    }
  }

}



output "server_public_ip" {
  description = "The public IP address assigned to the instanceue"
  value       = aws_instance.raido-rec.public_ip
}


# sudo yum install install git gcc gcc-c++ readline-devel openssl-devel libyaml-devel zlib-devel
# wget -c https://cache.ruby-lang.org/pub/ruby/3.2/ruby-3.2.3.tar.gz
# tar zxvf ruby-3.2.3.tar.gz
# cd ruby-3.2.3
# ./configure
# make
# make install
# gem install rails -v 3.2.3 -N

# tep 4/20 : ENV RAILS_ENV="production"     BUNDLE_DEPLOYMENT="1"     BUNDLE_PATH="/usr/local/bundle"     BUNDLE_WITHOUT="development"
#  ---> Using cache
#  ---> ecca391c60b9
# Step 5/20 : FROM base as build
#  ---> ecca391c60b9
# Step 6/20 : RUN apt-get update -qq &&     apt-get install --no-install-recommends -y build-essential git libvips pkg-config
#  ---> Using cache
#  ---> 3c83d8929284
# Step 7/20 : COPY Gemfile Gemfile.lock ./
#  ---> Using cache
#  ---> f70fe7f5ab1c
# Step 8/20 : RUN bundle install &&     rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git &&     bundle exec bootsnap precompile --gemfile
#  ---> Running in 6af7ef527912
# Bundler 2.4.19 is running, but your lockfile was generated with 2.3.14. Installing Bundler 2.3.14 and restarting using that version.
# Fetching gem metadata from https://rubygems.org/.
# Fetching bundler 2.3.14
# Installing bundler 2.3.14
# Fetching gem metadata from https://rubygems.org/.........
# Fetching rake 13.1.0
# Installing rake 13.1.0
# Fetching base64 0.2.0
# Installing 


#### CentOSのEBS追加のための検証

# resource "aws_instance" "db_ec201" {
#   ami                         = "ami-0d2241a860961c70e"
#   instance_type               = "t3.nano"
#   subnet_id                   = aws_subnet.public_subnet_1a.id
#   key_name                    = "radio"

#   associate_public_ip_address = true

#   vpc_security_group_ids = [
#     aws_security_group.radio_sg.id
#   ]

#   root_block_device {
#     volume_size           = 8
#     volume_type           = "gp2"
#     delete_on_termination = true
#     tags = {
#       Name = "maintenance-ec2-ebs"
#     }
#   }

#   tags = {
#     Name = "db-ec201"
#   }
# }

# output "server_public_ip" {
#   description = "The public IP address assigned to the instanceue"
#   value       = aws_instance.db_ec201.public_ip
# }




