data "aws_ami" "nixos_arm64" {
  owners      = ["427812963091"]
  most_recent = true

  filter {
    name   = "name"
    values = ["nixos/24.05*"]
  }
  filter {
    name   = "architecture"
    values = ["arm64"]
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}