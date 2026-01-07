#!/bin/bash

# VPS Initial Setup Script for Hostinger
# Run this on your fresh VPS as root user
# Usage: bash vps-setup.sh

set -e  # Exit on error

echo "====================================="
echo "Hostinger VPS Setup for Hugo Site"
echo "====================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
DOMAIN="emanueldurso.com"
DEPLOY_USER="deploy"
SITE_ROOT="/var/www/${DOMAIN}"
EMAIL="emanueldurso1@gmail.com"  # For Let's Encrypt

echo -e "${GREEN}[1/8] Updating system packages...${NC}"
apt update && apt upgrade -y

echo -e "${GREEN}[2/8] Installing required packages...${NC}"
apt install -y nginx certbot python3-certbot-nginx ufw fail2ban git curl unattended-upgrades

echo -e "${GREEN}[3/8] Creating deployment user...${NC}"
if id "$DEPLOY_USER" &>/dev/null; then
    echo "User $DEPLOY_USER already exists, skipping..."
else
    adduser --disabled-password --gecos "" $DEPLOY_USER
    usermod -aG sudo $DEPLOY_USER
    echo "$DEPLOY_USER ALL=(ALL) NOPASSWD: /usr/sbin/nginx, /bin/systemctl reload nginx, /bin/systemctl restart nginx, /bin/chown, /bin/chmod, /bin/mkdir" >> /etc/sudoers.d/$DEPLOY_USER
    echo "User $DEPLOY_USER created"
fi

echo -e "${GREEN}[4/8] Setting up website directory...${NC}"
mkdir -p ${SITE_ROOT}/html
chown -R ${DEPLOY_USER}:${DEPLOY_USER} ${SITE_ROOT}
chmod -R 755 ${SITE_ROOT}

echo -e "${GREEN}[5/8] Configuring Nginx...${NC}"
cat > /etc/nginx/sites-available/${DOMAIN} <<EOF
server {
    listen 80;
    listen [::]:80;
    
    server_name ${DOMAIN} www.${DOMAIN};
    
    root ${SITE_ROOT}/html;
    index index.html;
    
    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header Referrer-Policy "no-referrer-when-downgrade" always;
    
    # Gzip compression
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_types text/plain text/css text/xml text/javascript application/x-javascript application/xml+rss application/json application/rss+xml;
    
    location / {
        try_files \$uri \$uri/ =404;
    }
    
    # Cache static assets
    location ~* \.(jpg|jpeg|png|gif|ico|css|js|svg|woff|woff2|ttf|eot)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
    
    # RSS feed
    location ~* \.(xml)$ {
        expires 1h;
        add_header Cache-Control "public";
    }
}
EOF

ln -sf /etc/nginx/sites-available/${DOMAIN} /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default
nginx -t
systemctl restart nginx

echo -e "${GREEN}[6/8] Configuring firewall...${NC}"
ufw --force enable
ufw allow OpenSSH
ufw allow 'Nginx Full'
ufw status

echo -e "${GREEN}[7/8] Enabling fail2ban...${NC}"
systemctl enable fail2ban
systemctl start fail2ban

echo -e "${GREEN}[8/8] Enabling automatic security updates...${NC}"
dpkg-reconfigure --priority=low unattended-upgrades

echo ""
echo -e "${GREEN}====================================="
echo "Setup Complete!"
echo "=====================================${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Set up SSH key for deployment user:"
echo "   - Switch to deploy user: su - $DEPLOY_USER"
echo "   - Create .ssh directory: mkdir -p ~/.ssh && chmod 700 ~/.ssh"
echo "   - Add your public key to: ~/.ssh/authorized_keys"
echo "   - Set permissions: chmod 600 ~/.ssh/authorized_keys"
echo ""
echo "2. Point your domain DNS to this server's IP"
echo ""
echo "3. Run SSL certificate setup:"
echo "   sudo certbot --nginx -d ${DOMAIN} -d www.${DOMAIN} --email ${EMAIL} --agree-tos --no-eff-email"
echo ""
echo "4. Configure GitHub Actions secrets with:"
echo "   VPS_HOST: $(curl -s ifconfig.me)"
echo "   VPS_USERNAME: ${DEPLOY_USER}"
echo "   VPS_SSH_KEY: (your private SSH key)"
echo "   VPS_PORT: 22"
echo ""
echo "5. Test deployment by pushing to GitHub"
echo ""
echo -e "${GREEN}Server IP: $(curl -s ifconfig.me)${NC}"
echo ""
