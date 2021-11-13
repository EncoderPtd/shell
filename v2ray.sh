# /bin/bash

# tested under Ubuntu-20.04
# Basic useage:
# cp v2ray.sh /usr/bin/
# v2ray.sh -h

version="1.0"

StartV2Ray() {
    str="Starting v2ray"
    echo -e "\033[32m${str}\033[0m"

    cmd="/usr/local/bin/v2ray-linux-32-v4.21.3/v2ray-linux-32-v4.21.3/v2ray -config /usr/local/bin/v2ray-linux-32-v4.21.3/v2ray-linux-32-v4.21.3/config.json"

    ret=$(ps -ef | grep v2ray)
    if [[ $ret =~ $cmd ]]; then
        sudo netstat -anpo | grep v2ray
        str="v2ray already started"
        echo -e "\033[32m${str}\033[0m"
    else
        # ret=$(nohup $cmd &)
        $cmd >log.file 2>&1 &

        ret=$(ps -ef | grep v2ray)
        echo $ret
        if [[ $ret =~ "$cmd" ]]; then
            sudo netstat -anpo | grep v2ray
            str="v2ray started"
            echo -e "\033[32m${str}\033[0m"
        else
            str="v2ray start failed."
            echo -e "\032[32m${str}\033[0m"
        fi
    fi

}

SetSystemProxy() {
    str="setting system proxy enviornment"
    echo -e "\033[32m${str}\033[0m"

    # manual
    ip="127.0.0.1"
    port_http=10809
    port_socks=10808

    gsettings set org.gnome.system.proxy.http host $ip
    gsettings set org.gnome.system.proxy.http port $port_http

    gsettings set org.gnome.system.proxy.https host $ip
    gsettings set org.gnome.system.proxy.https port $port_http

    # gsettings set org.gnome.system.proxy.ftp host $ip
    # gsettings set org.gnome.system.proxy.ftp port $port_http

    gsettings set org.gnome.system.proxy.socks host $ip
    gsettings set org.gnome.system.proxy.socks port $port_socks

    gsettings set org.gnome.system.proxy mode 'manual'

    # auto
    # gsettings set org.gnome.system.proxy mode 'auto'
    # gsettings set org.gnome.system.proxy autoconfig-url http://my.proxy.com/autoproxy.pac

    PrintSystemProxySetting
}

RestSystemProxy() {
    str="Resetting system proxy enviornment"
    echo -e "\033[32m${str}\033[0m"

    gsettings set org.gnome.system.proxy mode 'none'

    PrintSystemProxySetting
}

PrintSystemProxySetting() {

    http_host=$(gsettings get org.gnome.system.proxy.http host)
    http_port=$(gsettings get org.gnome.system.proxy.http port)
    https_host=$(gsettings get org.gnome.system.proxy.https host)
    https_port=$(gsettings get org.gnome.system.proxy.https port)
    socks_host=$(gsettings get org.gnome.system.proxy.socks host)
    socks_port=$(gsettings get org.gnome.system.proxy.socks port)

    proxy_mode=$(gsettings get org.gnome.system.proxy mode)

    str=""" http_proxy="${http_host}":${http_port}\n
    https_proxy=${https_host}:${https_port}\n
    socks_proxy=${socks_host}:${socks_port}\n
    proxy_mode=${proxy_mode}"""

    echo -e $str

}

killProcess() {
    str="Stopping v2ray process"
    echo -e "\033[32m${str}\033[0m"

    echo "filename:$0"
    echo "firstParameter:$1"
    echo "firstParameter:$2"
    echo "firstParameter:$3"

    str="Searching process:"
    echo -e "\033[32m${str}\033[0m"

    ret=$(sudo ps -ef | grep v2ray)
    echo $ret
    if [[ $ret =~ "/usr/local/bin/v2ray-linux-32-v4.21.3/v2ray-linux-32-v4.21.3/v2ray" ]]; then
        ps -aux | grep $1 | grep -v grep | awk '{print $2}' | xargs kill -9
        str="killed process"
        echo -e "\033[32m${str}\033[0m"
        sudo ps -ef | grep v2ray
    else
        str="v2ray not running"
        echo -e "\033[32m${str}\033[0m"
    fi

}

StopV2Ray() {
    killProcess "v2ray"
}

InstallShell() {
    str="Installing v2ray.sh to /usr/bin/v2ray.sh"
    echo -e "\033[32m${str}\033[0m"

    sudo cp -r ./v2ray.sh /usr/bin/v2ray.sh
    sudo chmod +x /usr/bin/v2ray.sh

    # ls -ah /usr/bin/ | grep v2ray
    whereis v2ray.sh

    str="Installed v2ray.sh to /usr/bin/v2ray.sh"
    echo -e "\033[32m${str}\033[0m"
    str="Now you can use 'v2ray.sh -h' anywhere"
    echo -e "\033[32m${str}\033[0m"
}

PrintVersion() {
    str="version: ${version}"
    echo -e "\033[30;7m${str}\033[0m"
    echo -e "\033[31;1m${str}\033[0m"
    echo -e "\033[32;1m${str}\033[0m"
    echo -e "\033[33;1m${str}\033[0m"
    echo -e "\033[34;1m${str}\033[0m"
    echo -e "\033[35;1m${str}\033[0m"
    echo -e "\033[36;2m${str}\033[0m"
    echo -e "\033[37;5m${str}\033[0m"
}

helpstr="""\033[33;1mControl v2ray start/stop under shell\033[0m
\033[34;1m
Useage:
v2ray.sh [options]

--install -i   copy v2ray.sh to /usr/bin/v2ray.sh and chmod +x.
--start -s     start v2ray and set the system environment, 
               also can be used for showing the proxy connections.
--stop  -p     stop v2ray and unset the system environment.
\033[0m
\033[35;1m
Example:
./v2ray.sh -i # install to /usr/bin/
v2ray.sh -s # start v2ray(requires v2ray install in the enviornment.)
\033[0m
"""

if [ "$1" = "--start" ] || [ "$1" = "-s" ]; then
    StartV2Ray
    SetSystemProxy
elif [ "$1" = "--stop" ] || [ "$1" = "-p" ]; then
    StopV2Ray
    RestSystemProxy
elif [ "$1" = "--install" ] || [ "$1" = "-i" ]; then
    InstallShell
elif [ "$1" = "--version" ] || [ "$1" = "-v" ]; then
    PrintVersion
else
    echo -e "${helpstr}"
fi
