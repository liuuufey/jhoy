#!/bin/bash
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
MYIP=$(wget -qO- ipinfo.io/ip);
echo "Checking VPS"
CEKEXPIRED () {
    today=$(date -d +1day +%Y-%m-%d)
    Exp1=$(curl -sS https://raw.githubusercontent.com/liuuufey/aksesip/main/ip | grep $MYIP | awk '{print $3}')
    if [[ $today < $Exp1 ]]; then
    echo -e "\e[32mSTATUS SCRIPT AKTIF...\e[0m"
    else
    echo -e "\e[31mSCRIPT ANDA TELAH EXPIRED!\e[0m";
    echo "Hubungi Admin"
    echo "Telegram Me @liuuufey"
    exit 0
fi
}
IZIN=$(curl -sS https://raw.githubusercontent.com/liuuufey/aksesip/main/ip | awk '{print $4}' | grep $MYIP)
if [ $MYIP = $IZIN ]; then
echo -e "\e[32mPermission Accepted...\e[0m"
CEKEXPIRED
else
echo -e "\e[31mPermission Denied!\e[0m";
echo "Only For Premium Users"
echo "Telegram Me @liuuufey"
exit 0
fi
clear

echo -e "========================\e[1;31m\e[1;31m═[\e[mMENU OPTIONS\e[1;31m]═\e[m========================"
echo -e "================\e[1;31m\e[1;31m═[\e[m\e[32mMENU SSH, SSH WS & OPEN VPN\e[0m\e[1;31m]═\e[m================="
echo -e "* usernew      : Create SSH & OpenVPN Account"
echo -e "* trial        : Generate SSH & OpenVPN Trial Account"
echo -e "* renew        : Extending SSH & OpenVPN Account Active Life"
echo -e "* deluser      : Delete SSH & OpenVPN Account"
echo -e "* cek          : Check User Login SSH & OpenVPN"
echo -e "* member       : Daftar Member SSH & OpenVPN"
echo -e "* delete       : Delete User Expired SSH & OpenVPN"
echo -e "* autokill     : Set up Autokill SSH"
echo -e "* ceklim       : Displays Users Who Do Multi Login SSH"
echo -e "* restart      : Restart Service Dropbear, Squid3, OpenVPN & SSH"
echo -e "========================\e[1;31m\e[1;31m═[\e[m\e[32mMENU WIREGUARD\e[0m\e[1;31m]═\e[m======================"
echo -e "* add-wg       : Create Wireguard Account"
echo -e "* del-wg       : Delete Wireguard Account"
echo -e "* cek-wg       : Check User Login Wireguard"
echo -e "* renew-wg     : Extending Wireguard Account Active Life"
echo -e "* wg show      : Check Wireguard User Interface"
echo -e "==========================\e[1;31m\e[1;31m═[\e[m\e[32mMENU L2TP\e[0m\e[1;31m]═\e[m========================="
echo -e "* add-l2tp     : Creating L2TP Account"
echo -e "* del-l2tp     : Deleting L2TP Account"
echo -e "* renew-l2tp   : Extending L2TP Account Active Life"
echo -e "==========================\e[1;31m\e[1;31m═[\e[m\e[32mMENU PPTP\e[0m\e[1;31m]═\e[m========================="
echo -e "* add-pptp     : Create Account PPTP"
echo -e "* del-pptp     : Delete PPTP Account"
echo -e "* renew-pptp   : Extending PPTP Account Active Life"
echo -e "* cek-pptp     : Check User Login PPTP"
echo -e "==========================\e[1;31m\e[1;31m═[\e[m\e[32mMENU SSTP\e[0m\e[1;31m]═\e[m========================="
echo -e "* add-sstp     : Create Account SSTP"
echo -e "* del-sstp     : Delete SSTP Account"
echo -e "* renew-sstp   : Extending SSTP Account Active Life"
echo -e "* cek-sstp     : Check User Login SSTP"
echo -e "===========================\e[1;31m\e[1;31m═[\e[m\e[32mMENU SSR\e[0m\e[1;31m]═\e[m========================="
echo -e "* add-ssr      : Create SSR Account"
echo -e "* del-ssr      : Deleting SSR Account"
echo -e "* renew-ssr    : Extending SSR Account Active Life"
echo -e "* ssr          : Show Other SSR Menu"
echo -e "=====================\e[1;31m\e[1;31m═[\e[m\e[32mMENU Shadowsocks OBFS\e[0m\e[1;31m]═\e[m=================="
echo -e "* add-ss       : Creating Shadowsocks Account"
echo -e "* del-ss       : Delete Shadowsocks Account"
echo -e "* renew-ss     : Extending Shadowsocks Account Active Life"
echo -e "* cek-ss       : Check User Login Shadowsocks"
echo -e "=========================\e[1;31m\e[1;31m═[\e[m\e[32mMENU VMESS\e[0m\e[1;31m]═\e[m========================="
echo -e "* add-ws       : Create V2RAY Vmess Websocket Account"
echo -e "* del-ws       : Deleting V2RAY Vmess Websocket Account"
echo -e "* renew-ws     : Extending Vmess Account Active Life"
echo -e "* cek-ws       : Check User Login V2RAY"
echo -e "* certv2ray    : Renew Certificate V2RAY Account"
echo -e "=========================\e[1;31m\e[1;31m═[\e[m\e[32mMENU VLESS\e[0m\e[1;31m]═\e[m========================="
echo -e "* add-vless    : Create V2RAY Vless Websocket Account"
echo -e "* del-vless    : Deleting V2RAY Vless Websocket Account"
echo -e "* renew-vless  : Extending Vless Account Active Life"
echo -e "* cek-vless    : Check User Login Vless"
echo -e "=======================\e[1;31m\e[1;31m═[\e[m\e[32mMENU VLESS GRPC\e[0m\e[1;31m]═\e[m======================"
echo -e "* add-vlgrpc   : Create Vless GRPC Websocket Account"
echo -e "* del-vlgrpc   : Deleting Vless GRPC Websocket Account"
echo -e "* renew-vlgrpc : Extending Vless GRPC Account Active Life"
echo -e "* cek-vlgrpc   : Check User Login Vless GRPC"
echo -e "========================\e[1;31m\e[1;31m═[\e[m\e[32mMENU TROJAN\e[0m\e[1;31m]═\e[m========================="
echo -e "* add-tr       : Create Trojan Account"
echo -e "* del-tr       : Deleting Trojan Account"
echo -e "* renew-tr     : Extending Trojan Account Active Life"
echo -e "* cek-tr       : Check User Login Trojan"
echo -e "=======================\e[1;31m\e[1;31m═[\e[m\e[32mMENU TROJAN GO\e[0m\e[1;31m]═\e[m======================="
echo -e "* add-trgo     : Create Trojan Go Account"
echo -e "* del-trgo     : Deleting Trojan Go Account"
echo -e "* renew-trgo   : Extending Trojan Go Account Active Life"
echo -e "* cek-trgo     : Check User Login TrojanGo"
echo -e "=======================\e[1;31m\e[1;31m═[\e[m\e[32mMENU SYSTEMS\e[0m\e[1;31m]═\e[m========================="
echo -e "* add-host     : Add Subdomain Host For VPS"
echo -e "* update       : Update To Latest Script Version"
echo -e "* autoreboot       : Automatic setting reboot vps"
echo -e "* autobackup   : Autobackup Data VPS"
echo -e "* backup       : Backup Data VPS"
echo -e "* restore      : Restore Data VPS"
echo -e "* wbmn         : Webmin Menu"
echo -e "* limit-speed  : Limit Bandwith Speed Server"
echo -e "* ram          : Check Usage of VPS Ram"
echo -e "* reboot       : Reboot VPS"
echo -e "* speedtest    : Speedtest VPS"
echo -e "* info         : Displaying System Information"
echo -e "* about        : Info Script Auto Install"
echo -e "* exit         : Exit From VPS "
echo -e "================================================================"
echo -e "                \e[1;31m\e[1;31m═[\e[mAuto scrypt install by Liuuufey\e[1;31m]═\e[m"
echo -e ""
