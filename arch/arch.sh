#!/bin/bash

tput reset
__Y=$(echo -e "\e[33;1m");__O=$(echo -e "\e[m");__V=$(echo -e "\e[01;32m");__A=$(echo -e "\e[41;1m");

cat <<EOL
		
		
		====================================================
		
				${__Y}INSTALADOR ARCH LINUX${__O}
				   
		====================================================
		
		==> Autor: SriptKid
		==> Programa: arch.sh v1.0
		==> Descrição: Instalador Automático Arch Linux GPT
		
				    ${__Y}INFORMAÇÔES${__O}
				   
		Nesse script será necessário você escolher sua par-
		tição swap, root e home (se tiver).

		Utilizo o particionador GDISK
		Código das Partições:
		==> 8200 SWAP
		==> 8304 /
		==> 8302 /home
		==> EF02 BIOS
		==> EF00 EFI
		
		====================================================
		
			     ${__Y}CONTINUAR COM A INSTALAÇÃO?${__O}
				
		   Digite s/S para continuar ou n/N para cancelar
		   DESEJA REALMENTE INICIAR A INSTALAÇÃO ? ${__Y}[S/n]${__O}
		   
		====================================================
EOL

setterm -cursor off

_n='\e[36;1m';_w='\e[37;1m';_g='\e[32;1m';_o='\e[m'

echo -ne "\n "
read -n 1 INSTALAR

if [[ "$INSTALAR" != @(S|s) ]]; then
	exit $?
fi

gdisk

tput reset
setterm -cursor off

echo -e "\n\n${_n}    OK, VOCÊ DEFINIU AS PARTIÇÕES, CASO DESEJE CANCELAR, TECLE${_w}: Ctrl+c"
echo -e "\n${_n}    AGORA RESPONDA AS PERGUNTAS ABAIXO PARA PROSSEGUIR A INSTALAÇÃO${_w}"

echo

# echo -en "\n${_g}    Informe o NÚMERO da partição BOOT (INSIRA SOMENTE O NÚMERO, ex.: 1 para sda1):${_w} "
# read -n 1 _boot
# _boot="/dev/sda${_boot}"
# export _boot
# declare -x _boot

echo -en "\n${_g}    Informe o número da sua partição SWAP (INSIRA SOMENTE O NÚMERO, ex.: 2 para sda2):${_w} "
read -n 1 _swap
_swap="/dev/sda${_swap}"
export _swap
declare -x _swap

echo -en "\n${_g}    Informe o número da sua partição ROOT (INSIRA SOMENTE O NÚMERO, ex.: 3 para sda2):${_w} "
read -n 1 _root
_root="/dev/sda${_root}"
export _root
declare -x _root

echo -e "${_o}"

tput reset
cat <<STI
${__A}======================
Iniciando a Instalação
======================${__O}

STI

# Variáveis
_efi="/dev/sdax"	# EFI
_swap="/dev/sda2"	# SWAP
_root="/dev/sda3"	# ROOT
_home="/dev/sdax"	# HOME

tem_home="n"		# tem home?
tem_efi="n"			# tem efi?

# swap
echo -e '\033[01;32m===> Criando e ligando Swap\033[00;37m'; sleep 1.5
mkswap $_swap && swapon $_swap; sleep 1.5

# root
echo -e '\033[01;32m===> Formatando e Montando Root\033[00;37m'; sleep 1.5
mkfs.ext4 -F $_root && mount $_root /mnt; sleep 1.5

# home
if [ "$tem_home" == "s" ]; then
	echo -e '\033[01;32m===> Formatando, Criando e Montando Home\033[00;37m'; sleep 1.5
	mkfs.ext4 -F $_home && mkdir /mnt/home && mount $_home /mnt/home; sleep 1.5	
fi

# efi
if [ "$tem_efi" == "s" ]; then
	echo -e '\033[01;32m===> Tem EFI <=== Formatando, Criando e Montando em $_efi\033[00;37m'; sleep 1.5
	mkfs.fat -F32 -n -F BOOT $_efi && mkdir /mnt/boot && mount $_efi /mnt/boot; sleep 1.5
fi

# instalando base e base-devel
echo -e '\033[01;32m===> Instalando base/base-devel\033[00;37m'; sleep 1.5
pacstrap /mnt base; sleep 1.5

# gerando fstab
echo -e '\033[01;32m===> Gerando FSTAB\033[00;37m'; sleep 1.5
genfstab -U -p /mnt >> /mnt/etc/fstab; sleep 1.5

# download script mode chroot
echo -e '\033[01;32m===> Baixando script para ser executado como chroot ...\033[00;37m'; sleep 4
wget http://www.brosearch.pessoal.ws/downloads/chroot.sh && chmod +x chroot.sh && mv chroot.sh /mnt; sleep 1.5

# run script
echo -e '\033[01;32m===> Executando script ...\033[00;37m'; sleep 4
arch-chroot /mnt ./chroot.sh; sleep 1.5

# umount
echo -e '\033[01;32m===> Desmontando partições\033[00;37m'; sleep 1.5
umount -R /mnt; sleep 1.5

cat <<EOI

${__A}=============
     FIM!    
=============${__O}
EOI


