unit uDistribuidores;

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
  TDistribuidores = class;

  TDistribuidores = class(TInterfacedObject, iEntidade)
  private
    Fid: integer;
    Fnome: string;
    Fcpf_cnpj: string;
    FIndice: integer;
  public
    property Indice: integer read FIndice write FIndice;
    property id: integer read Fid write Fid;
    property nome: string read Fnome write Fnome;
    property cpf_cnpj: string read Fcpf_cnpj write Fcpf_cnpj;

    destructor destroy; override;
    constructor create;
    function toJson: string;
  end;

implementation

function TDistribuidores.toJson: string;
begin
  result := TJson.ObjectToJsonString(self, [joIgnoreEmptyStrings]);
end;

constructor TDistribuidores.create;
begin

end;

destructor TDistribuidores.destroy;
begin

end;

end.
