unit UnitMercado;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit, FMX.Objects, FMX.Controls.Presentation, FMX.Layouts, FMX.ListBox;

type
  TFrmMercado = class(TForm)
    lytToolbar: TLayout;
    lblTitulo: TLabel;
    imgVoltar: TImage;
    imgCarrinho: TImage;
    lytPesquisa: TLayout;
    rectPesquisa: TRectangle;
    edtBusca: TEdit;
    Image3: TImage;
    btnBusca: TButton;
    lytEndereco: TLayout;
    lblEndereco: TLabel;
    Image4: TImage;
    Image5: TImage;
    lblEntrega: TLabel;
    lblPedMin: TLabel;
    lbCategoria: TListBox;
    ListBoxItem1: TListBoxItem;
    Rectangle1: TRectangle;
    Label1: TLabel;
    ListBoxItem2: TListBoxItem;
    Rectangle2: TRectangle;
    Label2: TLabel;
    lbProdutos: TListBox;
    procedure FormShow(Sender: TObject);
    procedure lbCategoriaItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure lbProdutosItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
  private
    procedure AddProduto(id_produto: Integer; descricao, unidade: string;
      valor: Double);
    procedure ListarProdutos;
    procedure ListarCategorias;
    procedure AddCategorias(id_categoria: Integer; descricao: string);
    procedure SelecionarCategoria(item: TListBoxItem);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMercado: TFrmMercado;

implementation

uses
   UnitPrincipal, Frame.Produto.Card, UnitProduto;

{$R *.fmx}

procedure TFrmMercado.AddProduto(id_produto: Integer;
                                 descricao, unidade: string;
                                 valor: Double);
var
   item: TListBoxItem;
   frame: TFrameProdutoCard;
begin
   item            := TListBoxItem.Create(lbProdutos);
   item.Selectable := False;
   item.Text       := '';
   item.Height     := 200;
   item.Tag        := id_produto;

   //Frame
   frame := TFrameProdutoCard.Create(item);
   frame.lblDescricao.Text := descricao;
   frame.lblValor.Text     := FormatFloat('R$ #,##0.00', valor);
   frame.lblUnidade.Text   := unidade;

   item.AddObject(frame);

   lbProdutos.AddObject(item);
end;

procedure TFrmMercado.SelecionarCategoria(item: TListBoxItem);
var
   x: Integer;
   item_loop: TListBoxItem;
   rect : TRectangle;
   lbl: TLabel;
begin
   // Zerar os itens...
   for x := 0 to lbCategoria.Items.Count - 1 do
   begin
      item_loop := lbCategoria.ItemByIndex(x);

      rect := TRectangle(item_loop.Components[0]);
      rect.Fill.Color := $FFE2E2E2;

      lbl := TLabel(rect.Components[0]);
      lbl.FontColor := $FF3A3A3A;
   end;

   //Ajusta somente item selecionado...
   rect := TRectangle(item.Components[0]);
   rect.Fill.Color := $FF64BA01;

   lbl := TLabel(rect.Components[0]);
   lbl.FontColor := $FFFFFFFF;

   //Salvar a categoria selecionada...
   lbCategoria.Tag := item.Tag;
end;

procedure TFrmMercado.AddCategorias(id_categoria: Integer;
                                    descricao: string);
var
   item: TListBoxItem;
   rect: TRectangle;
   lbl: TLabel;
begin
   item             := TListBoxItem.Create(lbCategoria);
   item.Selectable  := False;
   item.Text        := '';
   item.Width       := 130;
   item.Tag         := id_categoria;

   rect                := TRectangle.Create(item);
   rect.Cursor         := crHandPoint;
   rect.HitTest        := false;
   rect.Fill.Color     := $FFE2E2E2;
   rect.Align          := TAlignLayout.Client;
   rect.Margins.Top    := 8;
   rect.Margins.Left   := 8;
   rect.Margins.Right  := 8;
   rect.Margins.Bottom := 8;
   rect.XRadius        := 6;
   rect.YRadius        := 6;
   rect.Stroke.Kind    := TBrushKind.None;

   lbl                        := TLabel.Create(rect);
   lbl.Align                  := TAlignLayout.Client;
   lbl.Text                   := descricao;
   lbl.TextSettings.HorzAlign := TTextAlign.Center;
   lbl.TextSettings.VertAlign := TTextAlign.Center;
   lbl.StyledSettings := lbl.StyledSettings - [TStyledSetting.Size,
                                               TStyledSetting.FontColor,
                                               TStyledSetting.Style,
                                               TStyledSetting.Other];
   lbl.Font.Size := 13;
   lbl.FontColor := $FF3A3A3A;

   rect.AddObject(lbl);
   item.AddObject(rect);
   lbCategoria.AddObject(item);
end;

procedure TFrmMercado.ListarCategorias;
begin
   lbCategoria.Items.Clear;

   AddCategorias(0, 'Alimentos');
   AddCategorias(1, 'Bebidas');
   AddCategorias(2, 'Limpeza');
   AddCategorias(3, 'Eletr�nicos');
   AddCategorias(4, 'Inform�tica');

   ListarProdutos;
end;

procedure TFrmMercado.FormShow(Sender: TObject);
begin
   ListarCategorias;
end;

procedure TFrmMercado.lbCategoriaItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
   SelecionarCategoria(Item);
end;

procedure TFrmMercado.lbProdutosItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
   if NOT Assigned(FrmProduto) then
      Application.CreateForm(TFrmProduto, FrmProduto);
   FrmProduto.Show;
end;

procedure TFrmMercado.ListarProdutos;
begin
   AddProduto(0,'Caf� Pil�o Torrado e Mo�do','800g', 15);
   AddProduto(0,'Caf� Pil�o Torrado e Mo�do','800g', 15);
   AddProduto(0,'Caf� Pil�o Torrado e Mo�do','800g', 15);
   AddProduto(0,'Caf� Pil�o Torrado e Mo�do','800g', 15);
   AddProduto(0,'Caf� Pil�o Torrado e Mo�do','800g', 15);
end;

end.
