resource "aws_db_instance" "database" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.6.35"
  instance_class       = "db.t2.small"
  name                 = "DATABASE_GRUPO4"
  username             = "${var.username_rds}"
  password             = "${var.password_rds}"
  storage_encrypted    = "true"
  db_subnet_group_name = "${aws_db_subnet_group.rds_sn.id}"
  vpc_security_group_ids = ["${aws_security_group.small_rds_SG.id}"]
  backup_retention_period = 30
  backup_window        = "02:00-03:00"
  publicly_accessible  = "false"
}

resource "aws_security_group" "small_rds_SG" {
    name = "${var.environment}_small_rds_sg"
    description = "Allow incoming connections from Bastion or Backend."
    ingress {
			from_port = 3306
            to_port = 3306
            protocol = "tcp"
            security_groups = ["${aws_security_group.bastion.id}"]
        }
    ingress {
			from_port = 3306
            to_port = 3306
            protocol = "tcp"
            security_groups = ["${aws_security_group.backend.id}"]
        }
	vpc_id= "${aws_vpc.G4.id}"
	tags {
    Name = "${var.environment}_small_rds_sg"
    Project = "${var.project_name}"
  }
}


resource "aws_db_subnet_group" "rds_sn" {
    name = "main"
    subnet_ids = ["${aws_subnet.private_DB.id}", "${aws_subnet.private_DB_SECONDARY.id}"]
    tags {
        Name = "${var.environment}_DB_subn"
        Project = "${var.project_name}"
        
    }
}