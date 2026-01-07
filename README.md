# Personal Website of Emanuel Matias D'Urso

Personal website and blog built with Hugo, featuring articles about systems programming, game development, and software architecture.

Based on [lucianonooijen/Personal-Website](https://github.com/lucianonooijen/Personal-Website).

## 🚀 Quick Start

### Prerequisites
- [Hugo](https://gohugo.io/installation/) v0.154.3 or later (extended version)
- Node.js 18+ and npm

### Development

```bash
# Install dependencies
npm install

# Build CSS
npm run build:css

# Run development server
hugo server

# Visit http://localhost:1313
```

### Production Build

```bash
# Build site
hugo --minify --gc -d build -b https://emanueldurso.com

# Output will be in ./build directory
```

## 📦 Project Structure

```
personal-website/
├── .github/workflows/    # GitHub Actions CI/CD
├── archetypes/          # Content templates
├── assets/              # SASS/CSS source files
├── content/             # Blog posts and pages
│   ├── about.md
│   ├── blog/
│   ├── contact.md
│   ├── experience.md
│   └── expertise.md
├── layouts/             # Hugo templates
├── static/              # Static assets (images, css)
├── config.toml          # Hugo configuration
└── DEPLOYMENT.md        # Deployment guide
```

## 🔧 Features

- **Static Site Generation** with Hugo
- **RSS Feed** available at `/index.xml`
- **Responsive Design**
- **No JavaScript Required** (progressive enhancement)
- **Automatic Deployment** via GitHub Actions
- **SSL/HTTPS** with Let's Encrypt

## 🌐 Deployment

This site is automatically deployed to a Hostinger VPS via GitHub Actions on every push to `main`.

See [DEPLOYMENT.md](DEPLOYMENT.md) for complete setup instructions.

### Quick Deployment Setup

1. **VPS Setup**: Run on your Hostinger VPS
   ```bash
   wget https://raw.githubusercontent.com/Dunkansdk/personal-website/main/scripts/vps-setup.sh
   sudo bash vps-setup.sh
   ```

2. **Configure GitHub Secrets** (Repository → Settings → Secrets):
   - `VPS_HOST` - Your VPS IP address
   - `VPS_USERNAME` - SSH username (usually `deploy`)
   - `VPS_SSH_KEY` - Private SSH key for deployment
   - `VPS_PORT` - SSH port (usually `22`)

3. **Push to GitHub** - Automatic deployment will start

## 📝 Creating Content

### New Blog Post

```bash
hugo new blog/my-post-title.md
```

Edit the generated file in `content/blog/my-post-title.md`:

```markdown
+++
title = "My Post Title"
date = 2026-01-07T12:00:00-03:00
draft = false
tags = ["tag1", "tag2"]
+++

Your content here...
```

### Update Pages

Edit markdown files in `content/` directory:
- `about.md` - About page
- `experience.md` - Work experience
- `expertise.md` - Technical skills
- `contact.md` - Contact information

## 🎨 Customization

### Site Configuration

Edit `config.toml`:

```toml
title = "Your Name"
baseurl = "https://yourdomain.com"

[params]
    author = "Your Name"
    authorEmail = "your@email.com"
    info = "Your tagline"
    description = "Your description"
```

### Styling

SASS files are in `assets/styles/`. After editing, rebuild CSS:

```bash
npm run build:css
```

## 📊 Analytics & Monitoring

This site is designed to be privacy-first with no tracking or analytics by default.

To add monitoring:
- UptimeRobot for uptime monitoring
- Cloudflare Analytics (privacy-friendly)

## 🔒 Security

- HTTPS enforced via Let's Encrypt
- Security headers configured in Nginx
- Regular automated updates on VPS
- Fail2ban protection against brute force

## 📄 License

- Website code: AGPL-3.0
- Content: CC-BY-SA 4.0

## 🤝 Contributing

This is a personal website, but feel free to use it as a template for your own site!

## 📧 Contact

Emanuel Matias D'Urso
- Email: emanueldurso1@gmail.com
- LinkedIn: [linkedin.com/in/emanueldurso1](https://www.linkedin.com/in/emanueldurso1)
- GitHub: [github.com/Dunkansdk](https://github.com/Dunkansdk)
