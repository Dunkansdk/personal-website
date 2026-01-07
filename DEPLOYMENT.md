# Deployment Guide: Hostinger VPS + GitHub Actions

This guide explains how to deploy your Hugo personal website to a Hostinger VPS using GitHub Actions for automatic deployment.

## Prerequisites

- Hostinger VPS with Ubuntu/Debian
- Domain configured (emanueldurso.com)
- GitHub repository
- SSH access to VPS

---

## Part 1: VPS Setup (One-time setup)

### 1. Connect to your VPS

```bash
ssh root@your-vps-ip
```

### 2. Create deployment user

```bash
# Create a deployment user
adduser deploy
usermod -aG sudo deploy

# Switch to deploy user
su - deploy
```

### 3. Install required software

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Nginx
sudo apt install nginx -y

# Install Certbot for SSL
sudo apt install certbot python3-certbot-nginx -y

# Start and enable Nginx
sudo systemctl start nginx
sudo systemctl enable nginx
```

### 4. Configure Nginx

Create site configuration:

```bash
sudo nano /etc/nginx/sites-available/emanueldurso.com
```

Paste this configuration:

```nginx
server {
    listen 80;
    listen [::]:80;
    
    server_name emanueldurso.com www.emanueldurso.com;
    
    root /var/www/emanueldurso.com/html;
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
    gzip_types text/plain text/css text/xml text/javascript application/x-javascript application/xml+rss application/json;
    
    location / {
        try_files $uri $uri/ =404;
    }
    
    # Cache static assets
    location ~* \.(jpg|jpeg|png|gif|ico|css|js|svg|woff|woff2|ttf|eot)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
```

Enable the site:

```bash
sudo ln -s /etc/nginx/sites-available/emanueldurso.com /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

### 5. Create website directory

```bash
sudo mkdir -p /var/www/emanueldurso.com/html
sudo chown -R deploy:deploy /var/www/emanueldurso.com
```

### 6. Setup SSL Certificate

```bash
sudo certbot --nginx -d emanueldurso.com -d www.emanueldurso.com
```

Follow the prompts to set up automatic HTTPS.

---

## Part 2: SSH Key Setup

### 1. Generate SSH key pair on your local machine

```bash
ssh-keygen -t ed25519 -C "github-actions-deploy" -f ~/.ssh/hostinger_deploy
```

This creates:
- Private key: `~/.ssh/hostinger_deploy`
- Public key: `~/.ssh/hostinger_deploy.pub`

### 2. Add public key to VPS

On your VPS as the `deploy` user:

```bash
mkdir -p ~/.ssh
chmod 700 ~/.ssh
nano ~/.ssh/authorized_keys
```

Paste the contents of `hostinger_deploy.pub` and save.

```bash
chmod 600 ~/.ssh/authorized_keys
```

### 3. Test SSH connection

From your local machine:

```bash
ssh -i ~/.ssh/hostinger_deploy deploy@your-vps-ip
```

---

## Part 3: GitHub Repository Setup

### 1. Add GitHub Secrets

Go to your repository: **Settings → Secrets and variables → Actions → New repository secret**

Add these secrets:

| Secret Name | Value | Example |
|------------|-------|---------|
| `VPS_HOST` | Your VPS IP or hostname | `123.45.67.89` |
| `VPS_USERNAME` | SSH username | `deploy` |
| `VPS_SSH_KEY` | Private key content | Paste entire `hostinger_deploy` file |
| `VPS_PORT` | SSH port (usually 22) | `22` |

### 2. Copy private key content

```bash
# On your local machine
cat ~/.ssh/hostinger_deploy
```

Copy the entire output (including `-----BEGIN OPENSSH PRIVATE KEY-----` and `-----END OPENSSH PRIVATE KEY-----`) and paste it into `VPS_SSH_KEY` secret.

### 3. Push workflow file

The workflow file is already created at `.github/workflows/deploy.yml`. Commit and push:

```bash
git add .github/workflows/deploy.yml
git commit -m "Add GitHub Actions deployment workflow"
git push origin main
```

---

## Part 4: DNS Configuration

### Configure DNS at your domain registrar:

**A Records:**
```
@ (root)          → Your VPS IP
www               → Your VPS IP
```

**Or use Cloudflare (recommended):**
1. Add domain to Cloudflare
2. Update nameservers at registrar
3. Add A records pointing to VPS IP
4. Enable proxy (orange cloud) for DDoS protection and CDN

---

## Part 5: Deployment

### Automatic Deployment

Every push to the `main` branch will automatically:
1. Build the Hugo site
2. Compile SASS/CSS
3. Deploy to your VPS
4. Reload Nginx

### Manual Deployment

Go to: **Actions → Deploy to Hostinger VPS → Run workflow**

---

## Verification

After deployment:

1. **Check build status**: GitHub Actions tab
2. **Test website**: `https://emanueldurso.com`
3. **Check SSL**: Should show padlock icon
4. **Test RSS feed**: `https://emanueldurso.com/index.xml`

---

## Troubleshooting

### SSH Connection Failed

```bash
# Test SSH manually
ssh -i ~/.ssh/hostinger_deploy deploy@your-vps-ip

# Check SSH key format (should start with -----BEGIN OPENSSH PRIVATE KEY-----)
cat ~/.ssh/hostinger_deploy
```

### Permission Denied

```bash
# On VPS, fix permissions
sudo chown -R deploy:deploy /var/www/emanueldurso.com
sudo chmod -R 755 /var/www/emanueldurso.com
```

### Nginx not serving files

```bash
# Check Nginx status
sudo systemctl status nginx

# Test configuration
sudo nginx -t

# Check logs
sudo tail -f /var/log/nginx/error.log
```

### SSL certificate issues

```bash
# Renew certificate manually
sudo certbot renew

# Test auto-renewal
sudo certbot renew --dry-run
```

---

## Monitoring & Maintenance

### Check deployment logs

GitHub Actions → Latest workflow run → View logs

### Check website uptime

Use monitoring services:
- UptimeRobot (free)
- Pingdom
- StatusCake

### Backup strategy

```bash
# On VPS - Create weekly backup cron job
crontab -e
```

Add:
```
0 2 * * 0 tar -czf /home/deploy/backups/site-$(date +\%Y\%m\%d).tar.gz /var/www/emanueldurso.com/html
```

---

## Security Recommendations

1. **Firewall**: Enable UFW
   ```bash
   sudo ufw allow OpenSSH
   sudo ufw allow 'Nginx Full'
   sudo ufw enable
   ```

2. **Fail2ban**: Prevent brute force
   ```bash
   sudo apt install fail2ban -y
   sudo systemctl enable fail2ban
   ```

3. **Auto-updates**:
   ```bash
   sudo apt install unattended-upgrades -y
   sudo dpkg-reconfigure --priority=low unattended-upgrades
   ```

4. **Disable root SSH**:
   ```bash
   sudo nano /etc/ssh/sshd_config
   # Set: PermitRootLogin no
   sudo systemctl restart sshd
   ```

---

## Cost Estimate

- **Hostinger VPS**: ~$4-8/month (depending on plan)
- **Domain**: ~$10-15/year
- **GitHub Actions**: Free (2,000 minutes/month for public repos)
- **Cloudflare**: Free (optional)

**Total**: ~$5-10/month

---

## Alternative: Cloudflare Pages

If you prefer a simpler setup without VPS management:

1. Push to GitHub
2. Connect to Cloudflare Pages
3. Auto-deploy on push
4. Free SSL, CDN, unlimited bandwidth
5. Cost: $0/month

However, VPS gives you more control for future expansion (APIs, backend services, databases, etc.).
