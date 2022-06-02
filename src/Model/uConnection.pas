unit uConnection; // classe que gera uma conexao singleton

interface

uses
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Error,
  FireDAC.UI.Intf,
  FireDAC.Phys.Intf,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.Phys,
  FireDAC.Phys.FB,
  FireDAC.Phys.FBDef,
  FireDAC.VCLUI.Wait,
  Data.DB,
  FireDAC.Comp.Client,
  Vcl.Dialogs,
  Vcl.Forms,
  IBX.IBDatabase,
  system.Classes,
  system.SysUtils;

Type

  TConnection = class(TInterfacedObject)
  private

    FConexao: TFDConnection;
    FConexaoDFe: TFDConnection;

    function ReturnPathDataBase: string;
    function Directory: string;

    class var FObjectConnection: TConnection;
    class function GetObjectConnection: TConnection; static;

  public
    constructor Create;
    destructor Destroy; override;
    function Connection: TFDConnection;
    function verconexao: boolean;

    class procedure ReleaseMe;
    class function NewCommit: boolean;
    class property ObjectConnection: TConnection read GetObjectConnection write FObjectConnection;

  end;

implementation

{ TConnection }


function TConnection.Connection: TFDConnection;
begin
  Result := FConexao;
end;

constructor TConnection.Create;
begin

  FConexao := TFDConnection.Create(nil);
  FConexao.params.Database := ReturnPathDataBase;
  FConexao.params.DriverID := 'FB';
  FConexao.params.UserName := 'SYSDBA';
  FConexao.params.Password := 'masterkey';
  FConexao.ConnectionName := 'API';
  FConexao.Connected := true;

  // showmessage('DataBase is connected!.');
end;

destructor TConnection.Destroy;
begin
  FreeAndNil(FConexao);
  FreeAndNil(FConexaoDFe);
  inherited;
end;

function TConnection.ReturnPathDataBase: string;
var
  lFile: TextFile;
  lHost: string;
  lLocal: string;
  lPath, lTipo: string;
  lFile_INI: string;

begin

  lFile_INI := Directory + 'config.ini';

  if FileExists(lFile_INI) then
  begin
    AssignFile(lFile, lFile_INI);
    Reset(lFile);
    Readln(lFile, lHost);
    Readln(lFile, lLocal);
    Readln(lFile, lTipo);
    lHost := trim(Copy(lHost, 6, 100));
    lLocal := trim(Copy(lLocal, 7, 150));
    lTipo := trim(Copy(lTipo, 6, 15));

    CloseFile(lFile);
    lPath := lHost + ':' + lLocal;
    Result := lPath;
  end;
end;

function TConnection.verconexao: boolean;
begin
  Connection;
end;

function TConnection.Directory: string;
var
  cDir: string;
begin
  cDir := ExtractFilePath(Application.exeName);
  if Copy(cDir, Length(cDir), 1) <> '\' then
    cDir := cDir + '\';
  Result := cDir;
end;

class function TConnection.GetObjectConnection: TConnection;
begin
  if NOT Assigned(FObjectConnection) then
  begin
    FObjectConnection := TConnection.Create;
  end;

  Result := FObjectConnection;
end;

class function TConnection.NewCommit: boolean;
begin

end;

class procedure TConnection.ReleaseMe;
begin
  if Assigned(FObjectConnection) then
  begin
    FreeAndNil(FObjectConnection);
  end;
end;

initialization

finalization

TConnection.ReleaseMe;

end.
