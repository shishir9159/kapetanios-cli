#! /bin/sh
while IFS=$': \t' read -a line; 
    do [ -z "${line%inet}" ] && ip=${line[${#line[1]}>4?1:2]} && [ "${ip#127.0.0.1}" ] && myip=$ip;
	echo $ip; 
    done< <(LANG=C /sbin/ifconfig);
