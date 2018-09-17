#!/bin/bash

### INSTALANDO XFCE4 ###

__A=$(echo -e "\e[34;1m");
__O=$(echo -e "\e[m");

virtual_box="s"

cat <<STI
${__A}===========================
Iniciando a Instalação xfce
===========================${__O}

STI

# xorg
echo -e '\033[01;32m===> Instando Xorg\033[00;37m'; sleep 1.5s
pacman -S xorg-xinit xorg-server xorg-twm xterm xorg-drivers ttf-dejavu --noconfirm; sleep 1.5

# xfce4
echo -e '\033[01;32m===> Instalando xfce4\033[00;37m'; sleep 1.5s
pacman -S xfce4 xfce4-goodies --noconfirm; sleep 1.5

# firefox + flash
echo -e '\033[01;32m===> Instalando firefox e flash\033[00;37m'; sleep 1.5s
pacman -S firefox flashplugin --noconfirm; sleep 1.5

# lightdm
echo -e '\033[01;32m===> Instalando gerenciador de login lightdm\033[00;37m'; sleep 1.5s
pacman -S lightdm lightdm-gtk-greeter xf86-input-synaptics xf86-input-libinput screenfetch --noconfirm; sleep 1.5

# audio
echo -e '\033[01;32m===> Instalando audio\033[00;37m'; sleep 1.5s
pacman -S alsa-utils pulseaudio paprefs pavucontrol --noconfirm; sleep 1.5

# others
# pacman -S gvfs transmission-gtk vinagre --noconfirm; sleep 1.5

# pacotes essenciais
if [ "$virtual_box" == "s" ]; then
	echo -e '\033[01;32m===> Virtuabox\033[00;37m'; sleep 1.5s
	pacman -S  virtualbox-guest-utils networkmanager network-manager-applet dialog --noconfirm; sleep 1.5
else
	echo -e '\033[01;32m===> Instalando utilitários de rede\033[00;37m'; sleep 1.5s
	pacman -S networkmanager network-manager-applet wireless_tools wpa_supplicant wpa_actiond dialog acpi acpid --noconfirm; sleep 1.5
fi

echo -e '\033[01;32m===> Configurando pra iniciar o xfce\033[00;37m'; sleep 1.5s

# startx xfce4
cp /etc/X11/xinit/xinitrc ~/.xinitrc; sleep 1.5

# comentando a linha exec xterm
sed -i 's/exec xterm \-geometry 80x66+0+0 \-name login/\#exec xterm \-geometry 80x66+0+0 \-name login/' ~/.xinitrc; sleep 1.5

# inserindo exec startxfce4
echo 'exec startxfce4' >> ~/.xinitrc; sleep 1.5

# enable services
echo -e '\033[01;32m===> Habilitando serviços para serem iniciados com o sistema\033[00;37m'; sleep 1.5s
systemctl enable lightdm; sleep 1.5
systemctl enable NetworkManager; sleep 1.5

cat <<EOI

${__A}=============
     FIM!    
=============${__O}
EOI

echo -e '\033[01;32m===> Dando reboot\033[00;37m'; sleep 1.5s

#echo -e '\033[01;32m===> FIM!\033[00;37m'; sleep 1.5s

# OBS: Se der algum problema durante o carregamento do sistema, use Ctrl + Alt + F2