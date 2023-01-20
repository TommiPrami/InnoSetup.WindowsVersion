unit Innosetup.WindowsVersion.DUnitX;

interface

uses
  DUnitX.TestFramework, TestUnit.Windows.Version;

type
  [TestFixture]
  TInnoSetupWindowsVersion = class
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    [Test]
    [TestCase('IsWindowsVersion - Older - 01', '5;1;0;False', ';')]
    [TestCase('IsWindowsVersion - Older - 02', '5;1;7000;False', ';')]
    [TestCase('IsWindowsVersion - Older - 03', '5;1;7800;False', ';')]
    [TestCase('IsWindowsVersion - Older - 04', '5;3;0;False', ';')]
    [TestCase('IsWindowsVersion - Older - 05', '5;3;7000;False', ';')]
    [TestCase('IsWindowsVersion - Older - 06', '5;3;7800;False', ';')]
    [TestCase('IsWindowsVersion - Older - 07', '6;0;0;False', ';')]
    [TestCase('IsWindowsVersion - Older - 08', '6;1;1000;False', ';')]
    [TestCase('IsWindowsVersion - Older - 09', '6;1;7600;False', ';')] // Win7 <-> Win7
    [TestCase('IsWindowsVersion - Older - 10', '6;1;7800;True', ';')]
    [TestCase('IsWindowsVersion - Older - 11', '6;2;0;True', ';')]
    [TestCase('IsWindowsVersion - Older - 12', '6;2;7000;True', ';')]
    [TestCase('IsWindowsVersion - Older - 13', '6;2;7600;True', ';')]
    [TestCase('IsWindowsVersion - Older - 14', '6;2;7800;True', ';')]
    [TestCase('IsWindowsVersion - Older - 15', '6;2;8800;True', ';')]
    [TestCase('IsWindowsVersion - Older - 16', '7;3;8800;True', ';')]
    [TestCase('IsWindowsVersion - Older - 17', '7;3;8800;True', ';')]
    [TestCase('IsWindowsVersion - Older - 18', '10;0;10240;True', ';')] // Win10 1507
    procedure IsWindowsVersionOlder(const AMajor, AMinor, ABuild: Integer; const AExcpectedResult: Boolean);

    [Test]
    [TestCase('IsWindowsVersion - OlderOrEqual - 01', '5;1;0;False', ';')]
    [TestCase('IsWindowsVersion - OlderOrEqual - 02', '5;1;7000;False', ';')]
    [TestCase('IsWindowsVersion - OlderOrEqual - 03', '5;1;7800;False', ';')]
    [TestCase('IsWindowsVersion - OlderOrEqual - 04', '5;3;0;False', ';')]
    [TestCase('IsWindowsVersion - OlderOrEqual - 05', '5;3;7000;False', ';')]
    [TestCase('IsWindowsVersion - OlderOrEqual - 06', '5;3;7800;False', ';')]
    [TestCase('IsWindowsVersion - OlderOrEqual - 07', '6;0;0;False', ';')]
    [TestCase('IsWindowsVersion - OlderOrEqual - 08', '6;1;1000;False', ';')]
    [TestCase('IsWindowsVersion - OlderOrEqual - 09', '6;1;7600;True', ';')] // Win7 <-> Win7
    [TestCase('IsWindowsVersion - OlderOrEqual - 10', '6;1;7800;True', ';')]
    [TestCase('IsWindowsVersion - OlderOrEqual - 11', '6;2;0;True', ';')]
    [TestCase('IsWindowsVersion - OlderOrEqual - 12', '6;2;7000;True', ';')]
    [TestCase('IsWindowsVersion - OlderOrEqual - 13', '6;2;7600;True', ';')]
    [TestCase('IsWindowsVersion - OlderOrEqual - 14', '6;2;7800;True', ';')]
    [TestCase('IsWindowsVersion - OlderOrEqual - 15', '6;2;8800;True', ';')]
    [TestCase('IsWindowsVersion - OlderOrEqual - 16', '7;3;8800;True', ';')]
    [TestCase('IsWindowsVersion - OlderOrEqual - 17', '7;3;8800;True', ';')]
    [TestCase('IsWindowsVersion - OlderOrEqual - 18', '10;0;10240;True', ';')] // Win10 1507
    procedure IsWindowsVersionOlderOrEqual(const AMajor, AMinor, ABuild: Integer; const AExcpectedResult: Boolean);

    [TestCase('IsWindowsVersion - NewerOrEqual - 01', '5;1;0;True', ';')]
    [TestCase('IsWindowsVersion - NewerOrEqual - 02', '5;1;7000;True', ';')]
    [TestCase('IsWindowsVersion - NewerOrEqual - 03', '5;1;7800;True', ';')]
    [TestCase('IsWindowsVersion - NewerOrEqual - 04', '5;3;0;True', ';')]
    [TestCase('IsWindowsVersion - NewerOrEqual - 05', '5;3;7000;True', ';')]
    [TestCase('IsWindowsVersion - NewerOrEqual - 06', '5;3;7800;True', ';')]
    [TestCase('IsWindowsVersion - NewerOrEqual - 07', '6;0;0;True', ';')]
    [TestCase('IsWindowsVersion - NewerOrEqual - 08', '6;1;1000;True', ';')]
    [TestCase('IsWindowsVersion - NewerOrEqual - 09', '6;1;7600;True', ';')] // Win7 <-> Win7
    [TestCase('IsWindowsVersion - NewerOrEqual - 10', '6;1;7800;False', ';')]
    [TestCase('IsWindowsVersion - NewerOrEqual - 11', '6;2;0;False', ';')]
    [TestCase('IsWindowsVersion - NewerOrEqual - 12', '6;2;7000;False', ';')]
    [TestCase('IsWindowsVersion - NewerOrEqual - 13', '6;2;7600;False', ';')]
    [TestCase('IsWindowsVersion - NewerOrEqual - 14', '6;2;7800;False', ';')]
    [TestCase('IsWindowsVersion - NewerOrEqual - 15', '6;2;8800;False', ';')]
    [TestCase('IsWindowsVersion - NewerOrEqual - 16', '7;3;8800;False', ';')]
    [TestCase('IsWindowsVersion - NewerOrEqual - 17', '7;3;8800;False', ';')]
    [TestCase('IsWindowsVersion - NewerOrEqual - 18', '10;0;10240;False', ';')] // Win10 1507
    procedure IsWindowsVersionNewerOrEqual(const AMajor, AMinor, ABuild: Integer; const AExcpectedResult: Boolean);

    [TestCase('IsWindowsVersion - Newer - 01', '5;1;0;True', ';')]
    [TestCase('IsWindowsVersion - Newer - 02', '5;1;7000;True', ';')]
    [TestCase('IsWindowsVersion - Newer - 03', '5;1;7800;True', ';')]
    [TestCase('IsWindowsVersion - Newer - 04', '5;3;0;True', ';')]
    [TestCase('IsWindowsVersion - Newer - 05', '5;3;7000;True', ';')]
    [TestCase('IsWindowsVersion - Newer - 06', '5;3;7800;True', ';')]
    [TestCase('IsWindowsVersion - Newer - 07', '6;0;0;True', ';')]
    [TestCase('IsWindowsVersion - Newer - 08', '6;1;1000;True', ';')]
    [TestCase('IsWindowsVersion - Newer - 09', '6;1;7600;False', ';')] // Win7 <-> Win7
    [TestCase('IsWindowsVersion - Newer - 10', '6;1;7800;False', ';')]
    [TestCase('IsWindowsVersion - Newer - 11', '6;2;0;False', ';')]
    [TestCase('IsWindowsVersion - Newer - 12', '6;2;7000;False', ';')]
    [TestCase('IsWindowsVersion - Newer - 13', '6;2;7600;False', ';')]
    [TestCase('IsWindowsVersion - Newer - 14', '6;2;7800;False', ';')]
    [TestCase('IsWindowsVersion - Newer - 15', '6;2;8800;False', ';')]
    [TestCase('IsWindowsVersion - Newer - 16', '7;3;8800;False', ';')]
    [TestCase('IsWindowsVersion - Newer - 17', '7;3;8800;False', ';')]
    [TestCase('IsWindowsVersion - Newer - 18', '10;0;10240;False', ';')] // Win10 1507
    procedure IsWindowsVersionNewer(const AMajor, AMinor, ABuild: Integer; const AExcpectedResult: Boolean);
  end;

