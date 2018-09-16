#!/bin/bash

# Seta o padrao do teclado para BR-ABNT2
localectl set-keymap --no-convert br-abnt2

# Atualizando os pacotes
pacman-key --init
pacman-key --populate archlinuxarm
pacman -Syu --noconfirm

# Instalando os pacotes basicos
pacman -S --noconfirm base-devel sudo wget git

# Liberando o acesso via SSH
sed -i -e 's/#Port 22/Port 22/g' /etc/ssh/sshd_config
sed -i -e 's/#AddressFamily any/AddressFamily any/g' /etc/ssh/sshd_config
sed -i -e 's/#ListenAddress 0.0.0.0/ListenAddress 0.0.0.0/g' /etc/ssh/sshd_config
sed -i -e 's/#ListenAddress 0.0.0.0/ListenAddress 0.0.0.0/g' /etc/ssh/sshd_config
sed -i -e 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
sed -i -e 's/#PermitRootLogin/PermitRootLogin/g' /etc/sudoers
echo 'alarm ALL=(ALL) ALL' | sudo EDITOR='tee -a' visudo

#Criando Usuario Padrão
useradd -m -g users -G wheel -s /bin/bash chromium

# Delegando permissões para o usuário chromium
sed -i -e 's/# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/g' /etc/sudoers

# Instalando o X Server
pacman -S --noconfirm xorg-server xorg-xinit xorg-xrandr xf86-video-fbdev xorg-twm xorg-clock xterm

# Instalando o Docker Engine
pacman -S --noconfirm docker

# Instalando o Chromium
pacman -S --noconfirm chromium unclutter xdotool

# Desabilitando root login
passwd -l root

# Desabilitando os usuario padrão(alarm) do Raspberry 
#sudo userdel alarm

# Configurando o auto loging
#systemctl start getty@tty1.service
#systemctl edit getty@tty1

#[Service]
#ExecStart=
#ExecStart=-/usr/bin/agetty --autologin build --noclear %I $TERM


# Resetando o sistema para carregar todas a configuracoes
reboot
