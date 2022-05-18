unit UnitPedido;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, FMX.Objects, FMX.Controls.Presentation, FMX.StdCtrls,
  FMX.Layouts;

type
  TFrmPedido = class(TForm)
    lytToolbar: TLayout;
    lblTitulo: TLabel;
    imgVoltar: TImage;
    lvPedidos: TListView;
    imgPedidoMin: TImage;
    imgShop: TImage;
    procedure FormShow(Sender: TObject);
    procedure lvPedidosItemClick(const Sender: TObject;
      const AItem: TListViewItem);
  private
    procedure AddPedidoLv(id_pedido, qtd_itens: Integer; nome, endereco,
      dt_pedido: string; vl_pedido: double);
    procedure ListarPedidos;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPedido: TFrmPedido;

implementation

uses
   UnitPrincipal, UnitPedidoDetalhe;

{$R *.fmx}

procedure TFrmPedido.AddPedidoLv(id_pedido, qtd_itens: Integer;
                                 nome, endereco, dt_pedido: string;
                                 vl_pedido: double);
var
   img: TListItemImage;
   txt: TListItemText;
begin
   with lvPedidos.Items.Add do
   begin
      Height := 115;
      Tag := id_pedido;

      img := TListItemImage(Objects.FindDrawable('imgShop'));
      img.Bitmap := imgShop.Bitmap;

      txt := TListItemText(Objects.FindDrawable('txtNome'));
      txt.Text := nome;

      txt := TListItemText(Objects.FindDrawable('txtPedido'));
      txt.Text := 'Pedido ' + id_pedido.toString;

      txt := TListItemText(Objects.FindDrawable('txtEndereco'));
      txt.Text := endereco;

      txt := TListItemText(Objects.FindDrawable('txtValor'));
      txt.Text := FormatFloat('R$ #,##0.00', vl_pedido) + ' - ' + qtd_itens.ToString + ' itens';

      txt := TListItemText(Objects.FindDrawable('txtData'));
      txt.Text := dt_pedido;
   end;
end;

procedure TFrmPedido.ListarPedidos;
begin
   AddPedidoLv(69951, 3,'Pão de Açucar', 'Av.Paulista,1500','15/02/2022',142);
   AddPedidoLv(58741, 2,'Pão de Açucar', 'Av.Paulista,1500','15/02/2022',142);
   AddPedidoLv(52141, 9,'Pão de Açucar', 'Av.Paulista,1500','15/02/2022',142);
   AddPedidoLv(68451, 8,'Pão de Açucar', 'Av.Paulista,1500','15/02/2022',142);
end;

procedure TFrmPedido.lvPedidosItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
   if not Assigned(FrmPedidoDetalhe) then
      Application.CreateForm(TFrmPedidoDetalhe, FrmPedidoDetalhe);

   FrmPedidoDetalhe.Show;
end;

procedure TFrmPedido.FormShow(Sender: TObject);
begin
   ListarPedidos;
end;

end.
