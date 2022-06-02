unit uItensNegociacoes;

interface

uses
  System.JSON,
  REST.JSON,
  System.Generics.Collections,
  FireDAC.Comp.Client,
  uConnection,
  System.SysUtils,
  uInterfacesEntity,
  REST.JSON.Types;

type
  TItensNegociacoes = class;

  TItensNegociacoes = class(TInterfacedObject, iEntidade)
  private
    Fid: integer;
    Fid_negociacao: integer;
    Fid_produto: integer;
    Fvalor: double;
    FIndice: integer;
  public
    property Indice: integer read FIndice write FIndice;
    property id: integer read Fid write Fid;
    property id_negociacao: integer read Fid_negociacao write Fid_negociacao;
    property id_produto: integer read Fid_produto write Fid_produto;
    property valor: double read Fvalor write Fvalor;

    destructor destroy; override;
    constructor create;
    function toJson: string;
  end;

implementation

function TItensNegociacoes.toJson: string;
begin
  result := TJson.ObjectToJsonString(self, [joIgnoreEmptyStrings]);
end;

constructor TItensNegociacoes.create;
begin

end;

destructor TItensNegociacoes.destroy;
begin

end;

end.