implementation

procedure TInnoSetupWindowsVersion.Setup;
begin

end;

procedure TInnoSetupWindowsVersion.TearDown;
begin

end;


procedure TInnoSetupWindowsVersion.IsWindowsVersionOlder(const AMajor, AMinor, ABuild: Integer;
  const AExcpectedResult: Boolean);
var
  LCompareMethod: TOsCompareMethod;
  LResult: Boolean;
begin
  SetOsVersionToWin7;

  LCompareMethod := ocmOlder;

  LResult := IsWindowsVersion(AMajor, AMinor, ABuild, LCompareMethod);
  Assert.AreEqual(AExcpectedResult, LResult);
end;

procedure TInnoSetupWindowsVersion.IsWindowsVersionOlderOrEqual(const AMajor, AMinor, ABuild: Integer;
  const AExcpectedResult: Boolean);
var
  LCompareMethod: TOsCompareMethod;
  LResult: Boolean;
begin
  SetOsVersionToWin7;

  LCompareMethod := ocmOlderOrEqual;

  LResult := IsWindowsVersion(AMajor, AMinor, ABuild, LCompareMethod);
  Assert.AreEqual(AExcpectedResult, LResult);
end;

procedure TInnoSetupWindowsVersion.IsWindowsVersionNewerOrEqual(const AMajor, AMinor, ABuild: Integer;
  const AExcpectedResult: Boolean);
var
  LCompareMethod: TOsCompareMethod;
  LResult: Boolean;
begin
  SetOsVersionToWin7;

  LCompareMethod := ocmNewerOrEqual;

  LResult := IsWindowsVersion(AMajor, AMinor, ABuild, LCompareMethod);
  Assert.AreEqual(AExcpectedResult, LResult);
end;

procedure TInnoSetupWindowsVersion.IsWindowsVersionNewer(const AMajor, AMinor, ABuild: Integer;
  const AExcpectedResult: Boolean);
var
  LCompareMethod: TOsCompareMethod;
  LResult: Boolean;
begin
  SetOsVersionToWin7;

  LCompareMethod := ocmNewer;

  LResult := IsWindowsVersion(AMajor, AMinor, ABuild, LCompareMethod);
  Assert.AreEqual(AExcpectedResult, LResult);
end;


initialization
  TDUnitX.RegisterTestFixture(TInnoSetupWindowsVersion);

end.
