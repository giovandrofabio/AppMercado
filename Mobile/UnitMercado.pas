unit UnitMercado;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  System.Net.HttpClientComponent,
  System.Net.HttpClient,

  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.StdCtrls,
  FMX.Edit,
  FMX.Objects,
  FMX.Controls.Presentation,
  FMX.Layouts,
  FMX.ListBox,

  uLoading,
  uFunctions;

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
    procedure btnBuscaClick(Sender: TObject);
    procedure imgVoltarClick(Sender: TObject);
  private
    FId_Mercado: Integer;
    procedure AddProduto(id_produto: Integer;
                                 descricao, unidade, url_foto: string;
                                 valor: Double);
    procedure ListarProdutos(id_categoria: integer; busca: string);
    procedure ListarCategorias;
    procedure AddCategorias(id_categoria: Integer; descricao: string);
    procedure SelecionarCategoria(item: TListBoxItem);
    procedure CarregarDados;
    procedure ThreadDadosTerminate(Sender: TObject);
    procedure ThreadProdutosTerminate(Sender: TObject);
    procedure DownloadFoto(lb: TListBox);
    { Private declarations }
  public
    { Public declarations }
    property id_mercado: Integer read FId_Mercado write  FId_Mercado;
  end;

var
  FrmMercado: TFrmMercado;

implementation

uses
   UnitPrincipal,
   Frame.Produto.Card,
   UnitProduto,
   DataModule.Mercado;

{$R *.fmx}

procedure TFrmMercado.DownloadFoto(lb: TListBox);
var
   t    : TThread;
   foto : TBitmap;
   frame: TFrameProdutoCard;
begin
   //Carregar imagens..
   t := TThread.CreateAnonymousThread(procedure
   var
      i : Integer;
   begin
      for i := 0 to lb.Items.Count - 1 do
      begin
         frame := TFrameProdutoCard(lb.ItemByIndex(i).Components[0]);

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

procedure TFrmMercado.AddProduto(id_produto: Integer;
                                 descricao, unidade, url_foto: string;
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
   frame.imgFoto.TagString := url_foto;

   item.AddObject(frame);

   lbProdutos.AddObject(item);
end;

procedure TFrmMercado.btnBuscaClick(Sender: TObject);
begin
   ListarProdutos(lbCategoria.Tag, edtBusca.Text);
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
   DmMercado.ListarCategoria(id_mercado);

   with DmMercado.TabCategoria do
   begin
      while Not Eof do
      begin
         TThread.Synchronize(TThread.CurrentThread, procedure
         begin
            AddCategorias(FieldByName('id_categoria').AsInteger,
                          FieldByName('descricao').AsString);
         end);

         Next;
      end;
   end;


   if lbCategoria.Items.Count > 0 then
      TThread.Synchronize(TThread.CurrentThread, procedure
      begin
         SelecionarCategoria(lbCategoria.ItemByIndex(0));
      end);

end;

procedure TFrmMercado.ThreadDadosTerminate(Sender: TObject);
begin
   lblTitulo.Opacity   := 1;
   lytEndereco.Opacity := 1;
   TLoading.Hide;

   if Sender is TThread then
   begin
      if Assigned(TThread(Sender).FatalException) then
      begin
         ShowMessage(Exception(TThread(Sender).FatalException).Message);
         Exit;
      end;
   end;

   ListarProdutos(lbCategoria.Tag, edtBusca.Text);
end;

procedure TFrmMercado.ThreadProdutosTerminate(Sender: TObject);
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

procedure TFrmMercado.CarregarDados;
var
   T : TThread;
begin
   TLoading.Show(FrmMercado, '');
   lbCategoria.Items.Clear;
   lbProdutos.Items.Clear;
   lblTitulo.Opacity   := 0;
   lytEndereco.Opacity := 0;

   T := TThread.CreateAnonymousThread(procedure
   begin
      //Listar dados do mercado...
      DmMercado.ListarMercadoId(id_mercado);

      with DmMercado.TabMercado do
      begin
         TThread.Synchronize(TThread.CurrentThread, procedure
         begin
           lblTitulo.Text      := FieldByName('nome').AsString;
           lblEndereco.Text    := FieldByName('endereco').AsString;
           lblEntrega.Text     := 'Tx. Entrega: ' + FormatFloat('R$#,##0.00', FieldByName('vl_entrega').AsFloat);
           lblEntrega.TagFloat := FieldByName('vl_entrega').AsFloat;
           lblPedMin.Text      := 'Compra Mín: ' + FormatFloat('R$#,##0.00', FieldByName('vl_compra_min').AsFloat);
         end);
      end;

      //Listar as categorias...
      ListarCategorias;
   end);

   T.OnTerminate := ThreadDadosTerminate;
   T.Start;
end;


procedure TFrmMercado.FormShow(Sender: TObject);
begin
   CarregarDados; // Dados Mercado, categorias e produtos
end;

procedure TFrmMercado.imgVoltarClick(Sender: TObject);
begin
   Close;
end;

procedure TFrmMercado.lbCategoriaItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
   SelecionarCategoria(Item);
   ListarProdutos(lbCategoria.Tag, edtBusca.Text);
end;

procedure TFrmMercado.lbProdutosItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
   if NOT Assigned(FrmProduto) then
      Application.CreateForm(TFrmProduto, FrmProduto);

   FrmProduto.Nome_mercado := lblTitulo.Text;
   FrmProduto.Endereco     := lblEndereco.Text;
   FrmProduto.Taxa_entrega := lblEntrega.TagFloat;
   FrmProduto.id_mercado   := FrmMercado.id_mercado;
   FrmProduto.Id_produto   := Item.Tag;
   FrmProduto.Show;
end;

procedure TFrmMercado.ListarProdutos(id_categoria: integer; busca: string);
var
   T : TThread;
begin
   lbProdutos.Items.Clear;
   TLoading.Show(FrmMercado, '');

   T := TThread.CreateAnonymousThread(procedure
   begin
      DmMercado.ListarProduto(id_mercado, id_categoria, busca);

      with DmMercado.TabProduto do
      begin
         while Not Eof do
         begin
            TThread.Synchronize(TThread.CurrentThread, procedure
            begin
               AddProduto(FieldByName('id_produto').AsInteger,
                          FieldByName('nome').AsString,
                          FieldByName('unidade').AsString,
                          FieldByName('url_foto').AsString,
                          FieldByName('preco').AsFloat);
            end);

            Next;
         end;
      end;
   end);

   T.OnTerminate := ThreadProdutosTerminate;
   T.Start;
end;

end.
