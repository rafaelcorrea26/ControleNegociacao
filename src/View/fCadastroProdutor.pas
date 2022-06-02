unit fCadastroProdutor;

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
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.Mask,
  Vcl.ComCtrls,
  uProdutores,
  uProdutoresDAO,
  uFunctions,
  uquery,
  System.ImageList,
  Vcl.ImgList, Data.DB, Vcl.Grids, Vcl.DBGrids, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TfrmCadastroProdutor = class(TForm)
    pnlTitulo: TPanel;
    pnlModoAdm: TPanel;
    pnlRodape: TPanel;
    btnSalvar: TButton;
    pnlCentral: TPanel;
    btnSair: TButton;
    imlIconsBlack24dp: TImageList;
    Panel1: TPanel;
    Panel2: TPanel;
    DBGrid1: TDBGrid;
    lblCodigo: TLabel;
    edtCodigo: TEdit;
    Label1: TLabel;
    edtNome: TEdit;
    edtCPFouCNPJ: TLabel;
    edtEmail: TEdit;
    Panel3: TPanel;
    Edit1: TEdit;
    Label2: TLabel;
    btnAdicionarDist: TButton;
    btnAlterarDist: TButton;
    btnExcluirDist: TButton;
    Button4: TButton;
    dtsDist: TDataSource;
    tblDist: TFDMemTable;
    Edit2: TEdit;
    Label3: TLabel;
    tblDistDISTRIBUIDOR: TIntegerField;
    tblDistNOME_DIST: TStringField;
    tblDistLIMITE_CRED: TFloatField;
    procedure btnSalvarClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure btnAdicionarDistClick(Sender: TObject);
  private
    FModalidadeCRUD: Integer;
    { Private declarations }
    procedure Salvar;
    function CadastrarCidade(pCidade: string): boolean;
  public
    { Public declarations }
    property ModalidadeCRUD: Integer read FModalidadeCRUD write FModalidadeCRUD;
  end;

var
  frmCadastroProdutor: TfrmCadastroProdutor;

implementation

{$R *.dfm}
{ TForm1 }

procedure TfrmCadastroProdutor.btnSalvarClick(Sender: TObject);
begin
  Salvar;
end;

procedure TfrmCadastroProdutor.btnAdicionarDistClick(Sender: TObject);
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try
    lQuery.SQL.Clear;
    lQuery.SQL.Add('SELECT                         ');
    lQuery.SQL.Add('   L.ID                    ');
    lQuery.SQL.Add(' , L.ID_PRODUTORES                      ');
    lQuery.SQL.Add(' , L.ENDERECO                  ');

    lQuery.SQL.Add(' from LIMITES_PRODUTOR L       ');
    lQuery.SQL.Add('INNER JOIN CIDADE C            ');
    lQuery.SQL.Add('ON F.CIDADE = C.CODIGO         ');
    lQuery.SQL.Add('order by 1 DESC                ');
    lQuery.Open;
    lQuery.First;
    tblDist.DisableControls;
    tblDist.EmptyDataSet;

    if lQuery.RecordCount > 0 then
    begin
      while not(lQuery.Eof) do
      begin
        tblDist.Append;
        tblPrincipalCODIGO.asinteger := lQuery.FIEldbyname('CODIGO').asinteger;
        tblPrincipalNOME.asstring := lQuery.FIEldbyname('NOME').asstring;
        tblPrincipalENDERECO.asstring := lQuery.FIEldbyname('ENDERECO').asstring;
        tblDist.Post;
        lQuery.next;
      end;
    end;
    tblDist.First;
    tblDist.EnableControls;
  finally
    lQuery.Free;
  end;

end;

procedure TfrmCadastroProdutor.btnSairClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmCadastroProdutor.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) then
  begin
    Key := #0;
    Perform(WM_NEXTDLGCTL, 0, 0);
  end;
end;

procedure TfrmCadastroProdutor.FormShow(Sender: TObject);
begin
  WindowState := wsMaximized;
end;

procedure TfrmCadastroProdutor.Salvar;
var
  lProdutor: TProdutores;
begin

  lProdutor := TProdutores.Create;
  try
    lProdutor.Nome := edtNome.Text;
    lProdutor.cpf_cnpj := edtCPFouCNPJ.Text;

    case ModalidadeCRUD of
      0:
        begin
          TProdutoresDAO.incluir(lProdutor);
        end;
      1:
        begin
          TProdutoresDAO.alterar(lProdutor);
        end;
    end;
  finally
    lProdutor.Free;
  end;

  Close;
end;

end.
