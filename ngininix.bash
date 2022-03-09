
#!/bin/bash
yum install epel-release
yum install nginx
nano /etc/nginx/sites-available/beaniebabyworld.conf
server {
listen 80;
server_name ecom.beaniebabyworld.com;
location / {
root /var/www/nginxsite.com/public_html;
index index.html index.htm;
try_files $uri $uri/ =404;
} error_page 500 502 503 504 /50x.html;
location = /50x.html {
root html;
}
}
server {
listen 80;
server_name bbtoys.beaniebabyworld.com;
location / {
root /var/www/nginxsite.com/public_html;
index index.html index.htm;
try_files $uri $uri/ =404;
} error_page 500 502 503 504 /50x.html;
location = /50x.html {
root html;
}
}




ln -s /etc/nginx/sites-available/nginxsite.com.conf
/etc/nginx/sites-enabled/nginxsite.com.conf
service nginx restart