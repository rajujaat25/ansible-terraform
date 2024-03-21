resource "aws_security_group" "ansible_security_group" {
name = "ansible-security-group"
description = "ansible-security-group inbound traffic and all outbound traffic"


dynamic "ingress" {
   for_each = [0]
   iterator = port
   content {
     from_port = port.value
     to_port = port.value
     protocol = "-1"
     cidr_blocks = ["0.0.0.0/0"]
   }
}
egress  {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
}
}

