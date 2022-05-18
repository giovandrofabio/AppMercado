unit UnitCarrinho;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.ListBox;

type
  TFrmCarrinho = class(TForm)
    lytToolbar: TLayout;
    lblTitulo: TLabel;
    imgVoltar: TImage;
    lytEndereco: TLayout;
    lblEndereco: TLabel;
    Label1: TLabel;
    btnBusca: TButton;
    Rectangle1: TRectangle;
    Layout1: TLayout;
    Label2: TLabel;
    Label3: TLabel;
    Layout2: TLayout;
    Label4: TLabel;
    Label5: TLabel;
    Layout3: TLayout;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    lbProdutos: TListBox;
    procedure FormShow(Sender: TObject);
  private
    procedure AddProduto(id_produto: Integer; descricao: string; qtde,
      valor_unit: Double; foto: TStream);
    procedure CarregarCarrinho;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmCarrinho: TFrmCarrinho;

implementation

uses
   UnitPrincipal, Frame.ProdutoLista;

{$R *.fmx}

procedure TFrmCarrinho.AddProduto(id_produto: Integer;
                                  descricao: string;
                                  qtde, valor_unit: Double;
                                  foto: TStream);
var
   item: TListBoxItem;
   frame: TFrameProdutoLista;
begin
   item            := TListBoxItem.Create(lbProdutos);
   item.Selectable := False;
   item.Text       := '';
   item.Height     := 80;
   item.Tag        := id_produto;

   //Frame
   frame := TFrameProdutoLista.Create(item);
   frame.lblDescricao.Text := descricao;
   frame.lblQtd.Text       := qtde.ToString + ' x ' + FormatFloat('#,##0.00', valor_unit);
   frame.lblValor.Text     := FormatFloat('R$ #,##0.00', qtde * valor_unit);

   item.AddObject(frame);

   lbProdutos.AddObject(item);
end;

procedure TFrmCarrinho.CarregarCarrinho;
begin
   AddProduto(0, 'Caf� Pil�o', 2, 8, nil);
   AddProduto(1, 'Caf� Pil�o', 1, 9, nil);
   AddProduto(2, 'Caf� Pil�o', 1, 15.50, nil);
   AddProduto(3, 'Caf� Pil�o', 4, 3, nil);
end;

procedure TFrmCarrinho.FormShow(Sender: TObject);
begin
   CarregarCarrinho;
end;

end.
