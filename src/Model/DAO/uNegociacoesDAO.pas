unit uNegociacoesDAO;

interface

uses

  uDistribuidores,
  uNegociacoes,
  uQuery,
  System.SysUtils,
  Vcl.Dialogs,
  Data.DB,
  uFunctions,
  uItensNegociacoes,
  uProdutores,
  REST.JSON.Types,
  uInterfacesEntity;

type
  TNegociacoesDAO = class(TInterfacedObject, iEntidadeDAO)
  public
    class function Limpar(pNegociacao: TNegociacoes): Boolean;
    class function Carrega(pNegociacao: TNegociacoes): Boolean;
    class function Incluir(pNegociacao: TNegociacoes): Boolean;
    class function Alterar(pNegociacao: TNegociacoes): Boolean;
    class function Excluir(pID: Integer): Boolean;

    class function Existe(pID: Integer): Boolean;
    class function ExisteCPFouCNPJ(pCPFouCNPJ: string): Integer;
    class function GeraProximoCodigo: Integer;

  end;

implementation

{ TNegociacoesDAO }
class function TNegociacoesDAO.Alterar(pNegociacao: TNegociacoes): Boolean;
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

    lQuery.ParamByName('ID').AsInteger := pNegociacao.ID;
    lQuery.ParamByName('NOME').AsString := Copy(pNegociacao.Nome, 1, 50);
    lQuery.ParamByName('CPF_CNPJ').AsString := Copy(pNegociacao.cpf_cnpj, 1, 14);
    lQuery.ExecSql;
    lQuery.connection.commit;
  finally
    lQuery.free;
  end;

end;

class function TNegociacoesDAO.Carrega(pNegociacao: TNegociacoes): Boolean;
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try
    lQuery.close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add(' SELECT * FROM PRODUTORES WHERE ID = :ID ');
    lQuery.ParamByName('ID').AsInteger := pNegociacao.ID;
    lQuery.Open;

    if lQuery.RecordCount > 0 then
    begin
      pNegociacao.Nome := lQuery.fieldbyname('NOME').AsString;
      pNegociacao.cpf_cnpj := lQuery.fieldbyname('CPF').AsString;

      // if (pNegociacao.cidade.Codigo > 0) then
      // begin
      // TCidadeDAO.Carrega(pNegociacao.cidade);
      // end;
    end;

    Result := (lQuery.RecordCount > 0);

  finally
    lQuery.free;
  end;

end;

class function TNegociacoesDAO.Excluir(pID: Integer): Boolean;
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

class function TNegociacoesDAO.Existe(pID: Integer): Boolean;
var
  lQuery: TQuery;
begin
  Result := false;
  lQuery := TQuery.Create(nil);
  try
    lQuery.SQL.Add('SELECT * FROM NEGOCIACOES WHERE ID = :ID');
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


class function TNegociacoesDAO.GeraProximoCodigo: Integer;
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try
    Result := 1;
    lQuery.close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add(' select gen_id(GEN_NEGOCIACOES_ID,0) from rdb$database ');
    lQuery.Open;

    if lQuery.RecordCount > 0 then
    begin
      Result := lQuery.fieldbyname('gen_id').AsInteger + 1;
    end;
  finally
    lQuery.free;
  end;

end;

class function TNegociacoesDAO.Incluir(pNegociacao: TNegociacoes): Boolean;
var
  lQuery: TQuery;
begin

  lQuery := TQuery.Create(nil);
  try
    lQuery.close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add(' INSERT INTO NEGOCIACOES (               ');
    lQuery.SQL.Add('   NOME                                 ');
    lQuery.SQL.Add(' , CPF                                  ');
    lQuery.SQL.Add(' )                                      ');
    lQuery.SQL.Add(' values (                               ');
    lQuery.SQL.Add('   :NOME                                ');
    lQuery.SQL.Add(' , :CPF                                 ');
    lQuery.SQL.Add(' )                                      ');
    lQuery.ParamByName('NOME').AsString := Copy(pNegociacao.Nome, 1, 50);
    lQuery.ParamByName('CPF_CNPJ').AsString := Copy(pNegociacao.cpf_cnpj, 1, 11);
    lQuery.ExecSql;
    lQuery.connection.commit;
  finally
    lQuery.free;
  end;
end;

class function TNegociacoesDAO.Limpar(pNegociacao: TNegociacoes): Boolean;
begin

end;

end.
