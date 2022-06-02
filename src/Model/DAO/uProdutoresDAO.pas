unit uProdutoresDAO;

interface

uses

  uDistribuidoresDAO,
  uQuery,
  System.SysUtils,
  Vcl.Dialogs,
  Data.DB,
  uFunctions,
  uDistribuidores,
  uProdutores,
  REST.JSON.Types,
  uInterfacesEntity;

type
  TProdutoresDAO = class(TInterfacedObject, iEntidadeDAO)
  public
    class function Limpar(pProdutor: TProdutores): Boolean;
    class function Carrega(pProdutor: TProdutores): Boolean;
    class function Incluir(pProdutor: TProdutores): Boolean;
    class function Alterar(pProdutor: TProdutores): Boolean;
    class function Excluir(pID: Integer): Boolean;

    class function Existe(pID: Integer): Boolean;
    class function ExisteCPFouCNPJ(pCPFouCNPJ: string): Integer;
    class function GeraProximoCodigo: Integer;

  end;

implementation

{ TProdutoresDAO }
class function TProdutoresDAO.Alterar(pProdutor: TProdutores): Boolean;
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try
    lQuery.close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add(' UPDATE PRODUTORES set                           ');
    lQuery.SQL.Add('   NOME = :NOME                                   ');
    lQuery.SQL.Add(' , CPF_CNPJ = :CPF_CNPJ                           ');
    lQuery.SQL.Add('   where (ID = :ID)                               ');

    lQuery.ParamByName('ID').AsInteger := pProdutor.ID;
    lQuery.ParamByName('NOME').AsString := Copy(pProdutor.Nome, 1, 50);
    lQuery.ParamByName('CPF_CNPJ').AsString := Copy(pProdutor.cpf_cnpj, 1, 14);
    lQuery.ExecSql;
    lQuery.connection.commit;
  finally
    lQuery.free;
  end;

end;

class function TProdutoresDAO.Carrega(pProdutor: TProdutores): Boolean;
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try
    lQuery.close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add(' SELECT * FROM PRODUTORES WHERE ID = :ID ');
    lQuery.ParamByName('ID').AsInteger := pProdutor.ID;
    lQuery.Open;

    if lQuery.RecordCount > 0 then
    begin
      pProdutor.Nome := lQuery.fieldbyname('NOME').AsString;
      pProdutor.cpf_cnpj := lQuery.fieldbyname('CPF').AsString;

      // if (pProdutor.cidade.Codigo > 0) then
      // begin
      // TCidadeDAO.Carrega(pProdutor.cidade);
      // end;
    end;

    Result := (lQuery.RecordCount > 0);

  finally
    lQuery.free;
  end;

end;

class function TProdutoresDAO.Excluir(pID: Integer): Boolean;
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try
    lQuery.close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add('DELETE FROM PRODUTORES          ');
    lQuery.SQL.Add('  WHERE ID = :ID ');
    lQuery.ParamByName('ID').AsInteger := pID;
    lQuery.ExecSql;
    lQuery.connection.commit;
  finally
    lQuery.free;
  end;
end;

class function TProdutoresDAO.Existe(pID: Integer): Boolean;
var
  lQuery: TQuery;
begin
  Result := false;
  lQuery := TQuery.Create(nil);
  try
    lQuery.SQL.Add('SELECT * FROM PRODUTORES WHERE ID = :ID');
    lQuery.ParamByName('ID').AsInteger := pID;
    lQuery.Open;

    if (lQuery.RecordCount > 0) then
    begin
      Result := true;
    end;
  finally
    lQuery.free;
  end;
end;

class function TProdutoresDAO.ExisteCPFouCNPJ(pCPFouCNPJ: string): Integer;
var
  lQuery: TQuery;
begin
  Result := 0;

  lQuery := TQuery.Create(nil);
  try
    lQuery.SQL.Add('SELECT * FROM PRODUTORES WHERE CPF_CNPJ = :CPF_CNPJ');
    lQuery.ParamByName('CPF').AsString := pCPFouCNPJ;
    lQuery.Open;

    if (lQuery.RecordCount > 0) then
    begin
      Result := lQuery.fieldbyname('ID').AsInteger;
    end;
  finally
    lQuery.free;
  end;

end;

class function TProdutoresDAO.GeraProximoCodigo: Integer;
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try
    Result := 1;
    lQuery.close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add(' select gen_id(GEN_PRODUTORES_ID,0) from rdb$database ');
    lQuery.Open;

    if lQuery.RecordCount > 0 then
    begin
      Result := lQuery.fieldbyname('gen_id').AsInteger + 1;
    end;
  finally
    lQuery.free;
  end;

end;

class function TProdutoresDAO.Incluir(pProdutor: TProdutores): Boolean;
var
  lQuery: TQuery;
begin

  lQuery := TQuery.Create(nil);
  try
    lQuery.close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add(' INSERT INTO PRODUTORES (               ');
    lQuery.SQL.Add('   NOME                                 ');
    lQuery.SQL.Add(' , CPF                                  ');
    lQuery.SQL.Add(' )                                      ');
    lQuery.SQL.Add(' values (                               ');
    lQuery.SQL.Add('   :NOME                                ');
    lQuery.SQL.Add(' , :CPF                                 ');
    lQuery.SQL.Add(' )                                      ');
    lQuery.ParamByName('NOME').AsString := Copy(pProdutor.Nome, 1, 50);
    lQuery.ParamByName('CPF_CNPJ').AsString := Copy(pProdutor.cpf_cnpj, 1, 11);
    lQuery.ExecSql;
    lQuery.connection.commit;
  finally
    lQuery.free;
  end;
end;

class function TProdutoresDAO.Limpar(pProdutor: TProdutores): Boolean;
begin

end;

end.
