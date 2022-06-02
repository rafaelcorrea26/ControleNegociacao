unit uMessages; // Classe de mensagens

interface

uses
  uInterfacesEntity,
  System.SysUtils;

type

  TMessages = class;

  TMessages = class(TInterfacedObject, iMessages)
  private
    FMessageOk: string;
    FMessageErro: string;

    class var FMessages: TMessages;
  public
    destructor Destroy; override;
    constructor Create;

    property MessageOk: string read FMessageOk write FMessageOk;
    property MessageErro: string read FMessageErro write FMessageErro;

    class procedure ReleaseMe;
    class function GetMessages: TMessages; static;
    class property Messages: TMessages read GetMessages write FMessages;

  end;

implementation

{ TMessages }

constructor TMessages.Create;
begin

end;

destructor TMessages.Destroy;
begin

  inherited;
end;

class function TMessages.GetMessages: TMessages;
begin
  if NOT Assigned(FMessages) then
  begin
    FMessages := TMessages.Create;
  end;

  result := FMessages;

end;

class procedure TMessages.ReleaseMe;
begin
  if Assigned(FMessages) then
  begin
    FreeAndNil(FMessages);
  end;
end;

end.
