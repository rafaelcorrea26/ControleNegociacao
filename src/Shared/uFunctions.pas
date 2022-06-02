unit uFunctions; // classe geral de funções

interface

uses
  System.SysUtils,
  Winapi.Windows,
  Vcl.Forms,
  uQuery,
  uConnection,
  System.Win.Registry,
  Vcl.Dialogs,
  System.Classes,
  System.NetEncoding,
  System.DateUtils,
  System.StrUtils,
  System.IniFiles, Vcl.StdCtrls;

type
  TFunctions = class;

  TFunctions = class
  private
    class procedure AtualizaComoEnviadaTabelaAuxCP(pTitle: string; pLastDateAtt: TDateTime); static;
    class procedure AtualizaComoEnviadaTabelaAuxCR(pDuplicata: string; pLastDateAtt: TDateTime); static;
    class function AtualizaContaPagarComoEnviado(pTitulo: string; pLastDateAtt: TDateTime): Boolean; static;
    class function AtualizaContaReceberComoEnviado(pDuplicata: string; pLastDateAtt: TDateTime): Boolean; static;
    class function AtualizaCPParaReenvio(pTitle: string): Boolean; static;
    class function AtualizaCRParaReenvio(pDuplicata: String): Boolean; static;
    class procedure AtualizaDataUltimaConexaoCP(pDateTime: TDateTime); static;
    class procedure AtualizaDataUltimaConexaoCR(pDateTime: TDateTime); static;
    class function AtualizaDuplicataEmpresaCR(pDuplicata: string): Boolean; static;
    class function AtualizaTituloEmpresaCP(pTitulo: string): Boolean; static;
    class function GravaCodigoEChaveEmpresa(pCNPJ, pCodigoEmpresa, pChave: string): Boolean; static;
    class function RetornaChaveEmpresa(pCodigoEmp: string): string; static;
    class function RetornaChaveEmpresaDuplicata(pDuplicata: String): string; static;
    class function RetornaChaveEmpresaTitulo(pTitulo: String): string; static;
    class function RetornaChavePelaConfig2000: String; static;
    class function RetornaCodigoEmpresa: string; static;
    class function RetornaNomeEmpresa: string; static;
    class function RetornaUltimoSincCP: TDateTime; static;
    class function RetornaUltimoSincCR: TDateTime; static;
    class function ValidaCodigoEChaveEmpresa: Boolean; static;

  public
    destructor Destroy; override;
    constructor Create;

    class function VersaoSistema: string;

    // Func Decodificar Datas
    class function DecodeDateHour: string;
    class function DecodeDateHourJson(pDate: TDateTime): string;
    class function DecodeDateJson(pDate: TDateTime): string;
    class function DecodeStrDateForJson(pDate: string): string;
    class function DecodeStringToDate(pDate: string): TDateTime;

    // func gerais
    class procedure CreateFileTxtLog(pJson, pNameTXT: string);
    class procedure RegisterAppOnWindows(pProgram: string);

    class function DateServer: TDateTime;
    class function IsDigit(pString: string): Boolean;

    class function LengthString(pString: string; pLength: Integer): string;
    class function ReturnAutorizationBase64String(pPassword: String): string;
    class function FormatDateToString(pData: TDateTime): string;
    class function TriggerValidation(pNameTrigger: string): Boolean;

    class function RemoveCharac(aText: string; aOld: String = ''; aNew: String = '';
      aRemoveTrim: Boolean = false): string;

    class function CheckItsOkConfigAPI: Boolean;
    class function ThereWasMovementInTheAPIConnection: Boolean;
    class function GetSN(pBoolean: Boolean): string;
    class function readJson(pType: string = 'cr'): String;
    class function writeJson(pType: string = 'cr'; pJson: String = ''): Boolean;
    class function ColumnExists(pColumn, pJson: string): Boolean;
    class function ObjectIsNull(pObject, pJson: string): Boolean;
    class function RemoveCaracteres(aTexto: string): string;
    class procedure CarryCbx(pTabela, pFieldAdicionadoCombo: string;
  pComboBox: TcomboBox);

   class function GenerateNextCode(pTabela, pCodigo: string): integer;


  end;

