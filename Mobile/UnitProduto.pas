unit UnitProduto;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts;

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
    Label1: TLabel;
    rectRodape: TRectangle;
    Layout3: TLayout;
    imgMenos: TImage;
    imgMais: TImage;
    lblQuantidade: TLabel;
    btnAdiciona: TButton;
    lytFundo: TLayout;
    procedure FormResize(Sender: TObject);
  private
    FId_Produto: Integer;
    { Private declarations }
  public
    { Public declarations }
    property Id_produto: Integer read FId_Produto write FId_Produto;
  end;

var
  FrmProduto: TFrmProduto;

implementation

uses
   UnitPrincipal;

{$R *.fmx}

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

end.
