resource "aws_instance" "db_node" {
  count         = var.db_node_count
  ami           = data.aws_ami.nixos_arm64.id
  instance_type = var.db_instance_type
  key_name      = var.default_key_name
  
  # spread the nodes between the available zones
  availability_zone = data.aws_availability_zones.available.names[
    count.index % length(data.aws_availability_zones.available.names)
  ]
  tags = {
    Name = format("db-node-%02d", count.index + 1)
  }

  ebs_block_device {
    device_name = "/dev/xvda"  # Dispositivo raiz
    volume_size = 20           # Tamanho em GB
    volume_type = "gp3"        # Tipo de volume (gp2, gp3, io1, io2, etc.)
  }

  ## TODO: make this dynamic
  ebs_block_device {
    device_name = "/dev/sdb"
    volume_size = var.db_disk_size
    volume_type = var.db_disk_type
  }

  ebs_block_device {
    device_name = "/dev/sdc"
    volume_size = var.db_disk_size
    volume_type = var.db_disk_type
  }

  ebs_block_device {
    device_name = "/dev/sdd"
    volume_size = var.db_disk_size
    volume_type = var.db_disk_type
  }
}

output "db_cluster_public_dns" {
  value = {
    for instance in aws_instance.db_node : instance.tags.Name => instance.public_dns
  }
  description = "DB Cluster: Public DNS"
}

