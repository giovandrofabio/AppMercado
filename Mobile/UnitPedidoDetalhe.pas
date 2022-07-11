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
  uLoading;

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
    Fid_pedido: Integer;
    procedure AddProduto(id_produto: Integer; descricao: string; qtde,
      valor_unit: Double; foto: TStream);
    procedure CarregarPedido;
    procedure ThreadDadosTerminate(Sender: TObject);
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
end;

procedure TFrmPedidoDetalhe.CarregarPedido;
var
   T       : TThread;
   jsonObj : TJsonObject;
begin
   TLoading.Show(FrmPedidoDetalhe, '');

   T := TThread.CreateAnonymousThread(procedure
   begin
      jsonObj := DmUsuario.JsonPedido(id_pedido);

      TThread.Synchronize(TThread.CurrentThread, procedure
      begin
         lblTitulo.Text     := ' Pedido #' + jsonObj.GetValue<String>('id_pedido','');
         lblMercado.Text    := jsonObj.GetValue<String>('nome_mercado','');
         lblMercadoEnd.Text := jsonObj.GetValue<String>('endereco_mercado','');
      end);
   end);

   T.OnTerminate := ThreadDadosTerminate;
   T.Start;
end;

procedure TFrmPedidoDetalhe.FormShow(Sender: TObject);
begin
   CarregarPedido;
end;

end.
