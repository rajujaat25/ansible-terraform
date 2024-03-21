resource "aws_instance" "ansible-master-instance" {
  ami = "ami-07b36ea9852e986ad"
  instance_type = "t2.micro"
  key_name = "ansible-terraform"
  vpc_security_group_ids = ["${aws_security_group.ansible_security_group.id}"]
tags = {
   Name = "ansible-master-instance"
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
      "sudo echo 'ubuntu:ansible@123' | sudo chpasswd",
      "sudo apt-get install -y ansible",
      "sudo apt install sshpass -y",
      "sudo chmod 755 /etc/ansible/hosts",
      "sudo echo 'webserver1 ansible_host=${aws_instance.ansible-worker-instance.public_ip} ansible_ssh_pass=worker@123  ansible_user=ubuntu' >> /etc/ansible/hosts",
      "sudo sed -i '/^#host_key_checking/s/^#//' /etc/ansible/ansible.cfg",
      "sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config",
      "sudo sed -i '/^#PermitRootLogin/s/^#//' /etc/ssh/sshd_config",
      "sudo sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config",
      "sudo service ssh reload"
    ]
  }


}
