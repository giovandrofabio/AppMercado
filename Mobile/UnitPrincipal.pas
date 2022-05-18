unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Layouts, FMX.Edit,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, FMX.Ani;

type
  TFrmPrincipal = class(TForm)
    lytToolbar: TLayout;
    imgMenu: TImage;
    imgCarrinho: TImage;
    Label1: TLabel;
    lytPesquisa: TLayout;
    StyleBook: TStyleBook;
    rectPesquisa: TRectangle;
    Edit1: TEdit;
    Image3: TImage;
    Button1: TButton;
    lytSwitch: TLayout;
    rectSwith: TRectangle;
    rectSelecao: TRectangle;
    lblCasa: TLabel;
    lblRetira: TLabel;
    lvMercado: TListView;
    imgShop: TImage;
    imgTaxa: TImage;
    imgPedidoMin: TImage;
    AnimationFiltro: TFloatAnimation;
    rectMenu: TRectangle;
    Image2: TImage;
    imgFecharMenu: TImage;
    Label2: TLabel;
    Label3: TLabel;
    rectMenuPedido: TRectangle;
    Label4: TLabel;
    Rectangle2: TRectangle;
    Label5: TLabel;
    Rectangle3: TRectangle;
    Label6: TLabel;
    procedure FormShow(Sender: TObject);
    procedure lvMercadoItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure lblCasaClick(Sender: TObject);
    procedure imgCarrinhoClick(Sender: TObject);
    procedure imgMenuClick(Sender: TObject);
    procedure imgFecharMenuClick(Sender: TObject);
    procedure rectMenuPedidoClick(Sender: TObject);
  private
    procedure AddMercadoLv(id_mercado: Integer; nome, endereco: string;
                           tx_entrega, vl_min_ped: double);
    procedure ListarMercados;
    procedure SelectionarEntrega(lbl: TLabel);
    procedure OpenMenu(ind: boolean);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

uses
   UnitMercado,
   UnitCarrinho, UnitPedido;

{$R *.fmx}

procedure TFrmPrincipal.AddMercadoLv(id_mercado: Integer;
                                     nome, endereco: string;
                                     tx_entrega, vl_min_ped: double);
var
   img: TListItemImage;
   txt: TListItemText;
begin
   with lvMercado.Items.Add do
   begin
      Height := 115;
      Tag := id_mercado;

      img := TListItemImage(Objects.FindDrawable('imgShop'));
      img.Bitmap := imgShop.Bitmap;

      img := TListItemImage(Objects.FindDrawable('imgTaxa'));
      img.Bitmap := imgTaxa.Bitmap;

      img := TListItemImage(Objects.FindDrawable('imgCompraMin'));
      img.Bitmap := imgPedidoMin.Bitmap;

      txt := TListItemText(Objects.FindDrawable('txtNome'));
      txt.Text := nome;

      txt := TListItemText(Objects.FindDrawable('txtEndereco'));
      txt.Text := endereco;

      txt := TListItemText(Objects.FindDrawable('txtTaxa'));
      txt.Text := 'Taxa de entrega: ' + FormatFloat('R$ #,##0.00', tx_entrega);

      txt := TListItemText(Objects.FindDrawable('txtCompraMin'));
      txt.Text := 'Compra m�nima: ' + FormatFloat('R$ #,##0.00', vl_min_ped);
   end;
end;

procedure TFrmPrincipal.ListarMercados;
begin
   AddMercadoLv(1,'P�o de A��car','Av. Paulista, 1500', 10, 50);
   AddMercadoLv(1,'P�o de A��car','Av. Paulista, 1500', 10, 50);
   AddMercadoLv(1,'P�o de A��car','Av. Paulista, 1500', 10, 50);
   AddMercadoLv(1,'P�o de A��car','Av. Paulista, 1500', 10, 50);
end;

procedure TFrmPrincipal.lvMercadoItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
   if not Assigned(FrmMercado) then
      Application.CreateForm(TFrmMercado, FrmMercado);

   FrmMercado.Show;
end;

procedure TFrmPrincipal.FormShow(Sender: TObject);
begin
   ListarMercados;
end;

procedure TFrmPrincipal.imgCarrinhoClick(Sender: TObject);
begin
   if not Assigned(FrmCarrinho) then
      Application.CreateForm(TFrmCarrinho, FrmCarrinho);

   FrmCarrinho.Show;
end;

procedure TFrmPrincipal.imgFecharMenuClick(Sender: TObject);
begin
   OpenMenu(False);
end;

procedure TFrmPrincipal.OpenMenu(ind: boolean);
begin
   rectMenu.Visible := ind;
end;

procedure TFrmPrincipal.rectMenuPedidoClick(Sender: TObject);
begin
   if not Assigned(FrmPedido) then
      Application.CreateForm(TFrmPedido, FrmPedido);

   OpenMenu(false);
   FrmPedido.Show;
end;

procedure TFrmPrincipal.imgMenuClick(Sender: TObject);
begin
   OpenMenu(true);
end;

procedure TFrmPrincipal.SelectionarEntrega(lbl: TLabel);
begin
   lblCasa.FontColor   := $FF8F8F8F;
   lblRetira.FontColor := $FF8F8F8F;

   lbl.FontColor := $FFFFFFFF;

   AnimationFiltro.StopValue := lbl.Position.x;
   AnimationFiltro.Start;
end;

procedure TFrmPrincipal.lblCasaClick(Sender: TObject);
begin
   SelectionarEntrega(TLabel(Sender));
end;

end.
