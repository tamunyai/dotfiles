# Ghostty Notes

## GNOME Default Terminal

To set Ghostty as the default terminal in GNOME, run the following commands:

```bash
gsettings set org.gnome.desktop.default-applications.terminal exec ghostty
gsettings set org.gnome.desktop.default-applications.terminal exec-arg ''
```

## Machine-Local Overrides

This package supports local overrides via an untracked `local` file. Use `local.example` as a template for theme or font tweaks.
