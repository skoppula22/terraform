provider "aws" {
	region = "us-east-1"
}

resource "aws_launch_configuration" "example" {
	image_id = "ami-40d28157"
	instance_type = "t2.micro"
	security_groups = ["${aws_security_group.instance.id}"]

	user_data = <<-EOF
				#1/bin/bash
				echo "Hello, Nagesh Sainni how are you. " > index.html
				echo "What Dev buddy is doing ?" >> index.html
				nohup busybox httpd -f -p "${var.server_port}" &
				EOF

		lifecycle {
		create_before_destroy = true
	}
}

resource "aws_security_group" "instance"{
    name = "terraform-example-security-instance"

    ingress {
        from_port = var.server_port
        to_port = var.server_port
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

lifecycle {
		create_before_destroy = true
	}
}

data "aws_availability_zones" "all" {}

resource "aws_autoscaling_group" "example" {
    launch_configuration = "${aws_launch_configuration.example.name}"
    availability_zones = ["us-east-1a", "us-east-1b"]

    min_size = 2
    max_size =10

    tag {
        key = "Name"
        value = "terraform-asg-example"
        propagate_at_launch = true
    }
}