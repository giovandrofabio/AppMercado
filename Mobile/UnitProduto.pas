unit UnitProduto;

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
  FMX.Objects,
  FMX.Controls.Presentation,
  FMX.StdCtrls,
  FMX.Layouts,
  uLoading,
  uFunctions;

type
  TFrmProduto = class(TForm)
    lytToolbar: TLayout;
    lblTitulo: TLabel;
    imgVoltar: TImage;
    lytFoto: TLayout;
    imgFoto: TImage;
    lblNome: TLabel;
    Layout1: TLayout;
    Layout2: TLayout;
    lblUnidade: TLabel;
    lblValor: TLabel;
    lblDescricao: TLabel;
    rectRodape: TRectangle;
    Layout3: TLayout;
    imgMenos: TImage;
    imgMais: TImage;
    lblQuantidade: TLabel;
    btnAdiciona: TButton;
    lytFundo: TLayout;
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure imgVoltarClick(Sender: TObject);
    procedure imgMenosClick(Sender: TObject);
  private
    FId_Produto: Integer;
    procedure CarregarDados;
    procedure ThreadDadosTerminate(Sender: TObject);
    procedure Opacity(op: Integer);
    procedure Qtd(valor: integer);
    { Private declarations }
  public
    { Public declarations }
    property Id_produto: Integer read FId_Produto write FId_Produto;
  end;

var
  FrmProduto: TFrmProduto;

implementation

uses
   UnitPrincipal, DataModule.Mercado;

{$R *.fmx}

procedure TFrmProduto.Qtd(valor: integer);
begin
   try
      if valor = 0 then
         lblQuantidade.Tag := 1
      else
         lblQuantidade.Tag := lblQuantidade.Tag + valor;

      if lblQuantidade.Tag <= 0 then
         lblQuantidade.Tag := 1;
   except
      lblQuantidade.Tag := 1;
   end;

   lblQuantidade.Text := FormatFloat('00', lblQuantidade.Tag);
end;

procedure TFrmProduto.FormResize(Sender: TObject);
begin
   if (FrmProduto.Width > 600) and (FrmProduto.Height > 600) then
   begin
      lytFundo.Align  := TAlignLayout.Center;
      lytFundo.Height := 400;
   end
   else
      lytFundo.Align := TAlignLayout.Client;
end;

procedure TFrmProduto.ThreadDadosTerminate(Sender: TObject);
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

   Opacity(1);
end;

procedure TFrmProduto.Opacity(op : Integer);
begin
   imgFoto.Opacity      := op;
   lblNome.Opacity      := op;
   lblUnidade.Opacity   := op;
   lblValor.Opacity     := op;
   lblDescricao.Opacity := op;
end;

procedure TFrmProduto.CarregarDados;
var
   T : TThread;
   foto : TBitmap;
begin
   Qtd(0);
   Opacity(0);
   TLoading.Show(FrmProduto, '');

   T := TThread.CreateAnonymousThread(procedure
   begin
      // Buscar dados do produto...
      DmMercado.ListarProdutoId(Id_produto);

      with DmMercado.TabProdDetalhe do
      begin
         TThread.Synchronize(TThread.CurrentThread, procedure
         begin
            lblNome.Text      := fieldbyname('nome').asstring;
            lblUnidade.Text   := fieldbyname('unidade').asstring;
            lblValor.Text     := FormatFloat('R$#,##0.00', fieldbyname('preco').asfloat);
            lblDescricao.Text := fieldbyname('descricao').asstring;
         end);

         // Carregar foto do produto...
         foto := TBitmap.Create;
         LoadImageFromURL(foto, fieldbyname('url_foto').asstring);
         imgFoto.Bitmap := foto;
      end;
   end);

   T.OnTerminate := ThreadDadosTerminate;
   T.Start;
end;

procedure TFrmProduto.FormShow(Sender: TObject);
begin
   CarregarDados;
end;

procedure TFrmProduto.imgMenosClick(Sender: TObject);
begin
   Qtd(TImage(Sender).Tag);
end;

procedure TFrmProduto.imgVoltarClick(Sender: TObject);
begin
   Close;
end;

end.
