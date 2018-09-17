#!/bin/bash
#
#Preparando SD para deploy em Raspberry
#

#Variáveis
SD="/dev/mmcblk0"

#Desmontando partições, caso haja
umount  /dev/mmcblk0p1
umount  /dev/mmcblk0p2

#Sequencia de parâmetros para o fdisk
echo "o
p
n
p
1

+100M
t
c
n
p
2


w
"|fdisk $SD

#Formatando as partições
mkfs.vfat /dev/mmcblk0p1
echo "y
" | mkfs.ext4 /dev/mmcblk0p2

#Criando diretórios boot e root
mkdir -p boot root

#Motando o sd nos diretórios
mount /dev/mmcblk0p1 boot
mount /dev/mmcblk0p2 root

#Download da imagem
wget http://os.archlinuxarm.org/os/ArchLinuxARM-rpi-2-latest.tar.gz

#Extraindo os arquivos da imagem
bsdtar -xvpf ArchLinuxARM-rpi-2-latest.tar.gz -C root

#Movendo os arquivos para o diretório boot
mv root/boot/* boot

#Desmontando root e boot
umount -f root boot
rm -rf boot root
