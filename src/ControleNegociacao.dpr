program ControleNegociacao;

uses
  Vcl.Forms,
  fPrincipal in 'View\fPrincipal.pas' {frmPrincipal},
  uInterfacesEntity in 'Interfaces\uInterfacesEntity.pas',
  uFunctions in 'Shared\uFunctions.pas',
  uMessages in 'Shared\uMessages.pas',
  uQuery in 'Model\uQuery.pas',
  uConnection in 'Model\uConnection.pas',
  uDistribuidoresDAO in 'Model\DAO\uDistribuidoresDAO.pas',
  uProdutoresDAO in 'Model\DAO\uProdutoresDAO.pas',
  uDistribuidores in 'Model\Entity\uDistribuidores.pas',
  uProdutores in 'Model\Entity\uProdutores.pas',
  fCadastroProdutor in 'View\fCadastroProdutor.pas' {frmCadastroProdutor},
  fCadastroDistribuidor in 'View\fCadastroDistribuidor.pas' {frmCadastroDistribuidor},
  uProdutosDAO in 'Model\DAO\uProdutosDAO.pas',
  uProdutos in 'Model\Entity\uProdutos.pas',
  uLimitesProdutoresDAO in 'Model\DAO\uLimitesProdutoresDAO.pas',
  uLimitesProdutores in 'Model\Entity\uLimitesProdutores.pas',
  uNegociacoes in 'Model\Entity\uNegociacoes.pas',
  uItensNegociacoes in 'Model\Entity\uItensNegociacoes.pas',
  uNegociacoesDAO in 'Model\DAO\uNegociacoesDAO.pas',
  uItensNegociacoesDAO in 'Model\DAO\uItensNegociacoesDAO.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.CreateForm(TfrmCadastroProdutor, frmCadastroProdutor);
  Application.CreateForm(TfrmCadastroDistribuidor, frmCadastroDistribuidor);
  Application.Run;
end.
