unit Innosetup.WindowsVersion.DUnitX;

interface

uses
  DUnitX.TestFramework, TestUnit.Windows.Version;

type
  [TestFixture]
  TInnoSetupWindowsVersion = class
  public
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

    [Test]
    [TestCase('Compare versions - 01', '5;1;0;10;0;19043;vcmOlder;True', ';')]
    //
    [TestCase('Compare versions - 02', '10;0;19043;10;0;19043;vcmOlder;False', ';')]
    [TestCase('Compare versions - 03', '10;0;19043;10;0;19043;vcmOlderOrEqual;True', ';')]
    [TestCase('Compare versions - 03', '10;0;19043;10;0;19043;vcmEqual;True', ';')]
    [TestCase('Compare versions - 04', '10;0;19043;10;0;19043;vcmNewerOrEqual;True', ';')]
    [TestCase('Compare versions - 05', '10;0;19043;10;0;19043;vcmNewer;False', ';')]
    // Same version
    [TestCase('Compare versions - 06', '10;0;19043;10;0;19042;vcmOlder;False', ';')]
    [TestCase('Compare versions - 07', '10;0;19043;10;0;19042;vcmOlderOrEqual;False', ';')]
    [TestCase('Compare versions - 08', '10;0;19043;10;0;19042;vcmEqual;False', ';')]
    [TestCase('Compare versions - 09', '10;0;19043;10;0;19042;vcmNewerOrEqual;True', ';')]
    [TestCase('Compare versions - 10', '10;0;19043;10;0;19042;vcmNewer;True', ';')]
    // Smaller build compared to Larger build
    [TestCase('Compare versions - 11', '10;0;19043;10;0;19044;vcmOlder;True', ';')]
    [TestCase('Compare versions - 12', '10;0;19043;10;0;19044;vcmOlderOrEqual;True', ';')]
    [TestCase('Compare versions - 13', '10;0;19043;10;0;19044;vcmEqual;False', ';')]
    [TestCase('Compare versions - 14', '10;0;19043;10;0;19044;vcmNewerOrEqual;False', ';')]
    [TestCase('Compare versions - 15', '10;0;19043;10;0;19044;vcmNewer;False', ';')]
    // Smaller Minor compared to Larger Minor
    [TestCase('Compare versions - 16', '10;0;19043;10;1;19043;vcmOlder;True', ';')]
    [TestCase('Compare versions - 17', '10;0;19043;10;1;19043;vcmOlderOrEqual;True', ';')]
    [TestCase('Compare versions - 18', '10;0;19043;10;1;19043;vcmEqual;True', ';')]
    [TestCase('Compare versions - 19', '10;0;19043;10;1;19043;vcmNewerOrEqual;False', ';')]
    [TestCase('Compare versions - 20', '10;0;19043;10;1;19043;vcmNewer;False', ';')]
    // Smaller Major compared to Larger Major
    [TestCase('Compare versions - 21', '10;0;19043;11;0;19043;vcmOlder;True', ';')]
    [TestCase('Compare versions - 22', '10;0;19043;11;0;19043;vcmOlderOrEqual;True', ';')]
    [TestCase('Compare versions - 23', '10;0;19043;11;0;19043;vcmEqual;False', ';')]
    [TestCase('Compare versions - 24', '10;0;19043;11;0;19043;vcmNewerOrEqual;False', ';')]
    [TestCase('Compare versions - 25', '10;0;19043;11;0;19043;vcmNewer;False', ';')]
    // Larger build compared to Smaller build
    [TestCase('Compare versions - 26', '10;2;19044;10;2;19042;vcmOlder;False', ';')]
    [TestCase('Compare versions - 27', '10;2;19044;10;2;19042;vcmOlderOrEqual;False', ';')]
    [TestCase('Compare versions - 28', '10;2;19044;10;2;19042;vcmEqual;False', ';')]
    [TestCase('Compare versions - 29', '10;2;19044;10;2;19042;vcmNewerOrEqual;True', ';')]
    [TestCase('Compare versions - 30', '10;2;19044;10;2;19042;vcmNewer;True', ';')]
    // Larger Minor compared to Smaller Minor
    [TestCase('Compare versions - 31', '10;3;19043;10;2;19042;vcmOlder;False', ';')]
    [TestCase('Compare versions - 32', '10;3;19043;10;2;19042;vcmOlderOrEqual;False', ';')]
    [TestCase('Compare versions - 33', '10;3;19043;10;2;19042;vcmEqual;False', ';')]
    [TestCase('Compare versions - 34', '10;3;19043;10;2;19042;vcmNewerOrEqual;True', ';')]
    [TestCase('Compare versions - 45', '10;3;19043;10;2;19042;vcmNewer;True', ';')]
    // Larger Major compared to Smaller Major
    [TestCase('Compare versions - 46', '11;3;19043;10;2;19042;vcmOlder;False', ';')]
    [TestCase('Compare versions - 47', '11;3;19043;10;2;19042;vcmOlderOrEqual;False', ';')]
    [TestCase('Compare versions - 48', '11;3;19043;10;2;19042;vcmEqual;False', ';')]
    [TestCase('Compare versions - 49', '11;3;19043;10;2;19042;vcmNewerOrEqual;True', ';')]
    [TestCase('Compare versions - 50', '11;3;19043;10;2;19042;vcmNewer;True', ';')]

    procedure CompareWindowsVersions(const AMajor1, AMinor1, ABuild1, AMajor2, AMinor2, ABuild2: Integer;
      const ACompareMethod: TVersionCompareMethod; const AExcpectedResult: Boolean);
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
