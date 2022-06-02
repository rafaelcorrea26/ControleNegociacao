unit uNegociacoes;

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
  uItensNegociacoes,
  REST.JSON.Types;

type
  TNegociacoes = class;

  TNegociacoes = class(TInterfacedObject, iEntidade)
  private
    Fid: integer;
    Fstatus: string;
    Fdescricao: string;
    Fid_produtor: integer;
    Fid_distribuidor: integer;
    Fvalor: double;
    Fdata_cadastro: tdate;
    Fdata_aprovacao: tdate;
    Fdata_conclusao: tdate;
    Fdata_cancelamento: tdate;
    FListaDeItens: TObjectList<TItensNegociacoes>;
    FIndexItem: integer;
  public
    property id: integer read Fid write Fid;
    property status: string read Fstatus write Fstatus;
    property descricao: string read Fdescricao write Fdescricao;
    property id_produtor: integer read Fid_produtor write Fid_produtor;
    property id_distribuidor: integer read Fid_distribuidor write Fid_distribuidor;
    property valor: double read Fvalor write Fvalor;
    property data_cadastro: tdate read Fdata_cadastro write Fdata_cadastro;
    property data_aprovacao: tdate read Fdata_aprovacao write Fdata_aprovacao;
    property data_conclusao: tdate read Fdata_conclusao write Fdata_conclusao;
    property data_cancelamento: tdate read Fdata_cancelamento write Fdata_cancelamento;
    property ListaDeDistribuidores: TObjectList<TItensNegociacoes> read FListaDeItens write FListaDeItens;

    destructor destroy; override;
    constructor create;
    function toJson: string;
    procedure LimparLista;
    procedure AdicionarItemNaLista(pItem: TItensNegociacoes);
    procedure RemoverDistribuidorDaLista(pIndex: integer);
  end;

implementation

function TNegociacoes.toJson: string;
begin
  result := TJson.ObjectToJsonString(self, [joIgnoreEmptyStrings]);
end;

procedure TNegociacoes.AdicionarItemNaLista(pItem: TItensNegociacoes);
var
  lItem: TItensNegociacoes;
begin
  Inc(self.FIndexItem);

  lItem := TItensNegociacoes.create;

  lItem.id_negociacao := pItem.id_negociacao;
  lItem.id_produto := pItem.id_produto;
  lItem.valor := pItem.valor;

  FListaDeItens.add(lItem);

end;

constructor TNegociacoes.create;
begin

end;

destructor TNegociacoes.destroy;
begin

end;

procedure TNegociacoes.LimparLista;
begin
  FIndexItem := 0;
  FListaDeItens.Clear;
end;

procedure TNegociacoes.RemoverDistribuidorDaLista(pIndex: integer);
var
  lDistribuidor: TItensNegociacoes;
  I: integer;
begin
  if FListaDeItens.Count <> 0 then
  begin
    for I := (FListaDeItens.Count - 1) downto 0 do
    begin
      if (FListaDeItens.Items[I] = pIndex) then
      begin
        lDistribuidor := FListaDeItens.Items[I];
        FListaDeItens.Remove(lDistribuidor);
      end;
    end;
  end;

end;

end.
