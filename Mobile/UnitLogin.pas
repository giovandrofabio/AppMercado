unit UnitLogin;

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
  FMX.Layouts,
  FMX.Objects,
  FMX.TabControl,
  FMX.Edit,
  FMX.Controls.Presentation,
  FMX.StdCtrls,

  uLoading;

type
  TFrmLogin = class(TForm)
    TabControl: TTabControl;
    TabLogin: TTabItem;
    TabConta1: TTabItem;
    TabConta2: TTabItem;
    Image1: TImage;
    Layout1: TLayout;
    Label1: TLabel;
    edtEmail: TEdit;
    btnLogin: TButton;
    Label2: TLabel;
    Image2: TImage;
    Layout2: TLayout;
    Label3: TLabel;
    Button2: TButton;
    Label4: TLabel;
    Label5: TLabel;
    Image3: TImage;
    Layout3: TLayout;
    Label6: TLabel;
    btnCriarConta: TButton;
    Label7: TLabel;
    Label8: TLabel;
    Layout4: TLayout;
    StyleBook: TStyleBook;
    Rectangle1: TRectangle;
    Rectangle2: TRectangle;
    edtSenha: TEdit;
    Rectangle3: TRectangle;
    Edit2: TEdit;
    Rectangle4: TRectangle;
    Edit3: TEdit;
    Rectangle5: TRectangle;
    Edit4: TEdit;
    Rectangle6: TRectangle;
    Edit5: TEdit;
    Rectangle7: TRectangle;
    Edit6: TEdit;
    Rectangle9: TRectangle;
    Edit8: TEdit;
    Rectangle8: TRectangle;
    Edit7: TEdit;
    Rectangle10: TRectangle;
    Edit9: TEdit;
    procedure btnLoginClick(Sender: TObject);
  private
    procedure ThreadLoginTerminate(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmLogin: TFrmLogin;

implementation

uses
  DataModule.Usuario, UnitPrincipal;

{$R *.fmx}

procedure TFrmLogin.ThreadLoginTerminate(Sender: TObject);
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

   //Abrir o form Principal...
   if not Assigned(FrmPrincipal) then
      Application.CreateForm(TFrmPrincipal, FrmPrincipal);

   FrmPrincipal.Show;
end;

procedure TFrmLogin.btnLoginClick(Sender: TObject);
var
   T : TThread;
begin
   TLoading.Show(FrmLogin, '');

   T := TThread.CreateAnonymousThread(procedure
   begin
      DmUsuario.Login(edtEmail.Text, edtSenha.Text);

      // Salvar dados no banco do aparelho..
      if DmUsuario.TabUsuario.RecordCount > 0 then
      begin

      end;

   end);

   T.OnTerminate := ThreadLoginTerminate;
   T.Start;
end;

end.
