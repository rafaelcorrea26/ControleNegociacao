unit fPrincipal;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.ExtCtrls,
  Vcl.StdCtrls,
  REST.Client,
  Data.Bind.Components,
  Data.Bind.ObjectScope,
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
  Vcl.ComCtrls,
  System.DateUtils,
  Vcl.Menus,
  System.ImageList,
  Vcl.ImgList,
  System.NetEncoding,
  Vcl.DBCtrls,
  Vcl.AppEvnts,
  Vcl.Samples.Gauges,
  Vcl.Imaging.jpeg,
  uFunctions,
  uProdutores,
  uProdutoresDAO,
  uQuery,
  uMessages,
  System.Threading,
  Vcl.Grids,
  Vcl.DBGrids,
  fCadastroProdutor,
  fCadastroDistribuidor,
  uDistribuidores,
  uDistribuidoresDAO;

type
  TfrmPrincipal = class(TForm)
    pnlPrincipal: TPanel;
    pnlTitulo: TPanel;
    lblVersion: TLabel;
    imlIconsBlack24dp: TImageList;
    popmenu: TPopupMenu;
    Abrir1: TMenuItem;
    N1: TMenuItem;
    FecharAplicao1: TMenuItem;
    pnlModoAdm: TPanel;
    pnlCentral: TPanel;
    mnuPrincipal: TMainMenu;
    pnlRodape: TPanel;
    Produtor1: TMenuItem;
    Distribuidor1: TMenuItem;
    Distribuidor2: TMenuItem;
    ManutenodeNegociao1: TMenuItem;
    Produtos1: TMenuItem;
    Usurio1: TMenuItem;
    procedure btnSairClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnAtualizarClick(Sender: TObject);
    procedure btnIncluirClick(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);

  private
    { Private declarations }
    procedure ValidaUnicaEstanciaSistema;

    procedure Incluir;
    procedure Alterar;
    procedure Excluir;
    procedure Atualizar;

  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.dfm}

procedure TfrmPrincipal.ValidaUnicaEstanciaSistema;
begin
  CreateMutex(nil, False, 'IntegradorFinanceiro');
  if GetLastError = ERROR_ALREADY_EXISTS then
  begin
    MessageBox(0, 'Este programa já está sendo executado.', 'IntegradorContasPagar', MB_ICONSTOP);
    Halt(0);
  end;
end;



procedure TfrmPrincipal.btnSairClick(Sender: TObject);
begin
  Close;
end;


procedure TfrmPrincipal.FormCreate(Sender: TObject);
var
  lEmpresa: string;
begin
  ValidaUnicaEstanciaSistema;

  if trim(lEmpresa) <> EmptyStr then
  begin
    lblVersion.Caption := 'Versão: ' + TFunctions.VersaoSistema;
  end
  else
  begin
    lblVersion.Caption := EmptyStr;
  end;
end;

procedure TfrmPrincipal.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) then
  begin
    Key := #0;
    Perform(WM_NEXTDLGCTL, 0, 0);
  end;
end;

procedure TfrmPrincipal.FormShow(Sender: TObject);
begin
  WindowState := wsMaximized;
  Atualizar;
end;



end.
