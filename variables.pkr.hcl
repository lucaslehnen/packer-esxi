
variable "pkr_iso_url" {
    type = string
    description = "Url da ISO de instalação do ESXi"
}

variable "pkr_iso_checksum" {
    type = string
    description = "Checksum da ISO de instalação do ESXi"
}

variable "pkr_output_disk" {
    type = string
    description = "Nome do disco/artefato a ser gerado"
    default = "esxi.qcow2"
}

variable "pkr_cpu" {
    type = number
    description = "Qtd de vCPU's a serem utilizadas durante o build"
    default = 2
}

variable "pkr_mem" {
    type = number
    description = "Qtd de ram a ser utilizada no build (in MB)"
    default = 2048
}

variable "pkr_ip" {
    type = string
    description = "Ip a ser configurado na máquina"    
}

variable "pkr_gateway" {
    type = string
    description = "Gateway a ser configurado na maquina do ESXi"    
}

variable "pkr_netmask" {
    type = string
    description = "Netmask a ser configurado na maquina do ESXi"    
}

variable "pkr_nameserver" {
    type = string
    description = "Nameserver a ser configurado na máquina do ESXi"
}

variable "pkr_net_bridge" {
    type = string
    description = "Nome da interface de rede bridge ('br0', 'virbr0', etc)"
}

variable "pkr_ssh_user" {
    type = string
    description = "Usuário SSH na maquina com ESXi"
}

variable "pkr_ssh_pass" {
    type = string
    description = "Senha SSH da maquina com ESXi"
    sensitive = true
}