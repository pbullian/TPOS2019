resource "aws_vpc" "G4" {
    cidr_block = "${var.vpc_cidr}"
    enable_dns_hostnames = true
    assign_generated_ipv6_cidr_block = true
    tags {
        Environment = "${var.environment}"
        Name = "${var.environment}_CLOUD_vpc"
    }
}

#Internet GW
resource "aws_internet_gateway" "default" {
    vpc_id = "${aws_vpc.G4.id}"
    tags {
        Environment = "${var.environment}"
        Name = "${var.environment}_CLOUD_ig"
    }

  }

# NAT GW
resource "aws_eip" "nat_eip" {
  vpc      = true
    tags {
        Environment = "${var.environment}"
        Name = "${var.environment}_CLOUD_natgw"
    }
}

resource "aws_nat_gateway" "nat_gw" {
        allocation_id = "${aws_eip.nat_eip.id}"
    subnet_id = "${aws_subnet.public.id}"
    tags {
        Environment = "${var.environment}"
        Name = "${var.environment}_CLOUD_natgw"
    }

  }


# resource "aws_flow_log" "vpc_flow_log" {
# traffic_type   = "ALL"
# vpc_id         = "${aws_vpc.G4.id}"
# log_group_name = "VPCFlowlogUE1"
# iam_role_arn   = "arn:aws:iam::518378992056:role/flowlogsRole"
# }  

#  Public Facing Subnet

resource "aws_subnet" "public" {
    vpc_id = "${aws_vpc.G4.id}"
    availability_zone = "${var.principal_availability_zone}"

    cidr_block = "${var.public_subnet}"

 tags {
    Name = "${var.environment}_PUBLIC_sn"
    Project = "${var.project_name}"
    Environment = "${var.environment}"

  }

}

 ## route table for public

resource "aws_route_table" "public" {
    vpc_id = "${aws_vpc.G4.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.default.id}"
    }
 tags {
    Name = "${var.environment}_PUBLIC_rt"
    Project = "${var.project_name}"
  }

}

resource "aws_route_table_association" "public" {
    subnet_id = "${aws_subnet.public.id}"
    route_table_id = "${aws_route_table.public.id}"
}


#  backend Subnet

resource "aws_subnet" "backend" {
    vpc_id = "${aws_vpc.G4.id}"
    availability_zone = "${var.principal_availability_zone}"

    cidr_block = "${var.backend_subnet}"

 tags {
    Name = "${var.environment}_BACKEND_sn"
    Project = "${var.project_name}"
    Environment = "${var.environment}"

  }

}

 ## route table for backend

resource "aws_route_table" "backend" {
    vpc_id = "${aws_vpc.G4.id}"

	route {
  	    cidr_block = "0.0.0.0/0"
    	    gateway_id = "${aws_nat_gateway.nat_gw.id}"
    	}

 tags {
    Name = "${var.environment}_BACKEND_rt"
    Project = "${var.project_name}"
  }

}


resource "aws_route_table_association" "backend" {
    subnet_id = "${aws_subnet.backend.id}"
    route_table_id = "${aws_route_table.backend.id}"
}

resource "aws_network_acl" "backend" {
  vpc_id = "${aws_vpc.G4.id}"
  subnet_ids = ["${aws_subnet.backend.id}"]
  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "10.9.1.0/24"
    from_port  = 0
    to_port    = 65535
  }

    ingress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "10.9.100.0/24"
    from_port  = 0
    to_port    = 65535
  }

      ingress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = "10.9.3.0/24"
    from_port  = 0
    to_port    = 65535
  }
tags {
    Name = "${var.environment}_BACKEND_nacl"
    Project = "${var.project_name}"
    Environment = "${var.environment}"
}
}


#  Private DB Subnet

resource "aws_subnet" "private_DB" {
    vpc_id = "${aws_vpc.G4.id}"
    availability_zone = "${var.principal_availability_zone}"

    cidr_block = "${var.private_subnet_db_cidr}"
 tags {
    Name = "${var.environment}_DB_sn"
    Project = "${var.project_name}"
  }

}

resource "aws_route_table" "private_DB" {
    vpc_id = "${aws_vpc.G4.id}"

 tags {
    Name = "${var.environment}_DB_rt"
    Project = "${var.project_name}"
  }

}

resource "aws_route_table_association" "private_DB" {
    subnet_id = "${aws_subnet.private_DB.id}"
    route_table_id = "${aws_route_table.private_DB.id}"
}

resource "aws_subnet" "private_DB_SECONDARY" {
    vpc_id = "${aws_vpc.G4.id}"
    availability_zone = "${var.secondary_availability_zone}"

    cidr_block = "${var.private_subnet_db_secondary_cidr}"
 tags {
    Name = "${var.environment}_DB_SECONDARY_sn"
    Project = "${var.project_name}"
  }

}

resource "aws_route_table" "private_DB_SECONDARY" {
    vpc_id = "${aws_vpc.G4.id}"

 tags {
    Name = "${var.environment}_DB_SECONDARY_rt"
    Project = "${var.project_name}"
  }

}

resource "aws_route_table_association" "private_DB_SECONDARY" {
    subnet_id = "${aws_subnet.private_DB_SECONDARY.id}"
    route_table_id = "${aws_route_table.private_DB_SECONDARY.id}"
}

resource "aws_network_acl" "db" {
  vpc_id = "${aws_vpc.G4.id}"
  subnet_ids = ["${aws_subnet.private_DB_SECONDARY.id}","${aws_subnet.private_DB.id}"]
  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "10.9.2.0/24"
    from_port  = 0
    to_port    = 65535
  }
tags {
    Name = "${var.environment}_DATABASE_nacl"
    Project = "${var.project_name}"
    Environment = "${var.environment}"
}
}
  #Private BASTION Subnet

resource "aws_subnet" "private_BASTION" {
    vpc_id = "${aws_vpc.G4.id}"
    availability_zone = "${var.principal_availability_zone}"

    cidr_block = "${var.private_subnet_bastion}"
 tags {
    Name = "${var.environment}_BASTION_sn"
    Project = "${var.project_name}"
  }

}

resource "aws_route_table" "private_BASTION" {
    vpc_id = "${aws_vpc.G4.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.default.id}"
    }

 tags {
    Name = "${var.environment}_BASTION_rt"
    Project = "${var.project_name}"
  }

}

resource "aws_route_table_association" "private_BASTION" {
    subnet_id = "${aws_subnet.private_BASTION.id}"
    route_table_id = "${aws_route_table.private_BASTION.id}"
}