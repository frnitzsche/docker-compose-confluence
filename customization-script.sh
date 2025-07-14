#!/bin/bash
host="anishev.mywire.org"
sudo yum install docker nginx certbot certbot-nginx httpd-tools -y && \
sudo htpasswd -b -c /etc/nginx/.htpasswd user '478312zxc'
sudo systemctl enable docker.service && \
sudo systemctl start docker.service && \
sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-linux-$(uname -m) -o /usr/bin/docker-compose && \
sudo chmod 755 /usr/bin/docker-compose && \
cd /docker-compose-confluence && \
sudo docker-compose up -d && \
sudo wget --trust-server-names https://www.dynu.com/support/downloadfile/70 && \
sudo yum install ./dynu-ip-update-client_1.0.2-1_amd64.rpm -y && \
sudo cp /docker-compose-confluence/appsettings.json /usr/share/dynu-ip-update-client/appsettings.json && \
sudo systemctl restart dynu-ip-update-client.service && \
sudo sed -i "s/server_name  _;/server_name ${host};/g" /etc/nginx/nginx.conf && \

sed '/root         \/usr\/share\/nginx\/html;/r'<(cat <<EOF
        location / {
            auth_basic           "Restricted Access Area";
            auth_basic_user_file /etc/nginx/.htpasswd;
            proxy_pass http://127.0.0.1:8090;
            proxy_set_header Host \$host;
            proxy_set_header X-Real-IP \$remote_addr;
            proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto \$scheme;
        }
EOF
) -i -- /etc/nginx/nginx.conf && \

sudo systemctl enable nginx.service && \
sudo systemctl restart nginx.service && \
sudo certbot --nginx -d $host -m my@mail.com --agree-tos -n

