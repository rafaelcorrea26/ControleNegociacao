unit fConsultaDistribuidor;

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
  uCidade,
  uCidadeDAO,
  uQuery,
  uMessages,
  System.Threading,
  Vcl.Grids,
  Vcl.DBGrids, fCadastroFuncionario, uFuncionarioDAO;

type
  TfrmConsultaDistribuidor = class(TForm)
    pnlPrincipal: TPanel;
    pnlTitulo: TPanel;
    lblVersion: TLabel;
    imlIconsBlack24dp: TImageList;
    popmenu: TPopupMenu;
    Abrir1: TMenuItem;
    N1: TMenuItem;
    FecharAplicao1: TMenuItem;
    pnlModoAdm: TPanel;
    pnlBotoes: TPanel;
    btnAlterar: TButton;
    pnlCentral: TPanel;
    mnuPrincipal: TMainMenu;
    btnIncluir: TButton;
    btnExcluir: TButton;
    grdPrincipal: TDBGrid;
    dtsPrincipal: TDataSource;
    pnlRodape: TPanel;
    btnSair: TButton;
    tblPrincipal: TFDMemTable;
    tblPrincipalCODIGO: TIntegerField;
    tblPrincipalNOME: TStringField;
    tblPrincipalENDERECO: TStringField;
    tblPrincipalBAIRRO: TStringField;
    tblPrincipalNUMERO: TStringField;
    tblPrincipalCOMPLEMENTO: TStringField;
    tblPrincipalCEP: TStringField;
    tblPrincipalCPF: TStringField;
    tblPrincipalRG: TStringField;
    tblPrincipalFONE: TStringField;
    tblPrincipalCELULAR: TStringField;
    tblPrincipalDATA_NASC: TDateField;
    tblPrincipalEMAIL: TStringField;
    tblPrincipalSALARIO: TFloatField;
    tblPrincipalCIDADE: TIntegerField;
    tblPrincipalDESC_CIDADE: TStringField;
    btnAtualizar: TButton;
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
  frmConsultaDistribuidor: TfrmConsultaDistribuidor;

implementation

{$R *.dfm}

procedure TfrmConsultaDistribuidor.ValidaUnicaEstanciaSistema;
begin
  CreateMutex(nil, False, 'IntegradorFinanceiro');
  if GetLastError = ERROR_ALREADY_EXISTS then
  begin
    MessageBox(0, 'Este programa já está sendo executado.', 'IntegradorContasPagar', MB_ICONSTOP);
    Halt(0);
  end;
end;

procedure TfrmConsultaDistribuidor.btnAlterarClick(Sender: TObject);
begin
  if (tblPrincipal.RecordCount > 0) then
  begin
    Alterar;
  end
  else
  begin
    ShowMessage('Nao ha registros disponíveis');
  end;
end;

procedure TfrmConsultaDistribuidor.btnAtualizarClick(Sender: TObject);
begin
  Atualizar;
end;

procedure TfrmConsultaDistribuidor.btnExcluirClick(Sender: TObject);
begin
  if (tblPrincipal.RecordCount > 0) then
  begin
    Excluir;
  end
  else
  begin
    ShowMessage('Nao ha registros disponíveis');
  end;
end;

procedure TfrmConsultaDistribuidor.btnIncluirClick(Sender: TObject);
begin
  Incluir;
end;

procedure TfrmConsultaDistribuidor.btnSairClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmConsultaDistribuidor.Excluir;
begin
  if MessageDlg('Confirma a Exclusão do funcionario? ' + slinebreak + 'Codigo: ' + tblPrincipalCODIGO.asstring,
    mtConfirmation, [mbyes, mbno], 0) = mryes then
  begin
    TfuncionarioDAO.Excluir(tblPrincipalCODIGO.asinteger);
    Atualizar;
  end;
end;

procedure TfrmConsultaDistribuidor.FormCreate(Sender: TObject);
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

procedure TfrmConsultaDistribuidor.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) then
  begin
    Key := #0;
    Perform(WM_NEXTDLGCTL, 0, 0);
  end;
end;

procedure TfrmConsultaDistribuidor.FormShow(Sender: TObject);
begin
  WindowState := wsMaximized;
  Atualizar;
end;

procedure TfrmConsultaDistribuidor.Alterar;
var
  lFormulario: TfrmCadastroFuncionario;
