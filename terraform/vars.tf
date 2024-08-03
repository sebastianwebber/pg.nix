variable "default_key_name" {
  default     = "local-net"
  type        = string
  description = "Key Name padrão do projeto"
}

# https://instances.vantage.sh/?cost_duration=daily&selected=t4g.large
variable "db_instance_type" {
  default     = "t4g.large"
  type        = string
  description = "instance type"
}

variable "db_node_count" {
  type        = number
  default     = 2
  description = "Número total de nós de banco de dados a serem criados."
}

variable "db_disk_size" {
  type        = number
  default     = 10
  description = "Tamanho de cada disco EBS em GB."
}

variable "db_disk_type" {
  type        = string
  default     = "gp3"
  description = "Tipo de volume EBS (gp2, gp3, io1, io2, etc.)."
}