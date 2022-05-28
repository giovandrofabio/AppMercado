program MeuMercado;

uses
  System.StartUpCopy,
  FMX.Forms,
  UnitLogin in 'UnitLogin.pas' {FrmLogin},
  UnitPrincipal in 'UnitPrincipal.pas' {FrmPrincipal},
  UnitMercado in 'UnitMercado.pas' {FrmMercado},
  Frame.Produto.Card in 'Frames\Frame.Produto.Card.pas' {FrameProdutoCard: TFrame},
  UnitSplash in 'UnitSplash.pas' {FrmSplash},
  UnitProduto in 'UnitProduto.pas' {FrmProduto},
  UnitCarrinho in 'UnitCarrinho.pas' {FrmCarrinho},
  Frame.ProdutoLista in 'Frames\Frame.ProdutoLista.pas' {FrameProdutoLista: TFrame},
  UnitPedido in 'UnitPedido.pas' {FrmPedido},
  UnitPedidoDetalhe in 'UnitPedidoDetalhe.pas' {FrmPedidoDetalhe},
  DataModule.Usuario in 'DataModule\DataModule.Usuario.pas' {DmUsuario: TDataModule},
  uLoading in 'Units\uLoading.pas',
  DataModule.Mercado in 'DataModule\DataModule.Mercado.pas' {DmMercado: TDataModule},
  uConsts in 'Units\uConsts.pas',
  uFunctions in 'Units\uFunctions.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TDmUsuario, DmUsuario);
  Application.CreateForm(TFrmLogin, FrmLogin);
  Application.CreateForm(TDmMercado, DmMercado);
  Application.Run;
end.
