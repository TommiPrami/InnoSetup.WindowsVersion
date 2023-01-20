unit Innosetup.WindowsVersion.DUnitX;

interface

uses
  DUnitX.TestFramework, TestUnit.Windows.Version;

type
  [TestFixture]
  TInnoSetupWindowsVersion = class
  strict private
    procedure SetOSVersion(const AMajor, AMinor, ABuild: Integer; const AProductType: Integer = 1);
    procedure SetOsVersionToWin7;
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
    procedure IsWindowsVersionOlderOrEqual(const AMajor, AMinor, ABuild: Integer; const AExcpectedResult: Boolean);
  end;

implementation

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

procedure TInnoSetupWindowsVersion.SetOSVersion(const AMajor, AMinor, ABuild: Integer; const AProductType: Integer = 1);
begin
  GOSVersion := TWindowsVersion.Create(AMajor, AMinor, ABuild, AProductType);
end;

procedure TInnoSetupWindowsVersion.SetOsVersionToWin7;
begin
  SetOSVersion(6, 1, 7600, VER_NT_WORKSTATION);
end;

procedure TInnoSetupWindowsVersion.Setup;
begin

end;

procedure TInnoSetupWindowsVersion.TearDown;
begin

end;

procedure TInnoSetupWindowsVersion.IsWindowsVersionOlder(const AMajor, AMinor, ABuild: Integer; const AExcpectedResult: Boolean);
var
  LCompareMethod: TOsCompareMethod;
  LResult: Boolean;
begin
  SetOsVersionToWin7;

  LCompareMethod := ocmOlder;

  LResult := IsWindowsVersion(AMajor, AMinor, ABuild, LCompareMethod);
  Assert.AreEqual(AExcpectedResult, LResult);
end;

initialization
  TDUnitX.RegisterTestFixture(TInnoSetupWindowsVersion);

end.
