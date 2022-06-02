unit uItensNegociacoesDAO;

interface

uses
  Data.DB,
  uQuery,
  uDistribuidores,
  uInterfacesEntity,
  System.SysUtils;

type
  TItensNegociacoesDAO = class(TInterfacedObject, iEntidadeDAO)
  private
  public

    class function Carrega(pDistribuidor: TItensNegociacoes): boolean;
    class function Incluir(pDistribuidor: TItensNegociacoes): boolean;
    class function Alterar(pDistribuidor: TItensNegociacoes): boolean;
    class function Excluir(pID: string): boolean;
    class function Limpar(pDistribuidor: TItensNegociacoes): boolean;
    class function Existe(pDistribuidor: TItensNegociacoes): boolean;
    class function GeraProximoCodigo: integer;

  end;

implementation

{ TItensNegociacoesDAO }

class function TItensNegociacoesDAO.Existe(pDistribuidor: TItensNegociacoes): boolean;
var
  lQuery: TQuery;
begin
  Result := false;

  lQuery := TQuery.Create(nil);
  try
    lQuery.SQL.Add('SELECT * FROM ITENS_NEGOCIACOES WHERE ID = :ID');
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

class function TItensNegociacoesDAO.GeraProximoCodigo: integer;
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try
    Result := 1;
    lQuery.close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add(' select gen_id(GEN_ITENS_NEGOCIACOES_ID,0) from rdb$database ');
    lQuery.Open;

    if lQuery.RecordCount > 0 then
    begin
      Result := lQuery.FieldByName('gen_id').AsInteger + 1;
    end;
  finally
    lQuery.Free;
  end;

end;

class function TItensNegociacoesDAO.Alterar(pDistribuidor: TItensNegociacoes): boolean;
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try
    lQuery.close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add('UPDATE ITENS_NEGOCIACOES SET   ');
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

class function TItensNegociacoesDAO.Carrega(pDistribuidor: TItensNegociacoes): boolean;
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try
    lQuery.close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add('SELECT * FROM ITENS_NEGOCIACOES WHERE ID = :ID ');
    lQuery.ParamByName('ID').AsInteger := pDistribuidor.id;
    lQuery.Open;

    pDistribuidor.nome := lQuery.FieldByName('NOME').AsString;
    pDistribuidor.cpf_cnpj := lQuery.FieldByName('CPF_CNPJ').AsString;
  finally
    lQuery.Free;
  end;
end;

class function TItensNegociacoesDAO.Excluir(pID: string): boolean;
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try
    lQuery.close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add('DELETE FROM ITENS_NEGOCIACOES  ');
    lQuery.SQL.Add('WHERE ID =:ID                  ');
    lQuery.ParamByName('ID').AsString := pID;
    lQuery.ExecSQL;
    lQuery.Connection.Commit;
  finally
    lQuery.Free;
  end;
end;

class function TItensNegociacoesDAO.Incluir(pDistribuidor: TItensNegociacoes): boolean;
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try
    lQuery.close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add('INSERT INTO ITENS_NEGOCIACOES(     ');
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

class function TItensNegociacoesDAO.Limpar(pDistribuidor: TItensNegociacoes): boolean;
begin
  pDistribuidor.nome := EmptyStr;
  pDistribuidor.cpf_cnpj := EmptyStr;
end;

end.
