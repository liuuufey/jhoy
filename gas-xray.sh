#!/bin/bash
if [ "${EUID}" -ne 0 ]; then
		echo "You need to run this script as root"
		exit 1
fi
if [ "$(systemd-detect-virt)" == "openvz" ]; then
		echo "OpenVZ is not supported"
		exit 1
fi
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
MYIP=$(wget -qO- ifconfig.me/ip);
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

domain=$(cat /root/domain)

apt update ; apt upgrade -y
apt install python ; apt install python3-pip -y
apt install iptables iptables-persistent -y
apt-get install libpcre3 libpcre3-dev zlib1g-dev dbus -y
apt install curl socat xz-utils wget apt-transport-https gnupg gnupg2 gnupg1 dnsutils lsb-release -y 
apt install socat cron bash-completion ntpdate -y
ntpdate pool.ntp.org
apt -y install chrony
apt install zip -y
timedatectl set-ntp true
systemctl enable chronyd && systemctl restart chronyd
systemctl enable chrony && systemctl restart chrony
timedatectl set-timezone Asia/Jakarta
chronyc sourcestats -v
chronyc tracking -v
date

# install crt
mkdir -p /var/log/xray/
mkdir -p /etc/xray/
touch /etc/xray/domain


mkdir /root/.acme.sh
curl https://acme-install.netlify.app/acme.sh -o /root/.acme.sh/acme.sh
chmod +x /root/.acme.sh/acme.sh
cd /root/.acme.sh
bash acme.sh --register-account -m senowahyu62@gmail.com
/root/.acme.sh/acme.sh --issue -d $domain --standalone -k ec-256
~/.acme.sh/acme.sh --installcert -d $domain --fullchainpath /etc/xray/xray.crt --keypath /etc/xray/xray.key --ecc
service squid start

# Check OS version
if [[ -e /etc/debian_version ]]; then
	source /etc/os-release
	OS=$ID # debian or ubuntu
elif [[ -e /etc/centos-release ]]; then
	source /etc/os-release
	OS=centos
fi
if [[ $OS == 'ubuntu' ]]; then
		sudo add-apt-repository ppa:ondrej/nginx -y
		apt update ; apt upgrade -y
		sudo apt install nginx -y
		sudo apt install python3-certbot-nginx -y
		systemctl daemon-reload
        systemctl enable nginx
elif [[ $OS == 'debian' ]]; then
		sudo apt install gnupg2 ca-certificates lsb-release -y 
        echo "deb http://nginx.org/packages/mainline/debian $(lsb_release -cs) nginx" | sudo tee /etc/apt/sources.list.d/nginx.list 
        echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" | sudo tee /etc/apt/preferences.d/99nginx 
        curl -o /tmp/nginx_signing.key https://nginx.org/keys/nginx_signing.key 
        # gpg --dry-run --quiet --import --import-options import-show /tmp/nginx_signing.key
        sudo mv /tmp/nginx_signing.key /etc/apt/trusted.gpg.d/nginx_signing.asc
        sudo apt update 
        apt -y install nginx 
        systemctl daemon-reload
fi
rm -f /etc/nginx/conf.d/default.conf 
wget -O /etc/nginx/nginx.conf "https://raw.githubusercontent.com/liuuufey/jhoy/main/nginx.conf"
wget -O /etc/nginx/conf.d/vps.conf "https://raw.githubusercontent.com/liuuufey/jhoy/main/vps.conf"
systemctl enable nginx
/etc/init.d/nginx restart
clear
echo "
server {
    listen 80 ;
    listen [::]:80 ;
    access_log /var/log/nginx/vps-access.log;
    error_log /var/log/nginx/vps-error.log error;
    
    location /vmess
        {
        proxy_redirect off;
        proxy_pass http://127.0.0.1:31301;
        proxy_http_version 1.1;
        proxy_set_header Upgrade "'"$http_upgrade"'";
        proxy_set_header Connection '"'upgrade'"';
        proxy_set_header Host "'"$http_host"'";
        }
    location /vless
        {
        proxy_redirect off;
        proxy_pass http://127.0.0.1:31302;
        proxy_http_version 1.1;
        proxy_set_header Upgrade "'"$http_upgrade"'";
        proxy_set_header Connection '"'upgrade'"';
        proxy_set_header Host "'"$http_host"'";
	    }
	location /
        {
        proxy_redirect off;
        proxy_pass http://127.0.0.1:2095;
        proxy_http_version 1.1;
        proxy_set_header Upgrade "'"$http_upgrade"'";
        proxy_set_header Connection '"'upgrade'"';
        proxy_set_header Host "'"$http_host"'";
	    }
	location /vlgRPC 
	{
        client_max_body_size 0;
        keepalive_time 1071906480m;
        keepalive_requests 4294967296;
        client_body_timeout 1071906480m;
        send_timeout 1071906480m;
        lingering_close always;
        grpc_read_timeout 1071906480m;
        grpc_send_timeout 1071906480m;
        grpc_pass grpc://127.0.0.1:31304;
	}
	location /Trojan-go
        {
        proxy_redirect off;
        proxy_pass http://127.0.0.1:31306;
        proxy_http_version 1.1;
        proxy_set_header Upgrade "'"$http_upgrade"'";
        proxy_set_header Connection '"'upgrade'"';
        proxy_set_header Host "'"$http_host"'";
	}
}
" > /etc/nginx/conf.d/hay.conf


