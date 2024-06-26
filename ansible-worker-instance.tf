resource "aws_instance" "ansible-worker-instance" {
  ami = "ami-07b36ea9852e986ad"
  instance_type = "t2.micro"
  key_name = aws_key_pair.ansible-key.key_name
  vpc_security_group_ids = ["${aws_security_group.ansible_security_group.id}"]
tags = {
   Name = "ansible-worker-instance"
}
 connection {
    type        = "ssh"
    user        = "ubuntu" 
    private_key = file("${path.module}/rsa_id.pem")
     host        = self.public_ip
  }

provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo echo 'ubuntu:worker@123' | sudo chpasswd",
      "sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config",
      "sudo service ssh reload",
      ]
  }


}
