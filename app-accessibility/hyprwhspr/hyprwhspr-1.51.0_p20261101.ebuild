# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )

inherit python-single-r1 systemd

# orswn/hyprwhspr branch gemini-transcribe. Pin the commit so the distfile checksum stays valid.
COMMIT="159bbd9aaf3a4886b2bdfab7da598624cfc7b191"

DESCRIPTION="Native speech-to-text dictation for Linux desktops"
HOMEPAGE="https://github.com/orswn/hyprwhspr https://github.com/goodroot/hyprwhspr https://hyprwhspr.com"
SRC_URI="https://github.com/orswn/${PN}/archive/${COMMIT}.tar.gz -> ${P}-${COMMIT:0:12}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+visualizer"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	app-shells/bash
	gui-apps/wl-clipboard
	media-libs/portaudio
	media-video/pipewire[pipewire-alsa]
	x11-apps/xprop
	x11-libs/libxkbcommon
	x11-misc/xclip
	x11-misc/xdotool
	x11-misc/ydotool
	visualizer? (
		gui-libs/gtk:4[introspection]
		gui-libs/gtk4-layer-shell[introspection]
	)
	$(python_gen_cond_dep '
		dev-python/dbus-python[${PYTHON_USEDEP}]
		dev-python/evdev[${PYTHON_USEDEP}]
		dev-python/jsonschema[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pip[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/pulsectl[${PYTHON_USEDEP}]
		dev-python/pyperclip[${PYTHON_USEDEP}]
		dev-python/pyudev[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/rich[${PYTHON_USEDEP}]
		dev-python/scipy[${PYTHON_USEDEP}]
		dev-python/sounddevice[${PYTHON_USEDEP}]
		dev-python/virtualenv[${PYTHON_USEDEP}]
		dev-python/websocket-client[${PYTHON_USEDEP}]
		visualizer? (
			dev-python/pycairo[${PYTHON_USEDEP}]
			dev-python/pygobject[${PYTHON_USEDEP}]
		)
	')
"
DEPEND="${RDEPEND}"
BDEPEND=""

src_prepare() {
	default
	python_fix_shebang lib utils
}

src_install() {
	local root=/usr/lib/${PN}

	exeinto "${root}/bin"
	doexe bin/hyprwhspr bin/meeting-recorder

	insinto "${root}"
	doins -r config lib share utils
	doins requirements*.txt
	fperms +x "${root}/config/hyprland/hyprwhspr-tray.sh"

	dosym "${root}/bin/hyprwhspr" /usr/bin/hyprwhspr
	dosym "${root}/bin/meeting-recorder" /usr/bin/meeting-recorder

	systemd_douserunit config/systemd/*.service

	dodoc README.md docs/CONFIGURATION.md docs/MANAGED_INSTALLATION.md
	python_optimize "${ED}${root}/lib"
}

pkg_postinst() {
	einfo "Run 'hyprwhspr setup' as your desktop user to create the per-user backend venv."
	einfo "Then enable the user unit if desired: systemctl --user enable --now hyprwhspr.service"
	einfo "Users need access to input devices and ydotool; the setup command can help configure this."
	elog "Some transcription backends install Python packages/models into XDG_DATA_HOME at setup time."
}
