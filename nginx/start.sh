#!/bin/sh

INITIALSTART=0

echo "Running start.sh script of nginx"

# set initstart variable
if [ ! -f /home/appuser/data/nginx/firststart.flg ]
then 
    echo "First start, set initialstart variable to 1"
    INITIALSTART=1
    echo `date +%Y-%m-%d_%H:%M:%S_%z` > /home/appuser/data/nginx/firststart.flg
else
	echo "It's not the first start, skip first start section"
fi


if [ "$INITIALSTART" == "1" ]
then
    if [ -f /home/appuser/data/nginx/nginx.cnf ]; then rm -rf /home/appuser/data/nginx/nginx.cnf; fi
    echo "copy config file \"nginx.cnf\" with initial configuration"
    cp /home/appuser/app/nginx/nginx.cnf /home/appuser/data/nginx/nginx.cnf

    if [ -f /home/appuser/data/nginx/conf.d/nginx_init.cnf ]; then rm -rf /home/appuser/data/nginx/conf.d/nginx_init.cnf; fi

    echo "copy config file \"nginx_init.cnf\" with initial configuration"
    cp /home/appuser/app/nginx/nginx_init.cnf /home/appuser/data/nginx/conf.d/nginx_init.cnf

    echo "patch initial configuration file"
    sed -i -e "s/#NGX_PORT#/${NGX_PORT}/g" /home/appuser/data/nginx/conf.d/nginx_init.cnf
    sed -i -e "s/#NGX_DNSINITDOMAIN#/${NGX_DNSINITDOMAIN}/g" /home/appuser/data/nginx/conf.d/nginx_init.cnf

    echo "This is the very first start of the container. Check if createcerts.sh exist to create self-signed certs."
	if [ -f /home/appuser/app/tools/createcerts.sh ] 
    then 
        echo "createcerts.sh exist. Create self-signed certificates initially."
        /home/appuser/app/tools/createcerts.sh
        if [ "$?" == "1" ]; then exit 1; fi
        mv /home/appuser/data/certificates/key.key /home/appuser/data/nginx/certificates/key.pem 
        mv /home/appuser/data/certificates/cer.crt /home/appuser/data/nginx/certificates/cer.pem
    fi
else
	echo "It's not the first start, skip first start section"
fi

echo "Test nginx configuration file"
nginx -t -c /home/appuser/data/nginx/nginx.cnf

echo "Start nginx"
nginx -c /home/appuser/data/nginx/nginx.cnf