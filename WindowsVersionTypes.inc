// WindowsVersionTypes.inc

// Common types in between InnoSetup and Delphi-Unittest code
type
  TVersionCompareMethod = (vcmOlder, vcmOlderOrEqual, vcmEqual, vcmNewerOrEqual, vcmNewer);

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
  TWindowsVersionRec = record
    Build: Integer;
    Name: string;                 // client / default name
    ServerName: string;           // '' = same name on Server SKUs
    ReleaseDate: Integer;         // YYYYMMDD
    EndOfSupport: Integer;        // YYYYMMDD - consumer / mainstream
    EndOfSupportExtended: Integer;// YYYYMMDD - Enterprise/Education / extended
  end;