begin
  lFormulario := TfrmCadastroFuncionario.Create(nil);
  try
    lFormulario.ModalidadeCRUD := 1;
    lFormulario.edtCodigo.Text := tblPrincipalCODIGO.asstring;
    lFormulario.edtNome.Text := tblPrincipalNOME.asstring;
    lFormulario.edtEndereco.Text := tblPrincipalENDERECO.asstring;
    lFormulario.edtBairro.Text := tblPrincipalBAIRRO.asstring;
    lFormulario.edtNumero.Text := tblPrincipalNUMERO.asstring;
    lFormulario.edtComplemento.Text := tblPrincipalCOMPLEMENTO.asstring;
    lFormulario.edtCEP.Text := tblPrincipalCEP.asstring;
    lFormulario.edtCPF.Text := tblPrincipalCPF.asstring;
    lFormulario.edtRG.Text := tblPrincipalRG.asstring;
    lFormulario.edtFone.Text := tblPrincipalFONE.asstring;
    lFormulario.edtCelular.Text := tblPrincipalCELULAR.asstring;
    lFormulario.dtpDataNasc.Date := tblPrincipalDATA_NASC.AsDateTime;
    lFormulario.edtEmail.Text := tblPrincipalEMAIL.asstring;
    lFormulario.edtSalario.Text := tblPrincipalSALARIO.asstring;
    lFormulario.ShowModal;
  finally
    lFormulario.Free;
  end;

end;

procedure TfrmConsultaDistribuidor.Incluir;
var
  lFormulario: TfrmCadastroFuncionario;
begin
  lFormulario := TfrmCadastroFuncionario.Create(nil);
  try
    lFormulario.edtCodigo.Text := TfuncionarioDAO.GeraProximoCodigo.ToString;
    lFormulario.ModalidadeCRUD := 0;
    lFormulario.ShowModal;
  finally
    lFormulario.Free;
  end;
end;

procedure TfrmConsultaDistribuidor.Atualizar;
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try
    lQuery.SQL.Clear;
    lQuery.SQL.Add('SELECT                         ');
    lQuery.SQL.Add('   F.CODIGO                    ');
    lQuery.SQL.Add(' , F.NOME                      ');
    lQuery.SQL.Add(' , F.ENDERECO                  ');
    lQuery.SQL.Add(' , F.BAIRRO                    ');
    lQuery.SQL.Add(' , F.NUMERO                    ');
    lQuery.SQL.Add(' , F.COMPLEMENTO               ');
    lQuery.SQL.Add(' , F.CEP                       ');
    lQuery.SQL.Add(' , F.CPF                       ');
    lQuery.SQL.Add(' , F.RG                        ');
    lQuery.SQL.Add(' , F.FONE                      ');
    lQuery.SQL.Add(' , F.CELULAR                   ');
    lQuery.SQL.Add(' , F.DATA_NASC                 ');
    lQuery.SQL.Add(' , F.EMAIL                     ');
    lQuery.SQL.Add(' , F.SALARIO                   ');
    lQuery.SQL.Add(' , F.CIDADE                    ');
    lQuery.SQL.Add(' , C.CIDADE DESC_CIDADE        ');
    lQuery.SQL.Add(' from FUNCIONARIO F            ');
    lQuery.SQL.Add('INNER JOIN CIDADE C            ');
    lQuery.SQL.Add('ON F.CIDADE = C.CODIGO         ');
    lQuery.SQL.Add('order by 1 DESC                ');
    lQuery.Open;
    lQuery.First;
    tblPrincipal.DisableControls;
    tblPrincipal.EmptyDataSet;

    if lQuery.RecordCount > 0 then
    begin
      while not(lQuery.Eof) do
      begin
        tblPrincipal.Append;
        tblPrincipalCODIGO.asinteger := lQuery.FIEldbyname('CODIGO').asinteger;
        tblPrincipalNOME.asstring := lQuery.FIEldbyname('NOME').asstring;
        tblPrincipalENDERECO.asstring := lQuery.FIEldbyname('ENDERECO').asstring;
        tblPrincipalBAIRRO.asstring := lQuery.FIEldbyname('BAIRRO').asstring;
        tblPrincipalNUMERO.asstring := lQuery.FIEldbyname('NUMERO').asstring;
        tblPrincipalCOMPLEMENTO.asstring := lQuery.FIEldbyname('COMPLEMENTO').asstring;
        tblPrincipalCEP.asstring := lQuery.FIEldbyname('CEP').asstring;
        tblPrincipalCPF.asstring := lQuery.FIEldbyname('CPF').asstring;
        tblPrincipalFONE.asstring := lQuery.FIEldbyname('FONE').asstring;
        tblPrincipalCELULAR.asstring := lQuery.FIEldbyname('CELULAR').asstring;
        tblPrincipalDATA_NASC.AsDateTime := lQuery.FIEldbyname('DATA_NASC').AsDateTime;
        tblPrincipalEMAIL.asstring := lQuery.FIEldbyname('EMAIL').asstring;
        tblPrincipalSALARIO.asfloat := lQuery.FIEldbyname('SALARIO').asfloat;
        tblPrincipalCIDADE.asinteger := lQuery.FIEldbyname('CIDADE').asinteger;
        tblPrincipalDESC_CIDADE.asstring := lQuery.FIEldbyname('DESC_CIDADE').asstring;
        tblPrincipal.Post;
        lQuery.next;
      end;
    end;
    tblPrincipal.First;
    tblPrincipal.EnableControls;
  finally
    lQuery.Free;
  end;
end;

end.
