# Imagem do ESXi para o Qemu/libvirt construída com o Packer 

![Packer](https://img.shields.io/badge/Packer->%3D1.7.8-blue?logo=packer&logoColor=white)
![QEmu](https://img.shields.io/badge/QEmu->%3D5.2-red?logo=packer&logoColor=white)
![QEmu](https://img.shields.io/badge/ESXi-7.U3-green?logo=VMWare&logoColor=white)
[![wakatime](https://wakatime.com/badge/github/lucaslehnen/packer-esxi-qemu.svg)](https://wakatime.com/badge/github/lucaslehnen/packer-esxi-qemu)


O artefato resultante deste template Packer é uma imagem no formato `qcow2`, 
que pode ser utilizada no libvirt/Qemu posteriormente. Utilizar o ESXi em um ambiente virtualizado não é recomendado para produção, mas pode auxiliar no caso de laboratórios.

Construí inicialmente este código para o projeto do meu [laboratório pessoal](https://github.com/lucaslehnen/homelab).

## O que ele faz

Basicamente, a configuração do ESXi está no arquivo de "kickstart", o `ks.cfg`. Informações de como personalizar o mesmo estão [neste link](https://docs.vmware.com/en/VMware-vSphere/7.0/com.vmware.esxi.upgrade.doc/GUID-61A14EBB-5CF3-43EE-87EF-DB8EC6D83698.html) da página da VMWare.

O Packer usa o builder oficial do Qemu para provisionar uma máquina temporária a partir da imagem oficial do ESXi informada. A partir daí, ele instancia um servidor http para prover o arquivo de kickstart e envia teclas para a instância, realizando a instalação sem a necessidade de intervenção manual.

## O que ele não faz

- Provisionamento do ESXi: Para isso, pode ser utilizado o libvirt, com ou sem o Terraform.

## Pré-requisitos

- Packer 
- Qemu
- Imagem do ESXi

No momento de construção do template, o plugin do Packer não tinha a possibilidade de conectar remotamente no Qemu, então é esperado que o template seja construído a partir da máquina com o Qemu.

A máquina com o Qemu está com uma rede bridge, o que permitiu a configuração do Packer para utilizá-la.
Em meu ambiente, utilizei o Debian. Para instalar o Qemu e a rede bridge, utilizei a collection do Ansible que eu havia criado [neste link](https://github.com/lucaslehnen/tchecode.libvirt).

## Como utilizar 

Dentro da máquina com o Qemu:

Clone este repositório:
```
git clone https://github.com/lucaslehnen/packer-esxi-qemu.git
```

Configure as variáveis:

```yaml
pkr_iso_url =  # url da ISO de instalação do ESXi
pkr_iso_checksum = # Checksum da iso
pkr_output_disk = # Nome do disco/artefato a ser gerado
pkr_cpu =  # qtd de vCPU's a serem utilizadas durante o build
pkr_mem = # Qtd de ram a ser utilizada no build
pkr_id = # Ip a ser configurado na máquina
pkr_gateway = # Gateway a ser configurado
pkr_netmask = # Netmask
pkr_nameserver = # Nameserver
pkr_net_bridge = # Nome da interface de rede bridge ("br0", "virbr0", etc)
```

[Veja a documentação](https://www.packer.io/guides/hcl/variables) sobre as variáveis para ver como inseri-las.

Faça o build:
```
packer build packer.pkr.hcl
```

Se quiser acompanhar a execução, ou fazer um troubleshoting,  deixei o VNC configurado, portanto podes usar um VNC Viewer por exemplo. 

Ao final, o arquivo de imagem estará em `build/esxi7U3.qcow2`.

## Contribuindo

Este template foi construído para um caso de uso apenas, mas se você for utilizar este template e precisar de algo a mais, fique a vontade para fazer um fork e abrir pr. Contribuições são sempre bem vindas.

## Fontes / Links úteis:

- https://www.grottedubarbu.fr/nested-virtualization-esxi-kvm/
- https://fabianlee.org/2018/09/19/kvm-deploying-a-nested-version-of-vmware-esxi-6-7-inside-kvm/
- https://registry.terraform.io/providers/dmacvicar/libvirt/latest/docs
- https://libvirt.org/docs.html
- https://www.qemu.org/docs/master/system/invocation.html