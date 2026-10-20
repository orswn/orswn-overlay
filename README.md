# orswn-overlay

Personal Gentoo overlay for ebuilds that are not in the main Gentoo tree or need local packaging.

## Add with eselect-repository

```bash
sudo eselect repository add orswn-overlay git https://github.com/orswn/orswn-overlay.git
sudo emerge --sync orswn-overlay
```

## Packages

- `app-accessibility/hyprwhspr` - native speech-to-text dictation for Wayland desktops

Install hyprwhspr:

```bash
sudo emerge app-accessibility/hyprwhspr
```

With the GTK microphone OSD visualizer dependencies:

```bash
sudo emerge app-accessibility/hyprwhspr[visualizer]
```

## License

Ebuilds and metadata are distributed under the GNU General Public License v2. See `LICENSE`.
