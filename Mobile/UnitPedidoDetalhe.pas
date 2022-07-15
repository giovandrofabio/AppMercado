unit UnitPedidoDetalhe;

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
  FMX.Layouts,
  FMX.ListBox,
  FMX.Objects,
  FMX.Controls.Presentation,
  FMX.StdCtrls,
  uLoading,
  uFunctions;

type
  TFrmPedidoDetalhe = class(TForm)
    lytToolbar: TLayout;
    lblTitulo: TLabel;
    imgVoltar: TImage;
    lytEndereco: TLayout;
    lblMercado: TLabel;
    lblMercadoEnd: TLabel;
    Rectangle1: TRectangle;
    Layout1: TLayout;
    lblSubtotal1: TLabel;
    lblSubtotal: TLabel;
    Layout2: TLayout;
    lblTotal1: TLabel;
    lblTotal: TLabel;
    Layout3: TLayout;
    lblTaxaEntrega1: TLabel;
    lblTaxaEntrega: TLabel;
    Label8: TLabel;
    lblEndereco: TLabel;
    lbProdutos: TListBox;
    procedure FormShow(Sender: TObject);
  private
    Fid_pedido: Integer;
    procedure AddProduto(id_produto: Integer;
                                  descricao, url_foto: string;
                                  qtde, valor_unit: Double);
    procedure CarregarPedido;
    procedure ThreadDadosTerminate(Sender: TObject);
    procedure DownloadFoto(lb: TListBox);
    { Private declarations }
  public
    property id_pedido: Integer read Fid_pedido write Fid_pedido;
    { Public declarations }
  end;

var
  FrmPedidoDetalhe: TFrmPedidoDetalhe;

implementation

uses
   Frame.ProdutoLista, DataModule.Usuario;

{$R *.fmx}

procedure TFrmPedidoDetalhe.AddProduto(id_produto: Integer;
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

procedure TFrmPedidoDetalhe.ThreadDadosTerminate(Sender: TObject);
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

   DownloadFoto(lbProdutos);
end;

procedure TFrmPedidoDetalhe.DownloadFoto(lb: TListBox);
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

procedure TFrmPedidoDetalhe.CarregarPedido;
var
   T         : TThread;
   jsonObj   : TJsonObject;
   arrayItem : TJSONArray;
begin
   TLoading.Show(FrmPedidoDetalhe, '');
   lbProdutos.Items.Clear;

   T := TThread.CreateAnonymousThread(procedure
   begin
      jsonObj := DmUsuario.JsonPedido(id_pedido);

      TThread.Synchronize(TThread.CurrentThread, procedure
      var
        x : Integer;
      begin
         lblTitulo.Text      := ' Pedido #' + jsonObj.GetValue<String>('id_pedido','');
         lblMercado.Text     := jsonObj.GetValue<String>('nome_mercado','');
         lblMercadoEnd.Text  := jsonObj.GetValue<String>('endereco_mercado','');
         lblSubtotal.Text    := FormatFloat('R$ #,##0.00',jsonObj.GetValue<double>('vl_subtotal',0));
         lblTaxaEntrega.Text := FormatFloat('R$ #,##0.00',jsonObj.GetValue<double>('vl_entrega',0));
         lblTotal.Text       := FormatFloat('R$ #,##0.00',jsonObj.GetValue<double>('vl_total',0));
         lblEndereco.Text    := jsonObj.GetValue<String>('endereco','');

         // Itens...
         arrayItem :=  jsonObj.GetValue<TJSONArray>('itens');

         for x := 0 to arrayItem.Size - 1 do
         begin
            AddProduto(arrayItem.Get(x).GetValue<Integer>('id_produto',0),
                       arrayItem.Get(x).GetValue<String>('descricao',''),
                       arrayItem.Get(x).GetValue<string>('url_foto',''),
                       arrayItem.Get(x).GetValue<Integer>('qtd',0),
                       arrayItem.Get(x).GetValue<double>('vl_unitario',0));
         end;
      end);

      jsonObj.DisposeOf;

   end);

   T.OnTerminate := ThreadDadosTerminate;
   T.Start;
end;

procedure TFrmPedidoDetalhe.FormShow(Sender: TObject);
begin
   CarregarPedido;
end;

end.