implementation

class procedure TFunctions.CreateFileTxtLog(pJson, pNameTXT: string);
var
  FBackupTxt: TStringList;
  lPublicAppDirectory, lFileNameTxt, lFullPathFile: string;
begin
  FBackupTxt := TStringList.Create;
  try
    FBackupTxt.Text := pJson;
    lPublicAppDirectory := ExtractFilePath(application.exeName) + 'Log_Erros\';
    lFileNameTxt := pNameTXT + '_' + DecodeDateHour + '.txt';
    lFullPathFile := lPublicAppDirectory + lFileNameTxt;

    if not DirectoryExists(lPublicAppDirectory) then
    begin
      ForceDirectories(lPublicAppDirectory);
    end;

    if DirectoryExists(lPublicAppDirectory) then
    begin
      FBackupTxt.SaveToFile(lFullPathFile);
    end;
  finally
    FBackupTxt.Free;
  end;
end;

class procedure TFunctions.RegisterAppOnWindows(pProgram: string);
var
  REG: TRegistry;
begin
  REG := TRegistry.Create;
  try
    REG.RootKey := HKEY_CURRENT_USER;
    REG.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run\', true);
    REG.WriteString(pProgram, ParamStr(0));
    REG.CloseKey;
    ShowMessage('Programa adicionado na inicialização do Windows com sucesso!');
  finally
    REG.Free;
  end;
end;

