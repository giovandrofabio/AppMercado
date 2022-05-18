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
  UnitPedidoDetalhe in 'UnitPedidoDetalhe.pas' {FrmPedidoDetalhe};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmPrincipal, FrmPrincipal);
  Application.CreateForm(TFrmLogin, FrmLogin);
  Application.CreateForm(TFrmMercado, FrmMercado);
  Application.CreateForm(TFrmSplash, FrmSplash);
  Application.CreateForm(TFrmProduto, FrmProduto);
  Application.CreateForm(TFrmCarrinho, FrmCarrinho);
  Application.CreateForm(TFrmPedido, FrmPedido);
  Application.CreateForm(TFrmPedidoDetalhe, FrmPedidoDetalhe);
  Application.Run;
end.