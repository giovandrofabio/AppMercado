unit UnitPedido;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.ListView.Types,
  FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base,
  FMX.ListView,
  FMX.Objects,
  FMX.Controls.Presentation,
  FMX.StdCtrls,
  FMX.Layouts,
  uLoading,
  uSession,
  uFunctions;

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
    procedure ThreadDadosTerminate(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPedido: TFrmPedido;

implementation

uses
   UnitPrincipal, UnitPedidoDetalhe, DataModule.Usuario;

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
      txt.Text := Copy(dt_pedido,1,16);
   end;
end;

procedure TFrmPedido.ListarPedidos;
var
   T : TThread;
begin
   TLoading.Show(FrmPedido, '');
   lvPedidos.Items.Clear;
   lvPedidos.BeginUpdate;

   T := TThread.CreateAnonymousThread(procedure
   begin
      DmUsuario.ListarPedido(TSession.ID_USUARIO);

      with DmUsuario.TabPedido do
      begin
         while NOT Eof do
         begin
            TThread.Synchronize(TThread.CurrentThread, procedure
            begin
               AddPedidoLv(FieldByName('id_pedido').AsInteger,
                           FieldByName('qtd_itens').AsInteger,
                           FieldByName('nome').AsString,
                           FieldByName('endereco').AsString,
                           UTCtoDateBR(FieldByName('dt_pedido').AsString),
                           FieldByName('vl_total').AsFloat);
            end);

            Next;

         end;
      end;
   end);

   T.OnTerminate := ThreadDadosTerminate;
   T.Start;
end;

procedure TFrmPedido.ThreadDadosTerminate(Sender: TObject);
begin
   lvPedidos.EndUpdate;
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


procedure TFrmPedido.lvPedidosItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
   if not Assigned(FrmPedidoDetalhe) then
      Application.CreateForm(TFrmPedidoDetalhe, FrmPedidoDetalhe);

   FrmPedidoDetalhe.id_pedido :=  AItem.Tag;
   FrmPedidoDetalhe.Show;
end;

procedure TFrmPedido.FormShow(Sender: TObject);
begin
   ListarPedidos;
end;

end.
