diff -Naur /etc/nginx/fastcgi_params /etc/nginx/fastcgi_params.bak > what.patch
patch -p0 fastcgi_params what.patch