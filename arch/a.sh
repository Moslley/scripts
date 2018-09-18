#!/bin/bash

tput reset
__Y=$(echo -e "\e[33;1m");__O=$(echo -e "\e[m");__V=$(echo -e "\e[01;32m");__A=$(echo -e "\e[41;1m");

cat <<EOL
		
		
			
			====================================================
			
				        ${__Y}INSTALADOR ARCH LINUX${__O}
					   
			====================================================
			
			==> Autor: SriptKid
			==> Script: arch.sh v1.0
			==> Descrição: Instalador Automático Arch Linux GPT
			
					    ${__Y}INFORMAÇÔES${__O}
					   
			Nesse script será necessário você escolher sua par-
			tição Swap, Root e Home (Swap/Home são dispensáveis)
		
			Utilizaremos o particionador FDISK
			Código das Partições para quem quiser usar GDISK:
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

_n="\e[36;1m";_w="\e[37;1m";_g="\e[32;1m";_o="\e[m"

echo -ne "\n "
read -n 1 INSTALAR

if [[ "$INSTALAR" != @(S|s) ]]; then
	exit $?
fi

echo -en "\n${_g}	Informe a LETRA do seu disco (HD) (INSIRA SOMENTE A LETRA, ex: a para /dev/sda):${_w} "
read -n 1 _hd
_hd="/dev/sd${_hd}"
export _hd

cfdisk $_hd

tput reset
setterm -cursor off

echo -e "\n\n${_n}	OK, VOCÊ DEFINIU AS PARTIÇÕES, CASO DESEJE CANCELAR, TECLE${_w}: Ctrl+c"
echo -e "\n${_n}	USE OS NÚMERO DAS PARTIÇÕES NAS PERGUNTAS ABAIXO${_w}"
echo -e "\n${_n}	AS PARTIÇÕES SÃO:${_w}"

echo

fdisk -l $_hd

echo

echo -en "\n${_g}	TEM PARTIÇÃO SWAP? DIGITE 's' OU TECLE ENTER CASO NÃO TENHA${_w} "
read -n 1 _temswap
export _temswap

if [[ "$_temswap" == @(S|s) ]]; then
	echo -en "\n${_g}	Informe o NÚMERO da partição SWAP (INSIRA SOMENTE O NÚMERO, ex.: 2 para sda2):${_w} "
	read -n 1 _swap
	_swap="/dev/sda${_swap}"
	export _swap
fi

echo -en "\n${_g}	Informe o NÚMERO da partição ROOT (INSIRA SOMENTE O NÚMERO, ex.: 3 para sda2):${_w} "
read -n 1 _root
_root="/dev/sda${_root}"
export _root

echo -en "\n${_g}	TEM PARTIÇÃO HOME? DIGITE 's' OU TECLE ENTER CASO NÃO TENHA${_w} "
read -n 1 _temhome
export _temhome

if [[ "$_temhome" == @(S|s) ]]; then
	echo -en "\n${_g}	Informe o NÚMERO da partição HOME (INSIRA SOMENTE O NÚMERO, ex.: 4 para sda4):${_w} "
	read -n 1 _home
	_home="/dev/sda${_home}"
	export _home
fi

echo -e "${_o}"

tput reset
cat <<STI
${__A}======================
Iniciando a Instalação
======================${__O}

STI

echo "Partição swap é: $_swap"; sleep 2s;
echo "Partição root é: $_root"; sleep 2s;
echo "Partição home é: $_home"; sleep 2s;

cat <<EOI

${__A}=============
     FIM!    
=============${__O}
EOI

exit


