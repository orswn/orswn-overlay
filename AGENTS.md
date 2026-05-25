# Repository Guidelines

This is jsb's personal Gentoo overlay. Keep changes practical, minimal, and suitable for local use.

- Follow Gentoo ebuild conventions and EAPI 8 unless there is a clear reason to change.
- Prefer explicit runtime dependencies over bundled downloads or network access during build/install phases.
- Keep USE flags small and meaningful; default flags should reflect the intended local setup.
- When bumping a package version, compare the new upstream release against the previous one for changes that affect the ebuild: install layout, scripts, dependencies, services, config paths, Python modules, optional features, and USE flags.
- After changing an ebuild or distfile metadata, regenerate the package Manifest with `pkgdev manifest` or `ebuild <path> manifest`.
- Keep `metadata.xml`, `profiles/categories`, and package categories in sync when adding packages.
- Do not commit planning notes or temporary local files.
