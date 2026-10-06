unit Innosetup.WindowsVersion.DUnitX;

interface

uses
  DUnitX.TestFramework, TestUnit.Windows.Version;

type
  [TestFixture]
  TInnoSetupWindowsVersion = class
  public
    // Contract (same as the TestInstaller relies on): IsWindowsVersion(M, m, b, method)
    // answers "is the running OS {method} than the given M.m.b version".
    // These fixtures set the OS to Win7 (6.1.7600), so the expected value is
    // "Win7 {method} (M.m.b)".
    [Test]
    [TestCase('Older - 01', '5;1;0;False', ';')]
    [TestCase('Older - 02', '5;1;7000;False', ';')]
    [TestCase('Older - 03', '5;1;7800;False', ';')]
    [TestCase('Older - 04', '5;3;0;False', ';')]
    [TestCase('Older - 05', '5;3;7000;False', ';')]
    [TestCase('Older - 06', '5;3;7800;False', ';')]
    [TestCase('Older - 07', '6;0;0;False', ';')]
    [TestCase('Older - 08', '6;1;1000;False', ';')]
    [TestCase('Older - 09', '6;1;7600;False', ';')] // Win7 <-> Win7
    [TestCase('Older - 10', '6;1;7800;True', ';')]
    [TestCase('Older - 11', '6;2;0;True', ';')]
    [TestCase('Older - 12', '6;2;7000;True', ';')]
    [TestCase('Older - 13', '6;2;7600;True', ';')]
    [TestCase('Older - 14', '6;2;7800;True', ';')]
    [TestCase('Older - 15', '6;2;8800;True', ';')]
    [TestCase('Older - 16', '7;3;8800;True', ';')]
    [TestCase('Older - 17', '7;3;8800;True', ';')]
    [TestCase('Older - 18', '10;0;10240;True', ';')] // Win10 1507
    procedure IsWindowsVersionOlder(const AMajor, AMinor, ABuild: Integer; const AExcpectedResult: Boolean);

    [Test]
    [TestCase('OlderOrEqual - 01', '5;1;0;False', ';')]
    [TestCase('OlderOrEqual - 02', '5;1;7000;False', ';')]
    [TestCase('OlderOrEqual - 03', '5;1;7800;False', ';')]
    [TestCase('OlderOrEqual - 04', '5;3;0;False', ';')]
    [TestCase('OlderOrEqual - 05', '5;3;7000;False', ';')]
    [TestCase('OlderOrEqual - 06', '5;3;7800;False', ';')]
    [TestCase('OlderOrEqual - 07', '6;0;0;False', ';')]
    [TestCase('OlderOrEqual - 08', '6;1;1000;False', ';')]
    [TestCase('OlderOrEqual - 09', '6;1;7600;True', ';')] // Win7 <-> Win7
    [TestCase('OlderOrEqual - 10', '6;1;7800;True', ';')]
    [TestCase('OlderOrEqual - 11', '6;2;0;True', ';')]
    [TestCase('OlderOrEqual - 12', '6;2;7000;True', ';')]
    [TestCase('OlderOrEqual - 13', '6;2;7600;True', ';')]
    [TestCase('OlderOrEqual - 14', '6;2;7800;True', ';')]
    [TestCase('OlderOrEqual - 15', '6;2;8800;True', ';')]
    [TestCase('OlderOrEqual - 16', '7;3;8800;True', ';')]
    [TestCase('OlderOrEqual - 17', '7;3;8800;True', ';')]
    [TestCase('OlderOrEqual - 18', '10;0;10240;True', ';')] // Win10 1507
    procedure IsWindowsVersionOlderOrEqual(const AMajor, AMinor, ABuild: Integer; const AExcpectedResult: Boolean);

    [Test]
    [TestCase('NewerOrEqual - 01', '5;1;0;True', ';')]
    [TestCase('NewerOrEqual - 02', '5;1;7000;True', ';')]
    [TestCase('NewerOrEqual - 03', '5;1;7800;True', ';')]
    [TestCase('NewerOrEqual - 04', '5;3;0;True', ';')]
    [TestCase('NewerOrEqual - 05', '5;3;7000;True', ';')]
    [TestCase('NewerOrEqual - 06', '5;3;7800;True', ';')]
    [TestCase('NewerOrEqual - 07', '6;0;0;True', ';')]
    [TestCase('NewerOrEqual - 08', '6;1;1000;True', ';')]
    [TestCase('NewerOrEqual - 09', '6;1;7600;True', ';')] // Win7 <-> Win7
    [TestCase('NewerOrEqual - 10', '6;1;7800;False', ';')]
    [TestCase('NewerOrEqual - 11', '6;2;0;False', ';')]
    [TestCase('NewerOrEqual - 12', '6;2;7000;False', ';')]
    [TestCase('NewerOrEqual - 13', '6;2;7600;False', ';')]
    [TestCase('NewerOrEqual - 14', '6;2;7800;False', ';')]
    [TestCase('NewerOrEqual - 15', '6;2;8800;False', ';')]
    [TestCase('NewerOrEqual - 16', '7;3;8800;False', ';')]
    [TestCase('NewerOrEqual - 17', '7;3;8800;False', ';')]
    [TestCase('NewerOrEqual - 18', '10;0;10240;False', ';')] // Win10 1507
    procedure IsWindowsVersionNewerOrEqual(const AMajor, AMinor, ABuild: Integer; const AExcpectedResult: Boolean);

    [Test]
    [TestCase('Newer - 01', '5;1;0;True', ';')]
    [TestCase('Newer - 02', '5;1;7000;True', ';')]
    [TestCase('Newer - 03', '5;1;7800;True', ';')]
    [TestCase('Newer - 04', '5;3;0;True', ';')]
    [TestCase('Newer - 05', '5;3;7000;True', ';')]
    [TestCase('Newer - 06', '5;3;7800;True', ';')]
    [TestCase('Newer - 07', '6;0;0;True', ';')]
    [TestCase('Newer - 08', '6;1;1000;True', ';')]
    [TestCase('Newer - 09', '6;1;7600;False', ';')] // Win7 <-> Win7
    [TestCase('Newer - 10', '6;1;7800;False', ';')]
    [TestCase('Newer - 11', '6;2;0;False', ';')]
    [TestCase('Newer - 12', '6;2;7000;False', ';')]
    [TestCase('Newer - 13', '6;2;7600;False', ';')]
    [TestCase('Newer - 14', '6;2;7800;False', ';')]
    [TestCase('Newer - 15', '6;2;8800;False', ';')]
    [TestCase('Newer - 16', '7;3;8800;False', ';')]
    [TestCase('Newer - 17', '7;3;8800;False', ';')]
    [TestCase('Newer - 18', '10;0;10240;False', ';')] // Win10 1507
    procedure IsWindowsVersionNewer(const AMajor, AMinor, ABuild: Integer; const AExcpectedResult: Boolean);

    [Test]                        // Result = "version 1 (the OS) {method} version 2"
    [TestCase('Compare versions - 01', '5;1;0;10;0;19043;vcmOlder;True', ';')]
    // Equal versions
    [TestCase('Compare versions - 02', '10;0;19043;10;0;19043;vcmOlder;False', ';')]
    [TestCase('Compare versions - 03', '10;0;19043;10;0;19043;vcmOlderOrEqual;True', ';')]
    [TestCase('Compare versions - 03b', '10;0;19043;10;0;19043;vcmEqual;True', ';')]
    [TestCase('Compare versions - 04', '10;0;19043;10;0;19043;vcmNewerOrEqual;True', ';')]
    [TestCase('Compare versions - 05', '10;0;19043;10;0;19043;vcmNewer;False', ';')]
    // Version 1 newer than version 2 (by build)
    [TestCase('Compare versions - 06', '10;0;19043;10;0;19042;vcmOlder;False', ';')]
    [TestCase('Compare versions - 07', '10;0;19043;10;0;19042;vcmOlderOrEqual;False', ';')]
    [TestCase('Compare versions - 08', '10;0;19043;10;0;19042;vcmEqual;False', ';')]
    [TestCase('Compare versions - 09', '10;0;19043;10;0;19042;vcmNewerOrEqual;True', ';')]
    [TestCase('Compare versions - 10', '10;0;19043;10;0;19042;vcmNewer;True', ';')]
    // Version 1 older than version 2 (by build)
    [TestCase('Compare versions - 11', '10;0;19043;10;0;19044;vcmOlder;True', ';')]
    [TestCase('Compare versions - 12', '10;0;19043;10;0;19044;vcmOlderOrEqual;True', ';')]
    [TestCase('Compare versions - 13', '10;0;19043;10;0;19044;vcmEqual;False', ';')]
    [TestCase('Compare versions - 14', '10;0;19043;10;0;19044;vcmNewerOrEqual;False', ';')]
    [TestCase('Compare versions - 15', '10;0;19043;10;0;19044;vcmNewer;False', ';')]
    // Version 1 older than version 2 (by minor)
    [TestCase('Compare versions - 16', '10;0;19043;10;1;19043;vcmOlder;True', ';')]
    [TestCase('Compare versions - 17', '10;0;19043;10;1;19043;vcmOlderOrEqual;True', ';')]
    [TestCase('Compare versions - 18', '10;0;19043;10;1;19043;vcmEqual;False', ';')]
    [TestCase('Compare versions - 19', '10;0;19043;10;1;19043;vcmNewerOrEqual;False', ';')]
    [TestCase('Compare versions - 20', '10;0;19043;10;1;19043;vcmNewer;False', ';')]
    // Version 1 older than version 2 (by major)
    [TestCase('Compare versions - 21', '10;0;19043;11;0;19043;vcmOlder;True', ';')]
    [TestCase('Compare versions - 22', '10;0;19043;11;0;19043;vcmOlderOrEqual;True', ';')]
    [TestCase('Compare versions - 23', '10;0;19043;11;0;19043;vcmEqual;False', ';')]
    [TestCase('Compare versions - 24', '10;0;19043;11;0;19043;vcmNewerOrEqual;False', ';')]
    [TestCase('Compare versions - 25', '10;0;19043;11;0;19043;vcmNewer;False', ';')]
    // Version 1 newer than version 2 (by build)
    [TestCase('Compare versions - 26', '10;2;19044;10;2;19042;vcmOlder;False', ';')]
    [TestCase('Compare versions - 27', '10;2;19044;10;2;19042;vcmOlderOrEqual;False', ';')]
    [TestCase('Compare versions - 28', '10;2;19044;10;2;19042;vcmEqual;False', ';')]
    [TestCase('Compare versions - 29', '10;2;19044;10;2;19042;vcmNewerOrEqual;True', ';')]
    [TestCase('Compare versions - 30', '10;2;19044;10;2;19042;vcmNewer;True', ';')]
    // Version 1 newer than version 2 (by minor)
    [TestCase('Compare versions - 31', '10;3;19043;10;2;19042;vcmOlder;False', ';')]
    [TestCase('Compare versions - 32', '10;3;19043;10;2;19042;vcmOlderOrEqual;False', ';')]
    [TestCase('Compare versions - 33', '10;3;19043;10;2;19042;vcmEqual;False', ';')]
    [TestCase('Compare versions - 34', '10;3;19043;10;2;19042;vcmNewerOrEqual;True', ';')]
    [TestCase('Compare versions - 45', '10;3;19043;10;2;19042;vcmNewer;True', ';')]
    // Version 1 newer than version 2 (by major)
    [TestCase('Compare versions - 46', '11;3;19043;10;2;19042;vcmOlder;False', ';')]
    [TestCase('Compare versions - 47', '11;3;19043;10;2;19042;vcmOlderOrEqual;False', ';')]
    [TestCase('Compare versions - 48', '11;3;19043;10;2;19042;vcmEqual;False', ';')]
    [TestCase('Compare versions - 49', '11;3;19043;10;2;19042;vcmNewerOrEqual;True', ';')]
    [TestCase('Compare versions - 50', '11;3;19043;10;2;19042;vcmNewer;True', ';')]
    // Version 1 older than version 2 (by build)
    [TestCase('Compare versions - 51', '10;0;19043;10;0;19044;vcmOlder;True', ';')]
    [TestCase('Compare versions - 52', '10;0;19043;10;0;19044;vcmOlderOrEqual;True', ';')]
    [TestCase('Compare versions - 53', '10;0;19043;10;0;19044;vcmEqual;False', ';')]
    [TestCase('Compare versions - 54', '10;0;19043;10;0;19044;vcmNewerOrEqual;False', ';')]
    [TestCase('Compare versions - 55', '10;0;19043;10;0;19044;vcmNewer;False', ';')]
    // Version 1 older than version 2 (by minor)
    [TestCase('Compare versions - 56', '10;0;19043;10;1;19043;vcmOlder;True', ';')]
    [TestCase('Compare versions - 57', '10;0;19043;10;1;19043;vcmOlderOrEqual;True', ';')]
    [TestCase('Compare versions - 58', '10;0;19043;10;1;19043;vcmEqual;False', ';')]
    [TestCase('Compare versions - 59', '10;0;19043;10;1;19043;vcmNewerOrEqual;False', ';')]
    [TestCase('Compare versions - 60', '10;0;19043;10;1;19043;vcmNewer;False', ';')]
    // Version 1 older than version 2 (by major)
    [TestCase('Compare versions - 61', '11;0;19043;12;0;19043;vcmOlder;True', ';')]
    [TestCase('Compare versions - 62', '11;0;19043;12;0;19043;vcmOlderOrEqual;True', ';')]
    [TestCase('Compare versions - 63', '11;0;19043;12;0;19043;vcmEqual;False', ';')]
    [TestCase('Compare versions - 64', '11;0;19043;12;0;19043;vcmNewerOrEqual;False', ';')]
    [TestCase('Compare versions - 65', '11;0;19043;12;0;19043;vcmNewer;False', ';')]
    // Compare partial - build skipped (-1), major.minor equal
    [TestCase('Compare versions - 66', '10;0;19043;10;0;-1;vcmOlder;False', ';')]
    [TestCase('Compare versions - 67', '10;0;19043;10;0;-1;vcmOlderOrEqual;True', ';')]
    [TestCase('Compare versions - 68', '10;0;19043;10;0;-1;vcmEqual;True', ';')]
    [TestCase('Compare versions - 69', '10;0;19043;10;0;-1;vcmNewerOrEqual;True', ';')]
    [TestCase('Compare versions - 70', '10;0;19043;10;0;-1;vcmNewer;False', ';')]
    // Compare partial - minor and build skipped (-1), major equal
    [TestCase('Compare versions - 71', '10;0;19043;10;-1;-1;vcmOlder;False', ';')]
    [TestCase('Compare versions - 72', '10;0;19043;10;-1;-1;vcmOlderOrEqual;True', ';')]
    [TestCase('Compare versions - 73', '10;0;19043;10;-1;-1;vcmEqual;True', ';')]
    [TestCase('Compare versions - 74', '10;0;19043;10;-1;-1;vcmNewerOrEqual;True', ';')]
    [TestCase('Compare versions - 75', '10;0;19043;10;-1;-1;vcmNewer;False', ';')]
    procedure CompareWindowsVersions(const AMajor1, AMinor1, ABuild1, AMajor2, AMinor2, ABuild2: Integer;
      const ACompareMethod: TVersionCompareMethod; const AExcpectedResult: Boolean);

    [Test]                              // Result = "version 1 {method} version 2"; missing/extra parts handled
    // Full versions
    [TestCase('Str - 01', '10.0.19045;10.0.19045;vcmEqual;True', ';')]
    [TestCase('Str - 02', '10.0.19045;10.0.19045;vcmNewer;False', ';')]
    [TestCase('Str - 03', '10.0.19045;10.0.19044;vcmNewer;True', ';')]
    [TestCase('Str - 04', '10.0.19044;10.0.19045;vcmOlder;True', ';')]
    [TestCase('Str - 05', '10.0.19044;10.0.19045;vcmOlderOrEqual;True', ';')]
    // Build skipped on the second operand
    [TestCase('Str - 06', '10.0.19045;10.0;vcmEqual;True', ';')]
    [TestCase('Str - 07', '10.0.19045;10.0;vcmNewer;False', ';')]
    [TestCase('Str - 08', '10.1.0;10.0;vcmNewer;True', ';')]
    // Build skipped on the FIRST operand (skip works on either side)
    [TestCase('Str - 09', '10.0;10.0.19045;vcmEqual;True', ';')]
    [TestCase('Str - 10', '10.0;10.0.19045;vcmOlder;False', ';')]
    [TestCase('Str - 11', '10.0;10.0.19045;vcmOlderOrEqual;True', ';')]
    // Major only
    [TestCase('Str - 12', '10;10;vcmEqual;True', ';')]
    [TestCase('Str - 13', '10;11;vcmOlder;True', ';')]
    [TestCase('Str - 14', '11;10;vcmNewerOrEqual;True', ';')]
    // Fourth part (revision) is ignored
    [TestCase('Str - 15', '10.5.0.12332;10.5.0;vcmEqual;True', ';')]
    [TestCase('Str - 16', '10.1.0;10.5.0.12332;vcmOlder;True', ';')]
    [TestCase('Str - 17', '10.1.0;10.5.0.12332;vcmNewer;False', ';')]
    // Partial on both sides
    [TestCase('Str - 18', '10.2;10.1.5;vcmNewer;True', ';')]
    [TestCase('Str - 19', '10.1;10.1.5;vcmEqual;True', ';')]
    [TestCase('Str - 20', '11.0.0;10.9.9;vcmNewer;True', ';')]
    procedure CompareVersionsFromStrings(const AVersion, AVersionComparedTo: string;
      const ACompareMethod: TVersionCompareMethod; const AExcpectedResult: Boolean);

    // Clears the fake OS after every test so fake-based cases below do not leak
    // into the SetOSVersion-based cases above.
    [TearDown]
    procedure TearDown;

    // Name detection via the lookup table (and the legacy 6.x/XP branch), driven
    // by a fake OS version so it runs the same on any machine.
    [Test]
    [TestCase('Name - 1507',     '10;0;10240;False;Windows 10 1507', ';')]
    [TestCase('Name - 22H2',     '10;0;19045;False;Windows 10 22H2', ';')]
    [TestCase('Name - 1607 cli', '10;0;14393;False;Windows 10 1607', ';')]
    [TestCase('Name - 2016 srv', '10;0;14393;True;Windows Server 2016', ';')]
    [TestCase('Name - 2019 srv', '10;0;17763;True;Windows Server 2019', ';')]
    [TestCase('Name - 2022 srv', '10;0;20348;True;Windows Server 2022', ';')]
    [TestCase('Name - 20348 cli','10;0;20348;False;Windows 10 21H2', ';')]
    [TestCase('Name - 24H2',     '10;0;26100;False;Windows 11 24H2', ';')]
    [TestCase('Name - 26H2',     '10;0;26300;False;Windows 11 26H2', ';')]
    [TestCase('Name - 2025 srv', '10;0;26052;True;Windows Server 2025', ';')]
    [TestCase('Name - fb high',  '10;0;99999;False;Windows 11 (10.0.99999)', ';')]
    [TestCase('Name - fb low',   '10;0;12345;False;Windows 10 (10.0.12345)', ';')]
    [TestCase('Name - Win7',     '6;1;7601;False;Windows 7 SP1', ';')]
    [TestCase('Name - Srv2008R2','6;1;7601;True;Windows Server 2008 R2 with Service Pack 1', ';')]
    [TestCase('Name - Win8',     '6;2;9200;False;Windows 8', ';')]
    [TestCase('Name - Win81 up', '6;3;9600;False;Windows 8.1 Update 1', ';')]
    [TestCase('Name - XP',       '5;1;2600;False;Windows XP', ';')]
    procedure WindowsNaming(const AMajor, AMinor, ABuild: Integer; const AServer: Boolean;
      const AExpectedName: string);

    // Home-edition detection via the VER_SUITE_PERSONAL (512) suite bit.
    [Test]
    [TestCase('Home - none',     '0;False', ';')]
    [TestCase('Home - personal', '512;True', ';')]
    [TestCase('Home - personal+','514;True', ';')]
    [TestCase('Home - ent only', '2;False', ';')]
    procedure HomeEditionDetection(const ASuiteMask: Integer; const AExpectedHome: Boolean);

    // End-of-support date lookup + the pure date comparison.
    [Test]
    [TestCase('EOS - before',       '19045;False;20250101;False', ';')]
    [TestCase('EOS - after',        '19045;False;20251231;True', ';')]
    [TestCase('EOS - on date',      '19045;False;20251014;False', ';')]
    [TestCase('EOS - unknown TBA',  '26200;False;20991231;False', ';')]
    [TestCase('EOS - consumer end', '26100;False;20270101;True', ';')]
    [TestCase('EOS - ext still ok', '26100;True;20270101;False', ';')]
    [TestCase('EOS - ext ended',    '26100;True;20280101;True', ';')]
    [TestCase('EOS - not in table', '99999;False;20991231;False', ';')]
    procedure SupportEndedCheck(const ABuild: Integer; const AExtended: Boolean;
      const ATodayYmd: Integer; const AExpectedEnded: Boolean);
  end;

