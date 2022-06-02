unit uDistribuidoresDAO;

interface

uses
  Data.DB,
  uQuery,
  uDistribuidores,
  uInterfacesEntity,
  System.SysUtils;

type
  TDistribuidoresDAO = class(TInterfacedObject, iEntidadeDAO)
  private
  public

    class function Carrega(pDistribuidor: TDistribuidores): boolean;
    class function Incluir(pDistribuidor: TDistribuidores): boolean;
    class function Alterar(pDistribuidor: TDistribuidores): boolean;
    class function Excluir(pID: string): boolean;
    class function Limpar(pDistribuidor: TDistribuidores): boolean;
    class function Existe(pDistribuidor: TDistribuidores): boolean;
    class function GeraProximoCodigo: integer;

  end;

implementation

{ TDistribuidoresDAO }

class function TDistribuidoresDAO.Existe(pDistribuidor: TDistribuidores): boolean;
var
  lQuery: TQuery;
begin
  Result := false;

  lQuery := TQuery.Create(nil);
  try
    lQuery.SQL.Add('SELECT * FROM DISTRIBUIDORES WHERE ID = :ID');
    lQuery.ParamByName('ID').AsInteger := pDistribuidor.id;
    lQuery.Open;

    if (lQuery.RecordCount > 0) then
    begin
      Result := true;
    end;
  finally
    lQuery.Free;
  end;

end;

class function TDistribuidoresDAO.GeraProximoCodigo: integer;
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try
    Result := 1;
    lQuery.close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add(' select gen_id(GEN_DISTRIBUIDORES_ID,0) from rdb$database ');
    lQuery.Open;

    if lQuery.RecordCount > 0 then
    begin
      Result := lQuery.FieldByName('gen_id').AsInteger + 1;
    end;
  finally
    lQuery.Free;
  end;

end;

class function TDistribuidoresDAO.Alterar(pDistribuidor: TDistribuidores): boolean;
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try
    lQuery.close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add('UPDATE DISTRIBUIDORES SET        ');
    lQuery.SQL.Add('     NOME       =:NOME         ');
    lQuery.SQL.Add('   , CPF_CNPJ   =:CPF_CNPJ     ');
    lQuery.SQL.Add('WHERE ID        =:ID           ');
    lQuery.ParamByName('ID').AsInteger := pDistribuidor.id;
    lQuery.ParamByName('NOME').AsString := copy(pDistribuidor.nome, 1, 50);
    lQuery.ParamByName('CPF_CNPJ').AsString := copy(pDistribuidor.cpf_cnpj, 1, 14);
    lQuery.ExecSQL;
    lQuery.Connection.Commit;
  finally
    lQuery.Free;
  end;
end;

class function TDistribuidoresDAO.Carrega(pDistribuidor: TDistribuidores): boolean;
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try
    lQuery.close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add('SELECT * FROM DISTRIBUIDORES WHERE ID = :ID ');
    lQuery.ParamByName('ID').AsInteger := pDistribuidor.id;
    lQuery.Open;

    pDistribuidor.nome := lQuery.FieldByName('NOME').AsString;
    pDistribuidor.cpf_cnpj := lQuery.FieldByName('CPF_CNPJ').AsString;
  finally
    lQuery.Free;
  end;
end;

class function TDistribuidoresDAO.Excluir(pID: string): boolean;
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try
    lQuery.close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add('DELETE FROM DISTRIBUIDORES     ');
    lQuery.SQL.Add('WHERE ID =:ID                ');
    lQuery.ParamByName('ID').AsString := pID;
    lQuery.ExecSQL;
    lQuery.Connection.Commit;
  finally
    lQuery.Free;
  end;
end;

class function TDistribuidoresDAO.Incluir(pDistribuidor: TDistribuidores): boolean;
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try
    lQuery.close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add('INSERT INTO DISTRIBUIDORES(     ');
    lQuery.SQL.Add('     NOME                     ');
    lQuery.SQL.Add('   , CPF_CNPJ                 ');
    lQuery.SQL.Add('   ) VALUES (                 ');
    lQuery.SQL.Add('     :NOME                    ');
    lQuery.SQL.Add('   , :CPF_CNPJ                ');
    lQuery.SQL.Add('   )                          ');
    lQuery.ParamByName('NOME').AsString := copy(pDistribuidor.nome, 1, 50);
    lQuery.ParamByName('CPF_CNPJ').AsString := copy(pDistribuidor.cpf_cnpj, 1, 14);
    lQuery.ExecSQL;
    lQuery.Connection.Commit;
  finally
    lQuery.Free;
  end;
end;

class function TDistribuidoresDAO.Limpar(pDistribuidor: TDistribuidores): boolean;
begin
  pDistribuidor.nome := EmptyStr;
  pDistribuidor.cpf_cnpj := EmptyStr;
end;

end.
