# GitHub Pages Deployment Guide

## Overview
This website is now configured to deploy automatically to GitHub Pages using GitHub Actions whenever you push to the `master` branch.

## Repository Setup

### 1. Enable GitHub Pages
1. Go to your repository: https://github.com/Dunkansdk/personal-website
2. Navigate to **Settings** → **Pages**
3. Under **Source**, select: **GitHub Actions**

### 2. Configure Custom Domain

#### On GitHub:
1. In **Settings** → **Pages**
2. Under **Custom domain**, enter: `emanueldurso.com`
3. Click **Save**
4. Check **Enforce HTTPS** (wait for DNS to propagate first)

#### On Your Domain Registrar:
You need to add DNS records at your domain registrar (GoDaddy, Namecheap, Cloudflare, etc.):

**Option A: Using A Records (Apex Domain)**
Add these A records for `emanueldurso.com`:
```
185.199.108.153
185.199.109.153
185.199.110.153
185.199.111.153
```

**Option B: Using CNAME (www subdomain)**
If you want to use `www.emanueldurso.com`, add:
- Type: CNAME
- Host: www
- Value: dunkansdk.github.io

**For both options, also add:**
- Type: CNAME
- Host: www (if not already added)
- Value: dunkansdk.github.io

**Or for apex domain:**
- Type: A
- Host: @ (or blank)
- Values: (the four IPs above)

### 3. Deployment Process

The workflow will automatically:
1. Checkout your code
2. Setup Hugo and Node.js
3. Install dependencies
4. Build your CSS
5. Build the Hugo site
6. Deploy to GitHub Pages

### 4. Trigger Deployment

To deploy your site:
```bash
git add .
git commit -m "Deploy to GitHub Pages"
git push origin master
```

Or manually trigger from GitHub:
1. Go to **Actions** tab
2. Select "Deploy Hugo site to GitHub Pages"
3. Click **Run workflow**

### 5. Monitor Deployment

1. Go to the **Actions** tab in your repository
2. Watch the workflow progress
3. Once complete, your site will be live at:
   - https://dunkansdk.github.io/personal-website (GitHub Pages URL)
   - https://emanueldurso.com (once DNS propagates)

### 6. DNS Propagation

After configuring DNS records, it may take:
- **15 minutes to 48 hours** for DNS changes to propagate worldwide
- You can check status at: https://www.whatsmydns.net/#A/emanueldurso.com

### 7. Troubleshooting

**Site not loading on custom domain:**
- Verify DNS records are correct
- Wait for DNS propagation (up to 48 hours)
- Check GitHub Pages settings show your custom domain
- Ensure CNAME file exists in `static/` directory

**Build failing:**
- Check the Actions tab for error messages
- Ensure all dependencies in package.json are correct
- Verify Hugo version compatibility

**404 errors:**
- Make sure `baseURL` in config.toml matches your domain
- Clear browser cache
- Check that files are in the `public` directory after build

## Files Created

1. `.github/workflows/deploy.yml` - GitHub Actions workflow
2. `static/CNAME` - Custom domain configuration
3. `GITHUB_PAGES.md` - This guide

## Next Steps

1. Push these changes to GitHub
2. Enable GitHub Pages in repository settings
3. Configure DNS records at your domain registrar
4. Wait for DNS propagation
5. Enable HTTPS in GitHub Pages settings

Your website will be automatically deployed whenever you push to the `master` branch!