implementation

procedure TInnoSetupWindowsVersion.IsWindowsVersionOlder(const AMajor, AMinor, ABuild: Integer;
  const AExcpectedResult: Boolean);
var
  LCompareMethod: TVersionCompareMethod;
  LResult: Boolean;
begin
  SetOsVersionToWin7;

  LCompareMethod := vcmOlder;

  LResult := IsWindowsVersion(AMajor, AMinor, ABuild, LCompareMethod);
  Assert.AreEqual(AExcpectedResult, LResult);
end;

procedure TInnoSetupWindowsVersion.IsWindowsVersionOlderOrEqual(const AMajor, AMinor, ABuild: Integer;
  const AExcpectedResult: Boolean);
var
  LCompareMethod: TVersionCompareMethod;
  LResult: Boolean;
begin
  SetOsVersionToWin7;

  LCompareMethod := vcmOlderOrEqual;

  LResult := IsWindowsVersion(AMajor, AMinor, ABuild, LCompareMethod);
  Assert.AreEqual(AExcpectedResult, LResult);
end;

procedure TInnoSetupWindowsVersion.IsWindowsVersionNewerOrEqual(const AMajor, AMinor, ABuild: Integer;
  const AExcpectedResult: Boolean);
var
  LCompareMethod: TVersionCompareMethod;
  LResult: Boolean;
