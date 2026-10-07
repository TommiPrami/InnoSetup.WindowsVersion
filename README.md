# InnoSetup.WindowsVersion

Helpers for detecting and comparing the Windows version from Inno Setup Pascal
Script (and, via the same shared code, from Delphi). It names the running
Windows release, compares versions, reports edition and Server SKU, and tells
you when a release's support has ended.

It does not try to identify every historical Windows; it focuses on the
versions Microsoft still supports (Windows 10/11 and the matching Servers),
plus a best effort for a few older ones.

## Layout

- `WindowsVersionTypes.inc` - shared types.
- `WindowsVersionCommonCode.inc` - all the logic, shared verbatim between Inno
  Setup and the Delphi unit tests.
- `WindowsVersion.iss` - the Inno Setup entry point; `#include` this from your
  installer's `[Code]` section. It supplies the Inno-specific glue
  (`GetProductInfo`) and then includes the common code.
- `TestInstaller\` - a tiny installer that runs the routines as self-tests.
- `DUnitX\` - the Delphi DUnitX test project (220+ cases).

## Usage (Inno Setup)

```pascal
[Code]
#include "path\to\WindowsVersion.iss"

function InitializeSetup: Boolean;
begin
  Result := True;

  // Block Windows older than Windows 10 1607.
  if not IsWin10_1607(vcmNewerOrEqual) then
  begin
    MsgBox('Windows 10 1607 or newer is required.', mbCriticalError, MB_OK);
    Result := False;
  end;
end;
```

## Naming

- `WindowsVersionStr: string` - friendly name of the running OS, e.g.
  `Windows 11 24H2` (or `Windows Server 2025` on a Server SKU).
- `WindowsVersion(const AVersion: TWindowsVersion): string` - same, for a given
  version record.

## Comparing

The contract is **"is the running OS {method} the given version"**, where
`TVersionCompareMethod` is `vcmOlder | vcmOlderOrEqual | vcmEqual |
vcmNewerOrEqual | vcmNewer`.

- `IsWindowsVersion(AMajor, AMinor, ABuild: Integer; AMethod): Boolean`
- Named helpers: `IsWin7`, `IsWin8`, `IsWin81`, `IsWin10_1607`, `IsWin10_1809`,
  `IsWin10_1903` ... `IsWin10_22H2`, `IsWin11_21H2` ... `IsWin11_26H2`, and the
  `IsWinServerXXXX` family. Each takes a `TVersionCompareMethod`.
- `CompareVersionsStr('10.0.19045', '10.0', AMethod): Boolean` - compare two
  dotted strings. Either side may be partial: a missing (or `-1`) trailing part
  is a wildcard, and a 4th "revision" part is ignored. So `'10.0'` matches any
  `10.0.x`.

## Support lifecycle

Dates come from endoflife.date (`/windows` and `/windows-server`), as a dated
snapshot in the code - refresh it when new releases ship. Three tracks are
modelled (client LTSC is intentionally skipped):

- **Workstation** - Home / Pro / Pro Education / Pro for Workstations
- **Enterprise** - Enterprise / Education
- **Server** - the Server SKU sharing that build

Running-OS checks pick the track automatically from the detected edition. You
pass "today" as a `YYYYMMDD` integer (e.g. from
`GetDateTimeString('yyyymmdd', #0, #0)`):

```pascal
LToday := StrToInt(GetDateTimeString('yyyymmdd', #0, #0));

if IsWindowsSecuritySupportEnded(LToday) then
  // this OS no longer gets security updates

// Give 100 days of grace past end of security support before blocking:
if IsPastWithSlackDays(GetWindowsSecuritySupportEnd, LToday, 100) then
  Result := False;
```

Anything older than Windows 10 is always reported as past support; a build
newer than the table (not yet known) is treated as still supported. Also
available: `IsWindowsActiveSupportEnded`, `GetWindowsActiveSupportEnd`, and the
by-build/by-track `GetWindowsActiveSupportEndByBuild` /
`GetWindowsSecuritySupportEndByBuild`.

## Edition

- `IsWindowsServer: Boolean`
- `GetWindowsEdition: TWindowsEdition` - `weHome`, `weProfessional` (Pro / Pro WS
  / Pro Education), `weEnterprise`, `weEducation`, `weServer`, or `weUnknown`.
  Uses the `GetProductInfo` WinAPI, with a `VER_SUITE_PERSONAL` fallback for Home.
- `IsWindowsHomeEdition: Boolean`

## Testing

The DUnitX project and the test installer share the exact same `.inc` code. For
tests, the running OS can be faked so checks are deterministic on any machine:

```pascal
SetFakeWindowsVersion(10, 0, 19045, False);   { pretend Windows 10 22H2 }
SetFakeWindowsProductType(PRODUCT_ENTERPRISE); { pretend Enterprise edition }
...
ClearFakeWindowsVersion;                        { back to the real OS }
```

Build the DUnitX `.dpr` without the `TESTINSIGHT` define to run it as a console
app, or run it under TestInsight in the IDE.

## Housekeeping

`Normalize-SourceEncoding.ps1` (and the double-clickable
`Normalize-SourceEncoding.cmd`) force all source files to UTF-8 + BOM + CRLF,
skipping `thirdparty` / `3rdparty` folders.
