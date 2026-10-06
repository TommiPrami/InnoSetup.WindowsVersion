// WindowsVersionTypes.inc

// Common types in between InnoSetup and Delphi-Unittest code
type
  TVersionCompareMethod = (vcmOlder, vcmOlderOrEqual, vcmEqual, vcmNewerOrEqual, vcmNewer);

  // Support-lifecycle track. Workstation = Home/Pro/Pro Edu/Pro WS; Enterprise =
  // Enterprise/Education; Server = the Server SKU for that build.
  TWindowsSupportTrack = (stWorkstation, stEnterprise, stServer);

  // Desktop edition family, from GetProductInfo. weProfessional covers Pro,
  // Pro for Workstations and Pro Education (all on the Workstation track);
  // weEducation is plain Education (Enterprise track). weServer = any Server SKU.
  TWindowsEdition = (weUnknown, weHome, weProfessional, weEnterprise, weEducation, weServer);

  // Comparison-layer mirror of Inno Setup's TWindowsVersion record.
  // Inno Setup 7 made the version parts unsigned (Cardinal), which broke the
  // partial compare where -1 marks a version part as "skip". This record uses
  // signed Integers so -1 survives and partial comparison works again.
  TWindowsVersionInfo = record
    Major: Integer;
    Minor: Integer;
    Build: Integer;
    ServicePackMajor: Integer;
    ServicePackMinor: Integer;
    NTPlatform: Boolean;
    ProductType: Integer;
    SuiteMask: Integer;
  end;

  // One row of the Windows 10/11 era lookup table (see WindowsVersionCommonCode).
  // Keyed by Build. ServerName is used when running on a Server SKU; when it is
  // empty the client Name is used for both. Dates are YYYYMMDD integers (0 =
  // unknown / not announced), so they compare chronologically with no TDateTime.
  //
  // Three support tracks (client LTSC is intentionally not modelled):
  //   W = Workstation : Home / Pro / Pro Education / Pro for Workstations
  //   E = Enterprise  : Enterprise / Education
  //   S = Server      : the Server SKU (LTSC/AC) that shares this build
  // For most client releases Active and Security coincide; they are kept
  // separate because a few differ and Server rows use the distinction.
  // Data from endoflife.date/windows + /windows-server (snapshot 2026-10-06).
  TWindowsReleaseRecord = record
    Build: Integer;
    Name: string;                 // client / default name
    ServerName: string;           // '' = same name on Server SKUs
    ReleaseDate: Integer;         // YYYYMMDD
    ActiveSupportEndW: Integer;   // Workstation: active / mainstream support end
    SecuritySupportEndW: Integer; // Workstation: security support end (EOL)
    ActiveSupportEndE: Integer;   // Enterprise:  active / mainstream support end
    SecuritySupportEndE: Integer; // Enterprise:  security support end (EOL)
    ActiveSupportEndS: Integer;   // Server:      active / mainstream support end
    SecuritySupportEndS: Integer; // Server:      security support end (EOL)
  end;
