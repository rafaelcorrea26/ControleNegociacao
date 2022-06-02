unit uProdutores;

interface

uses
  System.JSON,
  REST.JSON,
  System.Generics.Collections,
  FireDAC.Comp.Client,
  uConnection,
  System.SysUtils,
  uInterfacesEntity,
  uDistribuidores,
  REST.JSON.Types;

type
  TProdutores = class;

  TProdutores = class(TInterfacedObject, iEntidade)
  private
    Fid: integer;
    Fnome: string;
    Fcpf_cnpj: string;
    FListaDeDistribuidores: TObjectList<TDistribuidores>;
    FIndexDistribuidor: integer;
public
    property id: integer read Fid write Fid;
    property nome: string read Fnome write Fnome;
    property cpf_cnpj: string read Fcpf_cnpj write Fcpf_cnpj;
    property ListaDeDistribuidores: TObjectList<TDistribuidores> read FListaDeDistribuidores
      write FListaDeDistribuidores;

    destructor destroy; override;
    constructor create;
    function toJson: string;
    procedure LimparLista;
    procedure AdicionarDistribuidorNaLista(pDistribuidor: TDistribuidores);
    procedure RemoverDistribuidorDaLista(pIndex: integer);
  end;

implementation

function TProdutores.toJson: string;
begin
  result := TJson.ObjectToJsonString(self, [joIgnoreEmptyStrings]);
end;

procedure TProdutores.AdicionarDistribuidorNaLista(pDistribuidor: TDistribuidores);
var
  lDistribuidor: TDistribuidores;
begin
  Inc(self.FIndexDistribuidor);

  lDistribuidor := TDistribuidores.create;

  lDistribuidor.nome := pDistribuidor.nome;
  lDistribuidor.cpf_cnpj := pDistribuidor.cpf_cnpj;

  FListaDeDistribuidores.add(lDistribuidor);

end;

constructor TProdutores.create;
begin
  FListaDeDistribuidores := TObjectList<TDistribuidores>.create;
end;

destructor TProdutores.destroy;
begin
  FListaDeDistribuidores := nil;
end;

procedure TProdutores.LimparLista;
begin
  FIndexDistribuidor := 0;
  FListaDeDistribuidores.Clear;
end;

procedure TProdutores.RemoverDistribuidorDaLista(pIndex: integer);
var
  lDistribuidor: TDistribuidores;
  I: integer;
begin
  if FListaDeDistribuidores.Count <> 0 then
  begin
    for I := (FListaDeDistribuidores.Count - 1) downto 0 do
    begin
      if (FListaDeDistribuidores.Items[I].indice = pIndex) then
      begin
        lDistribuidor := FListaDeDistribuidores.Items[I];
        FListaDeDistribuidores.Remove(lDistribuidor);
      end;
    end;
  end;

end;

end.