class function TFunctions.RemoveCaracteres(aTexto: string): string;
const
  // Lista de Caracteres Extras
  xCarExt: array [1 .. 55] of string = ('<', '>', '!', '@', '#', '$', '%', '¨', '&', '*', '(', ')', '_', '+', '=', '{',
    '}', '[', ']', '?', ';', ':', ',', '|', '*', '"', '~', '^', '´', '`', '¨', 'æ', 'Æ', 'ø', '£', 'Ø', 'ƒ', 'ª', 'º',
    '¿', '®', '½', '¼', 'ß', 'µ', 'þ', 'ý', 'Ý', '÷', '×', '€', '-', '\', '/', '.');
var
  xTexto: string;
  i: Integer;
begin
  xTexto := aTexto;

  for i := 1 to 55 do
  begin
    xTexto := StringReplace(xTexto, xCarExt[i], '', [rfReplaceAll]);
  end;

  result := xTexto;

end;

class function TFunctions.RemoveCharac(aText, aOld, aNew: String; aRemoveTrim: Boolean): string;
const
  xCarExt: array [1 .. 55] of string = ('<', '>', '!', '@', '#', '$', '%', '¨', '&', '*', '(', ')', '_', '+', '=', '{',
    '}', '[', ']', '?', ';', ':', ',', '|', '*', '"', '~', '^', '´', '`', '¨', 'æ', 'Æ', 'ø', '£', 'Ø', 'ƒ', 'ª', 'º',
    '¿', '®', '½', '¼', 'ß', 'µ', 'þ', 'ý', 'Ý', '÷', '×', '€', '-', '\', '/', '.');
var
  xTexto: string;
  i: Integer;
begin
  xTexto := aText;

  for i := 1 to 55 do
  begin
    xTexto := UpperCase(StringReplace(xTexto, UpperCase(xCarExt[i]), '', [rfReplaceAll]));
  end;

  if (aOld <> EmptyStr) and (aNew <> EmptyStr) then
  begin
    xTexto := UpperCase(StringReplace(xTexto, UpperCase(aOld), aNew, [rfReplaceAll]));
  end;

  if aRemoveTrim then
  begin
    xTexto := StringReplace(xTexto, ' ', '', [rfReplaceAll]);
  end;

  result := UpperCase(xTexto);

end;

class procedure TFunctions.CarryCbx(pTabela, pFieldAdicionadoCombo: string; pComboBox: TcomboBox);
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try
    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add('select distinct ' + pFieldAdicionadoCombo + ' from ' + pTabela);
    lQuery.Open;

    if lQuery.RecordCount > 0 then
    begin
      lQuery.First;
      pComboBox.Clear;

      while not(lQuery.Eof) do
      begin
        pComboBox.Items.Add(lQuery.fieldbyname(pFieldAdicionadoCombo).AsString);
        lQuery.Next;
      end;
    end;
    pComboBox.ItemIndex := 0;
  finally
    lQuery.Free;
  end;

end;


class function TFunctions.CheckItsOkConfigAPI: Boolean;
begin

end;

constructor TFunctions.Create;
begin
end;

class function TFunctions.FormatDateToString(pData: TDateTime): string;
var
  lData: string;
begin
  lData := FormatDateTime('mm/dd/yyyy', (pData));
  result := lData;

end;

class function TFunctions.GenerateNextCode(pTabela, pCodigo: string): integer;
var
  lQuery: TQuery;
begin
  Result := 0;
  lQuery := TQuery.Create(nil);
  try
    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add('SELECT MAX(' + pCodigo + ') + 1 PROXIMO_CODIGO FROM ' + pTabela + ' ;');
    lQuery.Open;

    if (lQuery.RecordCount > 0) then
    begin
      Result := lQuery.fieldbyname('PROXIMO_CODIGO').AsInteger;
    end;
  finally
    lQuery.Free;
  end;

end;

class function TFunctions.GetSN(pBoolean: Boolean): string;
begin
  result := IfThen(pBoolean, 'S', 'N');
end;

class function TFunctions.GravaCodigoEChaveEmpresa(pCNPJ, pCodigoEmpresa, pChave: string): Boolean;
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try
    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add(' UPDATE MC27PROP  SET           ');
    lQuery.SQL.Add('  AC27_CHAVE = :AC27_CHAVE      ');
    lQuery.SQL.Add(' ,AN27CODI_INT = :AN27CODI_INT  ');
    lQuery.SQL.Add(' WHERE AC27CNPJ = :AC27CNPJ     ');
    lQuery.ParamByName('AC27_CHAVE').AsSTRING := pChave;
    lQuery.ParamByName('AC27CNPJ').AsSTRING := pCNPJ;
    lQuery.ParamByName('AN27CODI_INT').AsSTRING := pCodigoEmpresa;
    lQuery.ExecSQL;
    lQuery.Connection.Commit;
  finally
    lQuery.Free;
  end;

end;

class function TFunctions.DateServer: TDateTime;
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try
    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add(' SELECT ');
    lQuery.SQL.Add('   CURRENT_TIMESTAMP ');
    lQuery.SQL.Add(' FROM RDB$DATABASE ');
    lQuery.Open;

    result := lQuery.FieldByName('CURRENT_TIMESTAMP').AsDateTime;
  finally
    lQuery.Free;
  end;

end;

class function TFunctions.DecodeDateHour: string;
var
  lYear, lMonth, lDay, lHour, lMin, lSec, lMilisec: Word;
begin
  // "2021-11-17 20:21:56"
  decodedatetime(now, lYear, lMonth, lDay, lHour, lMin, lSec, lMilisec);
  result := lYear.ToString + FormatFloat('00', lMonth) + FormatFloat('00', lDay) + FormatFloat('00', lHour) +
    FormatFloat('00', lMin) + FormatFloat('00', lSec);

end;

class function TFunctions.DecodeDateHourJson(pDate: TDateTime): string;
var
  lYear, lMonth, lDay, lHour, lMin, lSec, lMilisec: Word;
begin
  // "2021-11-17 20:21:56"
  decodedatetime(pDate, lYear, lMonth, lDay, lHour, lMin, lSec, lMilisec);
  result := lYear.ToString + '-' + FormatFloat('00', lMonth) + '-' + FormatFloat('00', lDay) + ' ' +
    FormatFloat('00', lHour) + ':' + FormatFloat('00', lMin) + ':' + FormatFloat('00', lSec);

end;

class function TFunctions.DecodeStrDateForJson(pDate: string): string;
var
  lYear, lMonth, lDay: Word;
  lData: TDate;
begin
  if trim(pDate) <> EmptyStr then
  begin
    lData := StrToDatedef(pDate, now);
    DecodeDate(lData, lYear, lMonth, lDay);
    result := lYear.ToString + '-' + FormatFloat('00', lMonth) + '-' + FormatFloat('00', lDay);
  end;

end;

class function TFunctions.DecodeDateJson(pDate: TDateTime): string;
var
  lYear, lMonth, lDay: Word;
begin
  DecodeDate(pDate, lYear, lMonth, lDay);
  result := lYear.ToString + '-' + FormatFloat('00', lMonth) + '-' + FormatFloat('00', lDay);

end;

class function TFunctions.DecodeStringToDate(pDate: string): TDateTime;
var
  lDate, lDay, lMonth, lYear, lTime: string;
begin
  // "date_expiration_access_token": "2021-03-04 18:26:01",
  // "date_expiration_refresh_token": "2021-04-03 15:26:01",
  // "date_activated": "2021-03-04 15:26:01",

  pDate := StringReplace(pDate, '-', '', [rfReplaceAll]);

  lDay := Copy(pDate, 7, 2);
  lMonth := Copy(pDate, 5, 2);
  lYear := Copy(pDate, 1, 4);
  lTime := Copy(pDate, 9, 9);
  lDate := lDay + '/' + lMonth + '/' + lYear + ' ' + lTime;
  result := StrToDateTimedef(lDate, now);

end;

destructor TFunctions.Destroy;
begin
  inherited;
end;

class function TFunctions.IsDigit(pString: string): Boolean;
begin
  result := true;
  Try
    strtoint(pString);
  Except
    result := false;
  end;
end;

class function TFunctions.LengthString(pString: string; pLength: Integer): string;
begin
  result := Copy(pString, 1, pLength);
end;

class function TFunctions.ObjectIsNull(pObject, pJson: string): Boolean;
var
  lObjeto: string;
begin
  lObjeto := '"' + pObject + '":{';
  result := not(Pos(trim(lObjeto), trim(pJson)) > 0);
end;

class function TFunctions.readJson(pType: string = 'cr'): String;
var
  lArquivoIni: TIniFile;
  lFullNameFile, lNameFile: string;
begin
  lNameFile := 'json.ini';
  lFullNameFile := ExtractFilePath(application.exeName) + lNameFile;

  if FileExists(lFullNameFile) then
  begin
    lArquivoIni := TIniFile.Create(lFullNameFile);

    try
      result := lArquivoIni.ReadString('json', pType, result);
    finally
      lArquivoIni.Free;
    end;
  end;
end;

class function TFunctions.ReturnAutorizationBase64String(pPassword: String): string;
var
  lTexto, lResult: string;
  Base64: TBase64Encoding;
begin

  try
    Base64 := TBase64Encoding.Create;
    lResult := Base64.decode(lTexto);
    lResult := Copy(lResult, 35, lResult.Length);

    result := lResult;
  except
    on E: Exception do
    begin
      result := pPassword;
    end;
  end;

end;

class function TFunctions.RetornaChaveEmpresa(pCodigoEmp: string): string;
var
  lQuery: TQuery;
begin

  if trim(pCodigoEmp) <> EmptyStr then
  begin
    lQuery := TQuery.Create(nil);
    try

      lQuery.Close;
      lQuery.SQL.Clear;
      lQuery.SQL.Add(' SELECT * FROM MC27PROP              ');
      lQuery.SQL.Add(' WHERE AN27CODI_INT = :AN27CODI_INT  ');
      lQuery.ParamByName('AN27CODI_INT').AsSTRING := pCodigoEmp;
      lQuery.Open;

      if (lQuery.recordcount) > 0 then
      begin
        result := lQuery.FieldByName('AC27_CHAVE').AsSTRING;
      end;

    finally
      lQuery.Free;
    end;
  end;

end;

class function TFunctions.RetornaChavePelaConfig2000: String;
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try
    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add(' SELECT * FROM MCCONFIG2000      ');
    lQuery.Open;
    result := lQuery.FieldByName('MC_CHAVE_REGISTRO').AsSTRING;
  finally
    lQuery.Free;
  end;

end;

class function TFunctions.RetornaCodigoEmpresa: string;
var
  lQuery: TQuery;
  lChave: string;
begin
  lQuery := TQuery.Create(nil);
  try
    result := EmptyStr;
    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add('  SELECT CHAVE_EMPRESA FROM TBL_CONFIGURACAO_FIN  ');
    lQuery.Open;
    lQuery.FetchAll;

    if lQuery.recordcount > 0 then
    begin
      lChave := lQuery.FieldByName('CHAVE_EMPRESA').AsSTRING;
      lQuery.Close;
      lQuery.SQL.Clear;
      lQuery.SQL.Add('  SELECT AN27CODI_INT FROM MC27PROP    ');
      lQuery.SQL.Add('  where   AC27_CHAVE = :AC27_CHAVE     ');
      lQuery.ParamByName('AC27_CHAVE').AsSTRING := lChave;
      lQuery.Open;
      lQuery.FetchAll;

      result := lQuery.FieldByName('AN27CODI_INT').AsSTRING;
    end;
  finally
    lQuery.Free;
  end;
end;

class function TFunctions.RetornaChaveEmpresaDuplicata(pDuplicata: String): string;
var
  lQuery: TQuery;
  lChave: string;
  lNovaChave: string;
begin
  lQuery := TQuery.Create(nil);

  try
    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add(' SELECT CHAVE_EMPRESA from TBL_CONFIGURACAO_FIN ');
    lQuery.SQL.Add(' where ID = 1                                   ');
    lQuery.Open;
    lChave := lQuery.FieldByName('CHAVE_EMPRESA').AsSTRING;

    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add(' SELECT AC09DUP from MC09CREC ');
    lQuery.SQL.Add(' where AC09DUP = :AC09DUP     ');
    lQuery.ParamByName('AC09DUP').AsSTRING := pDuplicata;
    lQuery.Open;

    if lQuery.recordcount > 0 then
    begin
      if (Copy(lQuery.FieldByName('AC09DUP').AsSTRING, 1, 3) = 'INT') then
      begin
        lNovaChave := RetornaChaveEmpresa(Copy(lQuery.FieldByName('AC09DUP').AsSTRING, 4, 1));
      end
    end;

    if trim(lNovaChave) <> EmptyStr then
    begin
      lChave := lNovaChave;
    end;

    result := lChave;
  finally
    lQuery.Free;
  end;

end;

class function TFunctions.RetornaChaveEmpresaTitulo(pTitulo: String): string;
var
  lQuery: TQuery;
  lChave, lNovaChave: string;
begin
  lQuery := TQuery.Create(nil);

  try
    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add(' SELECT CHAVE_EMPRESA from TBL_CONFIGURACAO_FIN ');
    lQuery.SQL.Add(' where ID = 1                                   ');
    lQuery.Open;
    lChave := lQuery.FieldByName('CHAVE_EMPRESA').AsSTRING;

    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add(' SELECT AC08TIT from mc08cpag ');
    lQuery.SQL.Add(' where AC08TIT = :AC08TIT     ');
    lQuery.ParamByName('AC08TIT').AsSTRING := pTitulo;
    lQuery.Open;

    if lQuery.recordcount > 0 then
    begin
      if (Copy(lQuery.FieldByName('AC08TIT').AsSTRING, 1, 3) = 'INT') then
      begin
        lNovaChave := RetornaChaveEmpresa(Copy(lQuery.FieldByName('AC08TIT').AsSTRING, 4, 1));
      end
    end;

    if trim(lNovaChave) <> EmptyStr then
    begin
      lChave := lNovaChave;
    end;

    result := lChave;
  finally
    lQuery.Free;
  end;
end;

class function TFunctions.RetornaNomeEmpresa: string;
var
  lQuery: TQuery;
  lCodigo: string;
begin

  lCodigo := RetornaCodigoEmpresa;

  if trim(lCodigo) <> EmptyStr then
  begin
    lQuery := TQuery.Create(nil);
    try
      lQuery.Close;
      lQuery.SQL.Clear;
      lQuery.SQL.Add(' SELECT * FROM MC27PROP      ');
      lQuery.SQL.Add(' WHERE AN27CODI_INT = :AN27CODI_INT  ');
      lQuery.ParamByName('AN27CODI_INT').AsSTRING := lCodigo;
      lQuery.Open;

      result := 'Empresa: ' + lQuery.FieldByName('AN27CODI').AsSTRING + ' - ' + lQuery.FieldByName('AC27NOME').AsSTRING;
    finally
      lQuery.Free;
    end;
  end;
end;

class function TFunctions.RetornaUltimoSincCP: TDateTime;
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try
    lQuery.Open(' SELECT * FROM TBL_CONFIGURACAO_FIN WHERE ID = 1');
    result := lQuery.FieldByName('ULTIMA_SINC_CP').AsDateTime;
  finally
    lQuery.Free;
  end;
end;

class function TFunctions.RetornaUltimoSincCR: TDateTime;
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try
    lQuery.Open(' SELECT * FROM TBL_CONFIGURACAO_FIN WHERE ID = 1');
    result := lQuery.FieldByName('ULTIMA_SINC_CR').AsDateTime;
  finally
    lQuery.Free;
  end;
end;

class function TFunctions.ValidaCodigoEChaveEmpresa: Boolean;
var
  lQuery: TQuery;
begin
  try
    lQuery := TQuery.Create(nil);
    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add('SELECT * FROM MC27PROP                                                        ');
    lQuery.SQL.Add('where ((AC27_CHAVE is null) or (AC27_CHAVE = '''') or (AN27CODI_INT is null)) ');
    lQuery.Open;
    result := lQuery.recordcount = 0;
  finally
    lQuery.Free;
  end;
end;

class function TFunctions.VersaoSistema: string;
var
  VerInfoSize, VerValueSize, Dummy: DWORD;
  VerInfo: Pointer;
  VerValue: PVSFixedFileInfo;
  V1, V2, V3: Word;
  cV1, cV2, cV3: string;
  FileName: string;
begin
  FileName := application.exeName;
  VerInfoSize := GetFileVersionInfoSize(PChar(FileName), Dummy);
  GetMem(VerInfo, VerInfoSize);
  GetFileVersionInfo(PChar(FileName), 0, VerInfoSize, VerInfo);
  VerQueryValue(VerInfo, '', Pointer(VerValue), VerValueSize);
  with VerValue^ do
  begin
    V1 := dwFileVersionMS shr 16;
    V2 := dwFileVersionMS and $FFFF;
    V3 := dwFileVersionLS shr 16;
    // V4 := dwFileVersionLS and $FFFF;
  end;
  FreeMem(VerInfo, VerInfoSize);

  cV1 := IntToStr(V1);
  cV2 := IntToStr(V2);
  cV3 := IntToStr(V3);
  result := cV1 + '.' + cV2 + '.' + cV3;

end;

class function TFunctions.ThereWasMovementInTheAPIConnection: Boolean;
begin

end;

class function TFunctions.TriggerValidation(pNameTrigger: string): Boolean;
var
  lQuery: TQuery;
begin

  lQuery := TQuery.Create(nil);
  try
    result := false;

    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add(' SELECT * FROM RDB$TRIGGERS                                            ');
    lQuery.SQL.Add(' WHERE UPPER(RDB$TRIGGER_NAME) = UPPER(' + QuotedStr(pNameTrigger) + ')');
    lQuery.Open;
    lQuery.FetchAll;

    if lQuery.recordcount > 0 then
    begin
      result := true;
    end;
  finally
    lQuery.Free;
  end;

end;

class function TFunctions.AtualizaContaPagarComoEnviado(pTitulo: string; pLastDateAtt: TDateTime): Boolean;
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try
    lQuery.Connection := TConnection.ObjectConnection.Connection;
    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add(' UPDATE OR INSERT INTO TBL_INTEG_CP (       ');
    lQuery.SQL.Add(' TITULO,EXCLUIDO,ENVIADO, DATA_ATUALIZACAO  ');
    lQuery.SQL.Add(' )VALUES(                                   ');
    lQuery.SQL.Add(' :TITULO,''N'' ,''S'',:DATA_ATUALIZACAO)    ');
    lQuery.SQL.Add(' MATCHING (TITULO);                         ');
    lQuery.ParamByName('TITULO').AsSTRING := pTitulo;
    lQuery.ParamByName('DATA_ATUALIZACAO').AsDateTime := IncMinute(pLastDateAtt, -1);
    lQuery.ExecSQL;
    lQuery.Connection.Commit;
  finally
    lQuery.Free;
  end;

end;

class function TFunctions.AtualizaContaReceberComoEnviado(pDuplicata: string; pLastDateAtt: TDateTime): Boolean;
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try
    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add(' UPDATE OR INSERT INTO TBL_INTEG_CR (       ');
    lQuery.SQL.Add(' DUPLICATA,EXCLUIDO,ENVIADO, DATA_ATUALIZACAO  ');
    lQuery.SQL.Add(' )VALUES(                                   ');
    lQuery.SQL.Add(' :DUPLICATA,''N'' ,''S'',:DATA_ATUALIZACAO)    ');
    lQuery.SQL.Add(' MATCHING (DUPLICATA);                         ');
    lQuery.ParamByName('DUPLICATA').AsSTRING := pDuplicata;
    lQuery.ParamByName('DATA_ATUALIZACAO').AsDateTime := IncMinute(pLastDateAtt, -1);
    lQuery.ExecSQL;
    lQuery.Connection.Commit;
  finally
    lQuery.Free;
  end;

end;

class function TFunctions.AtualizaCPParaReenvio(pTitle: string): Boolean;
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try

    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add(' UPDATE OR INSERT INTO TBL_INTEG_CP (       ');
    lQuery.SQL.Add(' TITULO,EXCLUIDO,ENVIADO,DATA_ATUALIZACAO)  ');
    lQuery.SQL.Add(' VALUES (                                   ');
    lQuery.SQL.Add(' :TITULO,''N'' ,''N'',:DATA_ATUALIZACAO)    ');
    lQuery.SQL.Add(' MATCHING (TITULO);                         ');
    lQuery.ParamByName('TITULO').AsSTRING := pTitle;
    lQuery.ParamByName('DATA_ATUALIZACAO').AsDateTime := IncMinute(RetornaUltimoSincCP, 1);
    lQuery.ExecSQL;
    lQuery.Connection.Commit;
  finally
    lQuery.Free;
  end;

end;

class function TFunctions.AtualizaTituloEmpresaCP(pTitulo: string): Boolean;
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try
    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add(' update MC08CPAG                               ');
    lQuery.SQL.Add(' set AC08EMP_TIT = :AC08EMP_TIT                ');
    lQuery.SQL.Add(' WHERE AC08TIT = :AC08TIT                      ');
    lQuery.ParamByName('AC08TIT').AsSTRING := pTitulo;
    lQuery.ParamByName('AC08EMP_TIT').AsSTRING := RetornaCodigoEmpresa + '-' + pTitulo;
    lQuery.ExecSQL;
    lQuery.Connection.Commit;
  finally
    lQuery.Free;
  end;

end;

class function TFunctions.AtualizaDuplicataEmpresaCR(pDuplicata: string): Boolean;
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try
    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add(' update MC09CREC                               ');
    lQuery.SQL.Add(' set AC09EMP_DUP = :AC09EMP_DUP                ');
    lQuery.SQL.Add(' WHERE AC09DUP = :AC09DUP                      ');
    lQuery.ParamByName('AC09DUP').AsSTRING := pDuplicata;
    lQuery.ParamByName('AC09EMP_DUP').AsSTRING := RetornaCodigoEmpresa + '-' + pDuplicata;
    lQuery.ExecSQL;
    lQuery.Connection.Commit;
  finally
    lQuery.Free;
  end;

end;

class function TFunctions.AtualizaCRParaReenvio(pDuplicata: String): Boolean;
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try

    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add(' UPDATE OR INSERT INTO TBL_INTEG_CR (       ');
    lQuery.SQL.Add(' DUPLICATA,EXCLUIDO,ENVIADO,DATA_ATUALIZACAO)  ');
    lQuery.SQL.Add(' VALUES (                                   ');
    lQuery.SQL.Add(' :DUPLICATA,''N'' ,''N'',:DATA_ATUALIZACAO)    ');
    lQuery.SQL.Add(' MATCHING (DUPLICATA);                         ');
    lQuery.ParamByName('DUPLICATA').AsSTRING := pDuplicata;
    lQuery.ParamByName('DATA_ATUALIZACAO').AsDateTime := IncMinute(RetornaUltimoSincCR, 1);
    lQuery.ExecSQL;
    lQuery.Connection.Commit;
  finally
    lQuery.Free;
  end;

end;

class procedure TFunctions.AtualizaDataUltimaConexaoCP(pDateTime: TDateTime);
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try
    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add(' UPDATE OR INSERT INTO TBL_CONFIGURACAO_FIN    ');
    lQuery.SQL.Add(' (ID, ULTIMA_SINC_CP)                          ');
    lQuery.SQL.Add(' VALUES (1 , :ULTIMA_SINC_CP)                  ');
    lQuery.SQL.Add(' MATCHING (ID)                                 ');
    lQuery.ParamByName('ULTIMA_SINC_CP').AsDateTime := pDateTime;
    lQuery.ExecSQL;
    lQuery.Connection.Commit;
  finally
    lQuery.Free;
  end;

end;

class procedure TFunctions.AtualizaDataUltimaConexaoCR(pDateTime: TDateTime);
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try
    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add(' UPDATE OR INSERT INTO TBL_CONFIGURACAO_FIN    ');
    lQuery.SQL.Add(' (ID, ULTIMA_SINC_CR)                          ');
    lQuery.SQL.Add(' VALUES (1 , :ULTIMA_SINC_CR)                  ');
    lQuery.SQL.Add(' MATCHING (ID)                                 ');
    lQuery.ParamByName('ULTIMA_SINC_CR').AsDateTime := pDateTime;
    lQuery.ExecSQL;
    lQuery.Connection.Commit;
  finally
    lQuery.Free;
  end;

end;

class procedure TFunctions.AtualizaComoEnviadaTabelaAuxCP(pTitle: string; pLastDateAtt: TDateTime);
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try
    lQuery.Connection := TConnection.ObjectConnection.Connection;
    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add(' update TBL_INTEG_CP set               ');
    lQuery.SQL.Add(' ENVIADO = ''S'',                      ');
    lQuery.SQL.Add(' DATA_ATUALIZACAO = :DATA_ATUALIZACAO  ');
    lQuery.SQL.Add(' where (TITULO = :TITULO)              ');
    lQuery.ParamByName('TITULO').AsSTRING := pTitle;
    lQuery.ParamByName('DATA_ATUALIZACAO').AsDateTime := IncMinute(pLastDateAtt, -1);
    lQuery.ExecSQL;
    lQuery.Connection.Commit;
  finally
    lQuery.Free;
  end;
end;

class procedure TFunctions.AtualizaComoEnviadaTabelaAuxCR(pDuplicata: string; pLastDateAtt: TDateTime);
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try
    lQuery.Connection := TConnection.ObjectConnection.Connection;
    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add(' update TBL_INTEG_CR set               ');
    lQuery.SQL.Add(' ENVIADO = ''S'',                      ');
    lQuery.SQL.Add(' DATA_ATUALIZACAO = :DATA_ATUALIZACAO  ');
    lQuery.SQL.Add(' where (DUPLICATA = :DUPLICATA)              ');
    lQuery.ParamByName('DUPLICATA').AsSTRING := pDuplicata;
    lQuery.ParamByName('DATA_ATUALIZACAO').AsDateTime := IncMinute(pLastDateAtt, -1);
    lQuery.ExecSQL;
    lQuery.Connection.Commit;
  finally
    lQuery.Free;
  end;
end;

class function TFunctions.ColumnExists(pColumn, pJson: string): Boolean;
begin
  result := Pos('"' + pColumn + '":', pJson) > 0
end;

class function TFunctions.writeJson(pType: string = 'cr'; pJson: String = ''): Boolean;
var
  lArquivoIni: TIniFile;
  lFullNameFile, lNameFile: string;
begin
  lNameFile := 'json.ini';
  lFullNameFile := ExtractFilePath(application.exeName) + lNameFile;

  lArquivoIni := TIniFile.Create(lFullNameFile);
  try
    lArquivoIni.WriteString('json', pType, pJson);
  finally
    lArquivoIni.Free;
  end;

end;

end.
