/*resource "aws_instance" "main_node" {
  count= var.create_instance && !var.create_spot_instance?var.instance_count:0
  ami           = var.ami
  instance_type = var.instance_type
  availability_zone      = var.az
  cpu_core_count         = var.cpu_core_count
  cpu_threads_per_core   = var.cpu_threads_per_core
  hibernation            = var.hibernation
  key_name               = var.key_name
  monitoring             = var.monitoring
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_groups]
  user_data              = file(var.path)
  tags = {
    Name = var.instanceTag
  }
  root_block_device {
    volume_size = var.ebs_size
  }
  provisioner "local-exec" {
    command = templatefile("${var.host_os}-ssh-config.tpl", {
      hostname     = self.public_ip,
      user         = "ubuntu",
      identityfile = "~/.ssh/main_key"
    })
    interpreter = var.host_os == "windows" ? ["Powershell", "-Command"] : ["bash", "-c"]
  }
}
*/