# install xray
wget -q -O /usr/local/bin/xray "https://raw.githubusercontent.com/liuuufey/jhoy/main/xray"
chmod +x /usr/local/bin/xray
chmod 775 /etc/xray/

uuid=$(cat /proc/sys/kernel/random/uuid)
cat> /etc/xray/vmess.json << END
{
  "log": {
    "access": "/var/log/xray/access.log",
    "error": "/var/log/xray/error.log",
    "loglevel": "info"
  },
  "inbounds": [
    {
      "port": 31301,
      "protocol": "vmess",
      "settings": {
        "clients": [
          {
            "id": "${uuid}",
            "alterId": 2
#tls
          }
        ]
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": {
          "path": "/vmess",
          "headers": {
            "Host": ""
          }
         },
        "quicSettings": {},
        "sockopt": {
          "mark": 0,
          "tcpFastOpen": true
        }
      },
      "sniffing": {
        "enabled": true,
        "destOverride": [
          "http",
          "tls"
        ]
      },
      "domain": "$domain"
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom",
      "settings": {}
    },
    {
      "protocol": "blackhole",
      "settings": {},
      "tag": "blocked"
    }
  ],
  "routing": {
    "rules": [
      {
        "type": "field",
        "ip": [
          "0.0.0.0/8",
          "10.0.0.0/8",
          "100.64.0.0/10",
          "169.254.0.0/16",
          "172.16.0.0/12",
          "192.0.0.0/24",
          "192.0.2.0/24",
          "192.168.0.0/16",
          "198.18.0.0/15",
          "198.51.100.0/24",
          "203.0.113.0/24",
          "::1/128",
          "fc00::/7",
          "fe80::/10"
        ],
        "outboundTag": "blocked"
      },
      {
        "type": "field",
        "outboundTag": "blocked",
        "protocol": [
          "bittorrent"
        ]
      }
    ]
  }
}
END
cat> /etc/xray/vless.json << END
{
  "log": {
    "access": "/var/log/xray/access2.log",
    "error": "/var/log/xray/error.log",
    "loglevel": "info"
  },
  "inbounds": [
    {
      "port": 31302,
      "protocol": "vless",
      "settings": {
        "clients": [
          {
            "id": "${uuid}"
#tls
          }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": {
          "path": "/vless",
          "headers": {
            "Host": ""
          }
         },
        "quicSettings": {},
        "sockopt": {
          "mark": 0,
          "tcpFastOpen": true
        }
      },
      "sniffing": {
        "enabled": true,
        "destOverride": [
          "http",
          "tls"
        ]
      },
      "domain": "$domain"
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom",
      "settings": {}
    },
    {
      "protocol": "blackhole",
      "settings": {},
      "tag": "blocked"
    }
  ],
  "routing": {
    "rules": [
      {
        "type": "field",
        "ip": [
          "0.0.0.0/8",
          "10.0.0.0/8",
          "100.64.0.0/10",
          "169.254.0.0/16",
          "172.16.0.0/12",
          "192.0.0.0/24",
          "192.0.2.0/24",
          "192.168.0.0/16",
          "198.18.0.0/15",
          "198.51.100.0/24",
          "203.0.113.0/24",
          "::1/128",
          "fc00::/7",
          "fe80::/10"
        ],
        "outboundTag": "blocked"
      },
      {
        "type": "field",
        "outboundTag": "blocked",
        "protocol": [
          "bittorrent"
        ]
      }
    ]
  }
}
END
cat> /etc/xray/trojan.json <<END
{
  "log": {
    "access": "/var/log/xray/trojan.log",
    "error": "/var/log/xray/error.log",
    "loglevel": "info"
  },
  "inbounds": [
    {
      "port": 443,
      "protocol": "trojan",
      "settings": {
        "clients": [
          {
            "password": "${uuid}"
#tls
          }
        ],
        "fallbacks": [
          {
            "dest": 2095
          },
          {
            "path":"/vmess",
            "dest": 31301
          },
          {
            "path":"/vless",
            "dest": 31302
          },
          {
            "path":"/Trojan-go",
            "dest": 31306
          }
        ]
      },
      "streamSettings": {
        "network": "tcp",
        "security": "tls",
        "tlsSettings": {
          "certificates": [
            {
              "certificateFile": "/etc/xray/xray.crt",
              "keyFile": "/etc/xray/xray.key"
            }
          ],
          "alpn": [
            "http/1.1"
          ]
        },
        "sockopt": {
          "mark": 0,
          "tcpFastOpen": true
        }
      },
      "domain": "$domain"
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom",
      "settings": {}
    },
    {
      "protocol": "blackhole",
      "settings": {},
      "tag": "blocked"
    }
  ],
  "routing": {
    "rules": [
      {
        "type": "field",
        "ip": [
          "0.0.0.0/8",
          "10.0.0.0/8",
          "100.64.0.0/10",
          "169.254.0.0/16",
          "172.16.0.0/12",
          "192.0.0.0/24",
          "192.0.2.0/24",
          "192.168.0.0/16",
          "198.18.0.0/15",
          "198.51.100.0/24",
          "203.0.113.0/24",
          "::1/128",
          "fc00::/7",
          "fe80::/10"
        ],
        "outboundTag": "blocked"
      },
      {
        "type": "field",
        "outboundTag": "blocked",
        "protocol": [
          "bittorrent"
        ]
      }
    ]
  }
}
END
cat> /etc/xray/vlgrpc.json<<END
{
  "log": {
        "access": "/var/log/xray/vlgrpc.log",
        "error": "/var/log/xray/error.log",
        "loglevel": "warning"
    },
  "inbounds": [
    {
    "port":31304,
      "listen": "127.0.0.1",
      "tag": "vless-in",
      "protocol": "vless",
      "settings": {
        "clients": [
        {
            "id": "${uuid}"
#tls
          }
        ],
	    "decryption": "none"
      },
      "streamSettings": {
        "network": "grpc",
        "grpcSettings": {
         "serviceName": "vlgRPC",
         "multiMode": true
        }
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom",
      "settings": { },
      "tag": "direct"
    },
    {
      "protocol": "blackhole",
      "settings": { },
      "tag": "blocked"
    }
  ],
  "dns": {
    "servers": [
      "https+local://1.1.1.1/dns-query",
          "1.1.1.1",
          "1.0.0.1",
          "8.8.8.8",
          "8.8.4.4",
          "localhost"
    ]
  },
  "routing": {
    "domainStrategy": "AsIs",
    "rules": [
      {
        "type": "field",
        "inboundTag": [
          "vless-in"
        ],
        "outboundTag": "direct"
      },
      {
        "type": "field",
        "outboundTag": "blocked",
        "protocol": [
          "bittorrent"
        ]
      }
    ]
  }
}
END
cat> /etc/xray/trojanws.json << END
{
  "log": {
    "access": "/var/log/xray/trojanws.log",
    "error": "/var/log/xray/error.log",
    "loglevel": "info"
  },
  "inbounds": [
    {
      "port": 31306,
      "protocol": "trojan",
      "settings": {
        "clients": [
          {
            "id": "${uuid}"
#tls
          }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": {
          "path": "/Trojan-go",
          "headers": {
            "Host": ""
          }
         },
        "quicSettings": {},
        "sockopt": {
          "mark": 0,
          "tcpFastOpen": true
        }
      },
      "sniffing": {
        "enabled": true,
        "destOverride": [
          "http",
          "tls"
        ]
      },
      "domain": "$domain"
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom",
      "settings": {}
    },
    {
      "protocol": "blackhole",
      "settings": {},
      "tag": "blocked"
    }
  ],
  "routing": {
    "rules": [
      {
        "type": "field",
        "ip": [
          "0.0.0.0/8",
          "10.0.0.0/8",
          "100.64.0.0/10",
          "169.254.0.0/16",
          "172.16.0.0/12",
          "192.0.0.0/24",
          "192.0.2.0/24",
          "192.168.0.0/16",
          "198.18.0.0/15",
          "198.51.100.0/24",
          "203.0.113.0/24",
          "::1/128",
          "fc00::/7",
          "fe80::/10"
        ],
        "outboundTag": "blocked"
      },
      {
        "type": "field",
        "outboundTag": "blocked",
        "protocol": [
          "bittorrent"
        ]
      }
    ]
  }
}
END
cat > /etc/systemd/system/xray@.service << EOF
[Unit]
Description=XRay Service ( %i )
Documentation=https://github.com/XTLS/Xray-core
After=network.target nss-lookup.target
[Service]
User=root
NoNewPrivileges=true
ExecStart=/usr/local/bin/xray -config /etc/xray/%i.json
Restart=on-failure
RestartPreventExitStatus=23
LimitNPROC=10000
LimitNOFILE=1000000
[Install]
WantedBy=multi-user.target
EOF

iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 443 -j ACCEPT
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 31301 -j ACCEPT
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 31302 -j ACCEPT
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 31303 -j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 443 -j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 31301 -j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 31302 -j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 31303 -j ACCEPT
iptables-save > /etc/iptables.up.rules
iptables-restore -t < /etc/iptables.up.rules
netfilter-persistent save
netfilter-persistent reload
systemctl daemon-reload
systemctl enable xray@vless.service
systemctl start xray@vless.service
systemctl restart xray@trojan
systemctl enable xray@trojan
systemctl restart xray@trojanws
systemctl enable xray@trojanws
systemctl restart xray@vmess
systemctl enable xray@vmess
systemctl restart nginx
echo "0 5 * * * root  reboot" >> /etc/crontab
echo "0 0 * * * root xp" >> /etc/crontab
mv /root/domain /etc/xray
clear
