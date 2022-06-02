unit uProdutos;

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
  TProdutos = class;

  TProdutos = class(TInterfacedObject, iEntidade)
  private
    Fid: integer;
    Fnome: string;
    Fpreco: Double;
  public
    property id: integer read Fid write Fid;
    property nome: string read Fnome write Fnome;
    property preco: Double read Fpreco write Fpreco;

    destructor destroy; override;
    constructor create;
    function toJson: string;
  end;

implementation

function TProdutos.toJson: string;
begin
  result := TJson.ObjectToJsonString(self, [joIgnoreEmptyStrings]);
end;

constructor TProdutos.create;
begin

end;

destructor TProdutos.destroy;
begin

end;

end.
