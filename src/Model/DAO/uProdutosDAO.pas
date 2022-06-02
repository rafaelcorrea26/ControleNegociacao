unit uProdutosDAO;

interface

uses
  Data.DB,
  uQuery,
  uInterfacesEntity,
  System.SysUtils,
  uProdutos;

type
  TProdutosDAO = class(TInterfacedObject, iEntidadeDAO)
  private
  public

    class function Carrega(pProduto: TProdutos): boolean;
    class function Incluir(pProduto: TProdutos): boolean;
    class function Alterar(pProduto: TProdutos): boolean;
    class function Excluir(pID: string): boolean;
    class function Limpar(pProduto: TProdutos): boolean;
    class function Existe(pProduto: TProdutos): boolean;
    class function GeraProximoCodigo: integer;

  end;

implementation

{ TProdutosDAO }

class function TProdutosDAO.Existe(pProduto: TProdutos): boolean;
var
  lQuery: TQuery;
begin
  Result := false;

  lQuery := TQuery.Create(nil);
  try
    lQuery.SQL.Add('SELECT * FROM DISTRIBUIDORES WHERE ID = :ID');
    lQuery.ParamByName('ID').AsInteger := pProduto.id;
    lQuery.Open;

    if (lQuery.RecordCount > 0) then
    begin
      Result := true;
    end;
  finally
    lQuery.Free;
  end;

end;

class function TProdutosDAO.GeraProximoCodigo: integer;
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

class function TProdutosDAO.Alterar(pProduto: TProdutos): boolean;
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
    lQuery.ParamByName('ID').AsInteger := pProduto.id;
    lQuery.ParamByName('NOME').AsString := copy(pProduto.nome, 1, 50);
    lQuery.ParamByName('PRECO').AsString := pProduto.preco;
    lQuery.ExecSQL;
    lQuery.Connection.Commit;
  finally
    lQuery.Free;
  end;
end;

class function TProdutosDAO.Carrega(pProduto: TProdutos): boolean;
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try
    lQuery.close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add('SELECT * FROM DISTRIBUIDORES WHERE ID = :ID ');
    lQuery.ParamByName('ID').AsInteger := pProduto.id;
    lQuery.Open;

    pProduto.nome := lQuery.FieldByName('NOME').AsString;
    pProduto.preco := lQuery.FieldByName('PRECO').AsFloat;
  finally
    lQuery.Free;
  end;
end;

class function TProdutosDAO.Excluir(pID: string): boolean;
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

class function TProdutosDAO.Incluir(pProduto: TProdutos): boolean;
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
    lQuery.ParamByName('NOME').AsString := copy(pProduto.nome, 1, 50);
    lQuery.ParamByName('CPF_CNPJ').AsString := pProduto.preco;
    lQuery.ExecSQL;
    lQuery.Connection.Commit;
  finally
    lQuery.Free;
  end;
end;

class function TProdutosDAO.Limpar(pProduto: TProdutos): boolean;
begin
  pProduto.nome := EmptyStr;
  pProduto.preco := 0;
end;

end.
