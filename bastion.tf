resource "aws_instance" "BASTION" {
  connection {
    # The default username for our AMI
    user = "ubuntu"

  }

  instance_type = "t2.micro"

  ami = "${lookup(var.default_ami_ubuntu, var.aws_region)}"
  availability_zone = "${var.principal_availability_zone}"
  key_name = "pablo"
  vpc_security_group_ids = ["${aws_security_group.bastion.id}"]

  associate_public_ip_address = true

  subnet_id = "${aws_subnet.private_BASTION.id}"
  tags {
    Name = "${var.environment}_BASTION_vm"     
    Project = "${var.project_name}"
  }
  root_block_device {
        volume_size = 20
  } 



}


resource "aws_security_group" "bastion" {
    name = "${var.environment}_BASTION_sg"
    description = "Allow incoming SSH connections."
 	ingress {
        	from_port = 22
        	to_port = 22
        	protocol = "tcp"
        	cidr_blocks = ["34.202.194.235/32", "3.215.238.157/32"]
        }

  
	egress { # all
  	        from_port = 0
        	to_port = 65535
        	protocol = "tcp"
        	cidr_blocks = ["0.0.0.0/0"]
    }

    vpc_id = "${aws_vpc.G4.id}"
 tags {
    Name = "${var.environment}_BASTION_sg"
    Project = "${var.project_name}"
  }


}

