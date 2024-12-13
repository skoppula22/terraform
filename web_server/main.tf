provider "aws" {
	region = "us-east-1"
}

resource "aws_instance" "example" {
	ami = "ami-40d28157"
	instance_type = "t2.micro"
	vpc_security_group_ids = [aws_security_group.instance.id]	

	user_data = <<-EOF
				#!/bin/bash
				echo "Hi, Nagesh Sainni how are you. " > index.html
				echo "What Dev buddy is doing ?" >> index.html
				nohup busybox httpd -f -p "${var.server_port}" &
				EOF
	
	tags = {
	Name = "terraform-example"
    }
}

resource "aws_security_group" "instance" {
	name = "terraform-example-instace"

	ingress {
		from_port = var.server_port
		to_port = var.server_port
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}
}


