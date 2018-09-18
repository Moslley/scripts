#!/bin/bash

# variaveis

# usuário e senha
_user="arch"
_proot="123"
_puser="123"

# modo efi e instalar grub (s ou n)
mode_efi="n"
install_grub="s"

# arch-chroot /mnt

# modo efi
if [ "$mode_efi" == "s" ]; then
	echo -e "\033[01;32m===> bootctl mode EFI\033[00;37m"; sleep 1.5
	bootctl --path=/boot install; sleep 1.5s
	echo -e "default arch\ntimeout 5\n" > /boot/loader/loader.conf; sleep 1.5s
	###########################################
	# ATENÇÃO: alterar sdax pelo do seu /root #
	###########################################
	echo -e "title Arch Linux\nlinux /vmlinuz-linux\ninitrd /initramfs-linux.img\noptions root=/dev/sda3 rw\n" > /boot/loader/entries/arch.conf; sleep 1.5s
	
fi


# comandos padrões para instalação de idioma, teclado, hora e etc ... 
echo -e "\033[01;32m===> Idioma, Teclado, Hora, Hostname, Hosts, Multilib, Sudoers\033[00;37m"; sleep 1.5

echo -e "\033[01;32m===> Inserindo pt_BR.UTF-8 UTF-8 em /etc/locale.gen\033[00;37m"; sleep 1.5
echo "pt_BR.UTF-8 UTF-8" >> /etc/locale.gen; sleep 1.5s

echo -e "\033[01;32m===> Inserindo LANG=pt_BR.UTF-8 em /etc/locale.conf\033[00;37m"; sleep 1.5
echo LANG=pt_BR.UTF-8 > /etc/locale.conf; sleep 1.5s

echo -e "\033[01;32m===> Exportando LANG=pt_BR.UTF-8\033[00;37m"; sleep 1.5
export LANG=pt_BR.UTF-8; sleep 1.5s

echo -e "\033[01;32m===> Inserindo KEYMAP=br-abnt2 em /etc/vconsole.conf\033[00;37m"; sleep 1.5
echo "KEYMAP=br-abnt2" > /etc/vconsole.conf; sleep 1.5s

echo -e "\033[01;32m===> Configurando horário America/Sao_Paulo\033[00;37m"; sleep 1.5
ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime && hwclock --systohc; sleep 1.5s

echo -e "\033[01;32m===> Inserindo hostname arch no arquivo /etc/hostname\033[00;37m"; sleep 1.5
echo "arch" > /etc/hostname; sleep 1.5s

echo -e "\033[01;32m===> Inserindo dados no arquivo /etc/hosts\033[00;37m"; sleep 1.5
echo -e "127.0.0.1\tlocalhost.localdomain\tlocalhost\n::1\tlocalhost.localdomain\tlocalhost\n127.0.1.1\tarch.localdomain\tarch\n" > /etc/hosts; sleep 1.5s

echo -e "\033[01;32m===> Habilitando Multilib\033[00;37m"; sleep 1.5
echo -e "[multilib]\nInclude = /etc/pacman.d/mirrorlist\n" >> /etc/pacman.gen; sleep 1.5s

echo -e "%wheel ALL=(ALL) ALL\n" >> /etc/sudoers; sleep 1.5s

echo -e "\033[01;32m===> Gerando Locale\033[00;37m"; sleep 1.5s
locale-gen; sleep 1.5s

echo -e "\033[01;32m===> Atualizando o sistema\033[00;37m"; sleep 1.5s
pacman -Syu; sleep 1.5s

# grub
if [ "$install_grub" == "s" ]; then
	echo -e "\033[01;32m===> Instalando e Configurando o GRUB\033[00;37m"; sleep 1.5
	pacman -S grub --noconfirm; sleep 1.5s
	grub-install --target=i386-pc --recheck /dev/sda; sleep 1.5s
	cp /usr/share/locale/en\@quot/LC_MESSAGES/grub.mo /boot/grub/locale/en.mo; sleep 1.5s
	grub-mkconfig -o /boot/grub/grub.cfg; sleep 1.5s
fi

# password
echo -e "\033[01;32m===> Gerando senha root\033[00;37m"; sleep 1.5s
passwd << EOF
$_proot
$_proot
EOF
sleep 1.5s

echo -e "\033[01;32m===> Gerando senha user\033[00;37m"; sleep 1.5s
useradd -m -g users -G wheel -s /bin/bash $_user
passwd $_user << EOF
$_puser
$_puser
EOF
sleep 1.5s

echo -e "\033[01;32m===> Compriminto inicialização\033[00;37m"; sleep 1.5s
mkinitcpio -p linux; sleep 1.5s

echo -e "\033[01;32m===> Fim do script arch-chroot\033[00;37m"; sleep 1.5s

exit