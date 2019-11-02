resource "aws_instance" "frontend" {
  connection {
    # The default username for our AMI
    user = "ubuntu"

  }
  private_ip = "10.9.1.100"

  instance_type = "t2.micro"
  availability_zone = "${var.principal_availability_zone}"
  ami = "${lookup(var.default_ami_ubuntu, var.aws_region)}"
  iam_instance_profile = "cloudwatchlogs"
  key_name = "pablo"
  vpc_security_group_ids = ["${aws_security_group.frontend.id}"]

  
  subnet_id = "${aws_subnet.public.id}"
  tags {
    Name = "${var.environment}_FRONTEND_vm"     
    Project = "${var.project_name}"
  }
  root_block_device {
        volume_size = 20
  } 

}
resource "aws_eip" "frontend_eip" {
  vpc      = true
    instance = "${aws_instance.frontend.id}"
    tags {
        Environment = "${var.environment}"
        Name = "${var.environment}_CLOUD_frontend_eip"
    }
}

# security group

resource "aws_security_group" "frontend" {
    name = "${var.environment}_FRONTEND_sg"
    description = "Allow incoming HTTP/S connections."
 	ingress {
        	from_port = 80
        	to_port = 80
        	protocol = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        }

 	ingress {
        	from_port = 443
        	to_port = 443
        	protocol = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        }
  
        ingress {
                from_port = 22
                to_port = 22
                protocol = "tcp"
                security_groups = ["${aws_security_group.bastion.id}"]
        }

        egress {
                from_port = 80
                to_port = 80
                protocol = "tcp"
                cidr_blocks = ["0.0.0.0/0"]
        }
        egress {
                from_port = 443
                to_port = 443
                protocol = "tcp"
                cidr_blocks = ["0.0.0.0/0"]
        }
       

       

    vpc_id= "${aws_vpc.G4.id}"
 tags {
    Name = "${var.environment}_FRONTEND_sg"
    Project = "${var.project_name}"
  }


}
