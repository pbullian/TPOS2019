resource "aws_instance" "backend" {
  connection {
    # The default username for our AMI
    user = "ubuntu"

  }
  private_ip = "10.9.2.100"

  instance_type = "t2.micro"
  availability_zone = "${var.principal_availability_zone}"
  ami = "${lookup(var.default_ami_ubuntu, var.aws_region)}"

  key_name = "pablo"
  vpc_security_group_ids = ["${aws_security_group.backend.id}"]

  
  subnet_id = "${aws_subnet.backend.id}"
  tags {
    Name = "${var.environment}_BACKEND_vm"     
    Project = "${var.project_name}"
  }
  root_block_device {
        volume_size = 20
  } 

}


# security group

resource "aws_security_group" "backend" {    name = "${var.environment}_backend_sg"
    description = "Allow incoming HTTP connections from frontend G4."
 ingress {
			from_port = 80
            to_port = 80
            protocol = "tcp"
            security_groups = ["${aws_security_group.frontend.id}"]
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
           egress {
                from_port = 3306
                to_port = 3306
                protocol = "tcp"
                security_groups = ["sg-05986a3d01dc640b4"]
        } 

       

    vpc_id= "${aws_vpc.G4.id}"
 tags {
    Name = "${var.environment}_backend_sg"
    Project = "${var.project_name}"
  }


}
