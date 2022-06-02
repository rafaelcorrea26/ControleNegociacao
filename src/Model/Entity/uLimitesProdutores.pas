unit uLimitesProdutores;

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
  TLimitesProdutores = class;

  TLimitesProdutores = class(TInterfacedObject, iEntidade)
  private
    Fid: integer;
    Fid_produtor: integer;
    Fid_distribuidor: integer;
    Flimite_credito: Double;
  public
    property id: integer read Fid write Fid;
    property id_produtor: integer read Fid write Fid;
    property id_distribuidor: integer read Fid write Fid;
    property limite_credito: Double read Fid write Fid;

    destructor destroy; override;
    constructor create;
    function toJson: string;
  end;

implementation

function TLimitesProdutores.toJson: string;
begin
  result := TJson.ObjectToJsonString(self, [joIgnoreEmptyStrings]);
end;

constructor TLimitesProdutores.create;
begin

end;

destructor TLimitesProdutores.destroy;
begin

end;

end.