begin
  SetOsVersionToWin7;

  LCompareMethod := vcmNewerOrEqual;

  LResult := IsWindowsVersion(AMajor, AMinor, ABuild, LCompareMethod);
  Assert.AreEqual(AExcpectedResult, LResult);
end;

procedure TInnoSetupWindowsVersion.CompareWindowsVersions(const AMajor1, AMinor1, ABuild1, AMajor2, AMinor2,
  ABuild2: Integer; const ACompareMethod: TVersionCompareMethod; const AExcpectedResult: Boolean);
begin
  SetOSVersion(AMajor1, AMinor1, ABuild1, VER_NT_WORKSTATION);

  var LResult := IsWindowsVersion(AMajor2, AMinor2, ABuild2, ACompareMethod);
  Assert.AreEqual(AExcpectedResult, LResult);
end;

procedure TInnoSetupWindowsVersion.CompareVersionsFromStrings(const AVersion, AVersionComparedTo: string;
  const ACompareMethod: TVersionCompareMethod; const AExcpectedResult: Boolean);
begin
  var LResult := CompareVersionsStr(AVersion, AVersionComparedTo, ACompareMethod);
  Assert.AreEqual(AExcpectedResult, LResult);
end;

procedure TInnoSetupWindowsVersion.TearDown;
begin
  ClearFakeWindowsVersion;
