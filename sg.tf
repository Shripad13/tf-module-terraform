resource "aws_security_group" "main" {
  name        = "${var.name}-${var.env}"
  description = "Allows app traffic"



 ingress {
  description = "Allows SSH"    
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  }

ingress {
  description = "Allows APP"    
  from_port   = var.port_no
  to_port     = var.port_no 
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]     # Allow any IP address
  }

egress {
  from_port   = 0
  to_port     = 0
  protocol    = "-1"                 # -1 means all protocols TCP & UDP
  cidr_blocks = ["0.0.0.0/0"]
  }
  }