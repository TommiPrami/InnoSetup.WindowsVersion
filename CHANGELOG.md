# Changelog

All notable changes to this project are documented here. The format is loosely
based on [Keep a Changelog](https://keepachangelog.com/). This project is not
formally versioned yet, so changes are listed under *Unreleased*.

## Unreleased

### Added
- Version naming: `WindowsVersionStr` / `WindowsVersion`, table-driven for the
  Windows 10/11 era (with Server names), covering up to Windows 11 26H2 /
  Windows Server 2025.
- Comparison: `IsWindowsVersion`, the `IsWinXxx` / `IsWinServerXxxx` helper
  family, and `CompareVersionsStr` for whole-or-partial dotted strings
  (a missing or `-1` trailing part is a wildcard; a 4th revision part is
  ignored).
- Support lifecycle from endoflife.date (Workstation / Enterprise / Server
  tracks): `IsWindowsActiveSupportEnded`, `IsWindowsSecuritySupportEnded`,
  `IsWindowsSupported` (one-call install gate with day-slack), the by-build/
  by-track getters, `IsPastWithSlackDays`, and `IsWindowsDataStale`.
- Human-readable durations: `DaysUntil`, `DurationStr`, `DaysUntilStr`,
  `WindowsSupportUntilStr`, with localisable unit words via
  `SetDurationUnitWords` (English by default).
- Edition detection via `GetProductInfo`: `GetWindowsEdition`,
  `IsWindowsHomeEdition`, `WindowsEditionToStr`; plus `IsWindowsServer`,
  `IsWindows10`, `IsWindows11`, `GetWindowsBuildNumber`, `GetWindowsVersionParts`.
- Test hooks to fake the OS version, suite mask and product type, shared by the
  DUnitX suite and the Inno test installer.
- `Normalize-SourceEncoding.ps1` / `.cmd` to keep sources UTF-8 + BOM + CRLF.
- GitHub Actions CI that compiles the test installer and runs its `[Code]`
  self-tests headlessly.

### Fixed
- Comparison direction corrected to "is the OS {method} the given version"
  (the DUnitX expectations had been reversed).
- Partial (`-1`) comparison works again under Inno 7's unsigned
  `TWindowsVersion` via a signed-integer comparison record, on both operands.
- Renamed mislabelled helpers: `IsWin10_1067`→`IsWin10_1607`,
  `IsWinServer2016_1079`→`IsWinServer2016_1709`, `IsWin11_21H1`→`IsWin11_21H2`,
  `IsWinServer_25H2`→`IsWinServer2025` (now build 26100).
- Server 2012 R2 (6.3.9600) and Vista SP2 (6.0.6002/6003) naming; a possible
  empty-string result for unknown 6.x minor versions.
- `TestInstaller` no longer fails with "CreateFile failed; code 5" (added
  `Uninstallable=no`).
- Numerous comment / message / identifier typos.
