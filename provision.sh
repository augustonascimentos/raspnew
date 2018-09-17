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
echo 'build ALL=(ALL) ALL' | sudo EDITOR='tee -a' visudo

#Criando Usuario Padrão
useradd -m -p '$6$YMLKRK7dqt0KJ8T8$EKmvtTTIlMGLDLLeg954kBMHMPmEM0CweaxX.HdLIcTztbrh48qoLj5qF3Gj4C4MrkPumkjJrUtewf0ArUdbP/' -g users -G wheel -s /bin/bash build

# Delegando permissões para o usuário build
sed -i -e 's/# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/g' /etc/sudoers
sed -i -e 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/g' /etc/sudores

# Instalando o X Server
pacman -S --noconfirm xorg-server xorg-xinit xorg-xrandr xf86-video-fbdev xorg-twm xterm

# Instalando o Docker Engine
pacman -S --noconfirm docker

# Instalando o xdotool e unclutter
pacman -S --noconfirm unclutter xdotool

# Desabilitando root login
passwd -l root

# Desabilitando os usuario padrão(alarm) do Raspberry 
sudo userdel alarm

# Configurando o auto loging
systemctl start getty@tty1.service
mkdir -p /etc/systemd/system/getty\@tty1.service.d/
cat > /etc/systemd/system/getty\@tty1.service.d/override.conf <<EOF
[Service]
ExecStart=
ExecStart=-/usr/bin/agetty --autologin build --noclear %I $TERM
EOF

# Configurando Hostname
ip=$(ip add | grep 10.10 | awk '{print $2}' |  cut -f1 -d"/" | cut -f4 -d".")
echo raspberry-"$ip" > /etc/hostname

# Iniciando o serviço Docker
systemctl enable docker.service
systemctl start docker.service

# Resetando o sistema para carregar todas a configuracoes
reboot
