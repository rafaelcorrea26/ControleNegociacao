unit uQuery; // Classe que gera uma query dinamica

interface

uses
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Param,
  FireDAC.Stan.Error,
  FireDAC.DatS,
  FireDAC.Phys.Intf,
  FireDAC.DApt.Intf,
  FireDAC.Stan.Async,
  FireDAC.DApt,
  Data.DB,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  system.Classes,
  system.SysUtils,
  uconnection;

type

  TQuery = class(TFDQuery)
  private
  public
    constructor Create(AOwner: TComponent); override;
    class procedure PrepareQuery(pQuery: TQuery; pSQL: string);

  end;

implementation

{ TQuery }

constructor TQuery.Create(AOwner: TComponent);
begin
  inherited;
  Connection := Tconnection.ObjectConnection.Connection;
end;

class procedure TQuery.PrepareQuery(pQuery: TQuery; pSQL: string);
begin
  pQuery.Close;
  pQuery.SQL.Clear;
  pQuery.SQL.Text := pSQL;
end;

end.
