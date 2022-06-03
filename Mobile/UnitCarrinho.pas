unit UnitCarrinho;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  System.JSON,

  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.Objects,
  FMX.Controls.Presentation,
  FMX.StdCtrls,
  FMX.Layouts,
  FMX.ListBox,
  uFunctions,
  uLoading;

type
  TFrmCarrinho = class(TForm)
    lytToolbar: TLayout;
    lblTitulo: TLabel;
    imgVoltar: TImage;
    lytEndereco: TLayout;
    lblNome: TLabel;
    lblEndereco: TLabel;
    btnFinalizar: TButton;
    Rectangle1: TRectangle;
    Layout1: TLayout;
    Label2: TLabel;
    lblSubtotal: TLabel;
    Layout2: TLayout;
    Label4: TLabel;
    lblTotal: TLabel;
    Layout3: TLayout;
    Label6: TLabel;
    lblTaxa: TLabel;
    Label8: TLabel;
    lblEndEntrega: TLabel;
    lbProdutos: TListBox;
    procedure FormShow(Sender: TObject);
    procedure btnFinalizarClick(Sender: TObject);
  private
    procedure AddProduto(id_produto: Integer;
                                  descricao, url_foto: string;
                                  qtde, valor_unit: Double);
    procedure CarregarCarrinho;
    procedure DownloadFoto(lb: TListBox);
    procedure ThreadPedidoTerminate(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmCarrinho: TFrmCarrinho;

implementation

uses
   UnitPrincipal,
   Frame.ProdutoLista,
   DataModule.Mercado,
   DataModule.Usuario;

{$R *.fmx}

procedure TFrmCarrinho.DownloadFoto(lb: TListBox);
var
   t    : TThread;
   foto : TBitmap;
   frame: TFrameProdutoLista;
begin
   //Carregar imagens..
   t := TThread.CreateAnonymousThread(procedure
   var
      i : Integer;
   begin
      for i := 0 to lb.Items.Count - 1 do
      begin
         frame := TFrameProdutoLista(lb.ItemByIndex(i).Components[0]);

         if frame.imgFoto.TagString  <> '' then
         begin
            foto := TBitmap.Create;
            LoadImageFromURL(foto,frame.imgFoto.TagString);
            frame.imgFoto.TagString := '';
            frame.imgFoto.bitmap    := foto;
         end;
      end;
   end);
   t.start;
end;

procedure TFrmCarrinho.AddProduto(id_produto: Integer;
                                  descricao, url_foto: string;
                                  qtde, valor_unit: Double);
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
   frame.imgFoto.TagString := url_foto;
   frame.lblDescricao.Text := descricao;
   frame.lblQtd.Text       := qtde.ToString + ' x ' + FormatFloat('#,##0.00', valor_unit);
   frame.lblValor.Text     := FormatFloat('R$ #,##0.00', qtde * valor_unit);

   item.AddObject(frame);

   lbProdutos.AddObject(item);
end;

procedure TFrmCarrinho.ThreadPedidoTerminate(Sender: TObject);
begin
   TLoading.Hide;

   if Sender is TThread then
   begin
      if Assigned(TThread(Sender).FatalException) then
      begin
         ShowMessage(Exception(TThread(Sender).FatalException).Message);
         Exit;
      end;
   end;

   DmMercado.LimparCarrinhoLocal;
   Close;
end;

procedure TFrmCarrinho.btnFinalizarClick(Sender: TObject);
var
   T : TThread;
   JsonPedido: TJsonObject;
   arrayItem : TJSONArray;
begin
   TLoading.Show(FrmCarrinho, '');
   T := TThread.CreateAnonymousThread(procedure
   begin
      try
         jsonPedido := DmMercado.JsonPedido(lblSubtotal.TagFloat, lblTaxa.TagFloat, lblTotal.TagFloat);
         jsonPedido.AddPair('itens', DmMercado.JsonPedidoItem);

         DmMercado.InserirPedido(jsonPedido);
      finally
         jsonPedido.DisposeOf;
      end;
   end);

   T.OnTerminate := ThreadPedidoTerminate;
   T.Start;
end;

procedure TFrmCarrinho.CarregarCarrinho;
var
  subtotal: Double;
begin
   try
      DmMercado.ListarCarrinhoLocal;
      DmMercado.ListarItemCarrinhoLocal;
      DmUsuario.ListarUsuarioLocal;

      //Dados Mercado...
      lblNome.Text     := DmMercado.QryCarrinho.FieldByName('NOME_MERCADO').AsString;
      lblEndereco.Text := DmMercado.QryCarrinho.FieldByName('ENDERECO_MERCADO').AsString;
      lblTaxa.Text     := FormatFloat('R$ #,##0.00', DmMercado.QryCarrinho.FieldByName('TAXA_ENTREGA').AsFloat);
      lblTaxa.TagFloat := DmMercado.QryCarrinho.FieldByName('TAXA_ENTREGA').AsFloat;

      //Dados Usuario
      lblEndEntrega.Text     := DmUsuario.QryUsuario.FieldByName('ENDERECO').AsString + ' - ' +
                                DmUsuario.QryUsuario.FieldByName('BAIRRO').AsString + ' - ' +
                                DmUsuario.QryUsuario.FieldByName('CIDADE').AsString + ' - ' +
                                DmUsuario.QryUsuario.FieldByName('UF').AsString;

      //Itens do carrinho
      subtotal := 0;
      lbProdutos.Items.Clear;
      with DmMercado.QryCarrinhoItem do
      begin
         while not EOF do
         begin
            AddProduto(FieldByName('id_produto').AsInteger,
                       FieldByName('nome').AsString,
                       FieldByName('url_foto').AsString,
                       FieldByName('qtd').AsFloat,
                       FieldByName('valor_unitario').AsFloat);

            subtotal  := subtotal + FieldByName('valor_total').AsFloat;
            Next;
         end;
      end;

      lblSubtotal.Text := FormatFloat('R$ #,##0.00', subtotal);
      lblTotal.Text    := FormatFloat('R$ #,##0.00', subtotal + lblTaxa.TagFloat);

      //Carrega as fotos...
      DownloadFoto(lbProdutos);

   except on Ex: Exception do
      ShowMessage('Erro ao carregar carrinho: ' + Ex.Message);
   end;
end;

procedure TFrmCarrinho.FormShow(Sender: TObject);
begin
   CarregarCarrinho;
end;

end.