end;

procedure TInnoSetupWindowsVersion.WindowsNaming(const AMajor, AMinor, ABuild: Integer; const AServer: Boolean;
  const AExpectedName: string);
begin
  SetFakeWindowsVersion(AMajor, AMinor, ABuild, AServer);
  Assert.AreEqual(AExpectedName, WindowsVersionStr);
end;

procedure TInnoSetupWindowsVersion.HomeEditionDetection(const ASuiteMask: Integer; const AExpectedHome: Boolean);
begin
  SetFakeWindowsVersion(10, 0, 19045, False);
  SetFakeWindowsSuiteMask(ASuiteMask);
  Assert.AreEqual(AExpectedHome, IsWindowsHomeEdition);
end;

procedure TInnoSetupWindowsVersion.SupportEndedCheck(const ABuild: Integer; const AExtended: Boolean;
  const ATodayYmd: Integer; const AExpectedEnded: Boolean);
begin
  var LEos := GetWindowsEndOfSupport(ABuild, AExtended);
  Assert.AreEqual(AExpectedEnded, IsSupportEnded(LEos, ATodayYmd));
end;

procedure TInnoSetupWindowsVersion.IsWindowsVersionNewer(const AMajor, AMinor, ABuild: Integer;
  const AExcpectedResult: Boolean);
var
  LCompareMethod: TVersionCompareMethod;
  LResult: Boolean;
begin
  SetOsVersionToWin7;

  LCompareMethod := vcmNewer;

  LResult := IsWindowsVersion(AMajor, AMinor, ABuild, LCompareMethod);
  Assert.AreEqual(AExcpectedResult, LResult);
end;


initialization
  TDUnitX.RegisterTestFixture(TInnoSetupWindowsVersion);

end.
