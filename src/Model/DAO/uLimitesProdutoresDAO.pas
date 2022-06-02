unit uLimitesProdutoresDAO;

interface

uses

  uDistribuidoresDAO,
  uQuery,
  System.SysUtils,
  Vcl.Dialogs,
  Data.DB,
  uFunctions,
  uDistribuidores,
  uLimitesProdutores,
  REST.JSON.Types,
  uInterfacesEntity;

type
  TLimiteProdutoresDAO = class(TInterfacedObject, iEntidadeDAO)
  public
    class function Limpar(pLimiteProdutor: TLimitesProdutores): Boolean;
    class function Carrega(pLimiteProdutor: TLimitesProdutores): Boolean;
    class function Incluir(pLimiteProdutor: TLimitesProdutores): Boolean;
    class function Alterar(pLimiteProdutor: TLimitesProdutores): Boolean;
    class function Excluir(pID: Integer): Boolean;

    class function Existe(pID: Integer): Boolean;
    class function ExisteCPFouCNPJ(pCPFouCNPJ: string): Integer;
    class function GeraProximoCodigo: Integer;

  end;

implementation

{ TLimiteProdutoresDAO }
class function TLimiteProdutoresDAO.Alterar(pLimiteProdutor: TLimitesProdutores): Boolean;
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try
    lQuery.close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add(' UPDATE LIMITES_PRODUTORES set                    ');
    lQuery.SQL.Add('   ID_PRODUTOR = :ID_PRODUTOR                     ');
    lQuery.SQL.Add(' , ID_DISTRIBUIDOR = :ID_DISTRIBUIDOR             ');
    lQuery.SQL.Add(' , LIMITE_CREDITO = :LIMITE_CREDITO               ');
    lQuery.SQL.Add('   where (ID = :ID)                               ');
    lQuery.ParamByName('ID').AsInteger := pLimiteProdutor.ID;
    lQuery.ParamByName('ID_PRODUTOR').AsInteger := pLimiteProdutor.id_produtor;
    lQuery.ParamByName('ID_DISTRIBUIDOR').AsInteger := pLimiteProdutor.id_distribuidor;
    lQuery.ParamByName('LIMITE_CREDITO').AsFloat := pLimiteProdutor.limite_credito;
    lQuery.ExecSql;
    lQuery.connection.commit;
  finally
    lQuery.free;
  end;

end;

class function TLimiteProdutoresDAO.Carrega(pLimiteProdutor: TLimitesProdutores): Boolean;
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try
    lQuery.close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add(' SELECT * FROM LIMITES_PRODUTORES WHERE ID = :ID ');
    lQuery.ParamByName('ID').AsInteger := pLimiteProdutor.ID;
    lQuery.Open;

    if lQuery.RecordCount > 0 then
    begin
      pLimiteProdutor.id_produtor := lQuery.fieldbyname('ID_PRODUTOR').AsInteger;
      pLimiteProdutor.id_distribuidor := lQuery.fieldbyname('ID_DISTRIBUIDOR').AsInteger;
      pLimiteProdutor.limite_credito := lQuery.fieldbyname('LIMITE_CREDITO').AsFloat;
    end;

    Result := (lQuery.RecordCount > 0);

  finally
    lQuery.free;
  end;

end;

class function TLimiteProdutoresDAO.Excluir(pID: Integer): Boolean;
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try
    lQuery.close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add('DELETE FROM LIMITES_PRODUTORES    ');
    lQuery.SQL.Add('  WHERE ID = :ID                  ');
    lQuery.ParamByName('ID').AsInteger := pID;
    lQuery.ExecSql;
    lQuery.connection.commit;
  finally
    lQuery.free;
  end;
end;

class function TLimiteProdutoresDAO.Existe(pID: Integer): Boolean;
var
  lQuery: TQuery;
begin
  Result := false;
  lQuery := TQuery.Create(nil);
  try
    lQuery.SQL.Add('SELECT * FROM LIMITES_PRODUTORES WHERE ID = :ID');
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

class function TLimiteProdutoresDAO.GeraProximoCodigo: Integer;
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try
    Result := 1;
    lQuery.close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add(' select gen_id(GEN_LIMITES_PRODUTORES_ID,0) from rdb$database ');
    lQuery.Open;

    if lQuery.RecordCount > 0 then
    begin
      Result := lQuery.fieldbyname('gen_id').AsInteger + 1;
    end;
  finally
    lQuery.free;
  end;

end;

class function TLimiteProdutoresDAO.Incluir(pLimiteProdutor: TLimitesProdutores): Boolean;
var
  lQuery: TQuery;
begin

  lQuery := TQuery.Create(nil);
  try
    lQuery.close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add(' INSERT INTO LIMITES_PRODUTORES (              ');
    lQuery.SQL.Add('   ID_PRODUTOR                                 ');
    lQuery.SQL.Add(' , ID_DISTRIBUIDOR                             ');
    lQuery.SQL.Add(' , LIMITE_CREDITO                              ');
    lQuery.SQL.Add(' )                                             ');
    lQuery.SQL.Add(' values (                                      ');
    lQuery.SQL.Add('   :ID_PRODUTOR                                ');
    lQuery.SQL.Add(' , :ID_DISTRIBUIDOR                            ');
    lQuery.SQL.Add(' , :LIMITE_CREDITO                             ');
    lQuery.SQL.Add(' )                                      ');
    lQuery.ParamByName('ID_PRODUTOR').AsInteger := pLimiteProdutor.id_produtor;
    lQuery.ParamByName('ID_DISTRIBUIDOR').AsInteger := pLimiteProdutor.id_distribuidor;
    lQuery.ParamByName('LIMITE_CREDITO').AsFloat := pLimiteProdutor.limite_credito;
    lQuery.ExecSql;
    lQuery.connection.commit;
  finally
    lQuery.free;
  end;
end;

class function TLimiteProdutoresDAO.Limpar(pLimiteProdutor: TLimitesProdutores): Boolean;
begin

end;

end.
