resource "aws_key_pair" "ansible-key" {
  key_name = "ansible-key"
  public_key = file("${path.module}/rsa_id.pub")
}