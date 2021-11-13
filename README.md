# shell

Shell scripts to enhance work efficiency...

## [v2ray.sh](v2ray.sh)

**Tested under Ubuntu-20.04**

Control v2ray using shell with:

- start proxy service (v2ray -config config.json)
- set system proxy enviornment on org.gnome.system.proxy.http/https/socks
- set system proxy status to manual/none

TODO:

- set docker proxy
- set apt proxy
- set wget proxy
- set curl proxy

Useage:

```text
Useage:
v2ray.sh [options]

--install -i   copy v2ray.sh to /usr/bin/v2ray.sh and chmod +x.
--start -s     start v2ray and set the system environment,
               also can be used for showing the proxy connections.
--stop  -p     stop v2ray and unset the system environment.


Example:
./v2ray.sh -i # install to /usr/bin/
v2ray.sh -s # start v2ray(requires v2ray install in the enviornment.)
```
