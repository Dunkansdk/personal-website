# Personal Website of Emanuel Matias D'Urso

Personal website and blog built with Hugo, featuring articles about systems programming, game development, and software architecture.

Based on [lucianonooijen/Personal-Website](https://github.com/lucianonooijen/Personal-Website).

## 🚀 Quick Start

### Prerequisites
- [Hugo](https://gohugo.io/installation/) v0.154.3 or later (extended version)
- Node.js 18+ and npm

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
