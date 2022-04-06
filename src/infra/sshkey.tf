resource "aws_key_pair" "ssh_public_key" {
  key_name   = "ssh_public_key"
  public_key = file(var.PUBLIC_KEY)
}
