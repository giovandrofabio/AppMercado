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
    lblCadConta: TLabel;
    Image2: TImage;
    Layout2: TLayout;
    Label3: TLabel;
    btnProximo: TButton;
    lblLogin: TLabel;
    Label5: TLabel;
    Image3: TImage;
    Layout3: TLayout;
    Label6: TLabel;
    btnCriarConta: TButton;
    Label7: TLabel;
    lblLogin2: TLabel;
    Layout4: TLayout;
    StyleBook: TStyleBook;
    Rectangle1: TRectangle;
    Rectangle2: TRectangle;
    edtSenha: TEdit;
    Rectangle3: TRectangle;
    edtNomeCad: TEdit;
    Rectangle4: TRectangle;
    edtSenhaCad: TEdit;
    Rectangle5: TRectangle;
    edtEmailCad: TEdit;
    Rectangle6: TRectangle;
    edtEnderecoCad: TEdit;
    Rectangle7: TRectangle;
    edtBairroCad: TEdit;
    Rectangle9: TRectangle;
    edtUfCad: TEdit;
    Rectangle8: TRectangle;
    edtCidadeCad: TEdit;
    Rectangle10: TRectangle;
    edtCepCad: TEdit;
    btnVoltar: TImage;
    procedure btnLoginClick(Sender: TObject);
    procedure lblCadContaClick(Sender: TObject);
    procedure lblLoginClick(Sender: TObject);
    procedure btnProximoClick(Sender: TObject);
    procedure btnCriarContaClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
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

procedure TFrmLogin.btnProximoClick(Sender: TObject);
begin
   TabControl.GotoVisibleTab(2);
end;

procedure TFrmLogin.FormShow(Sender: TObject);
begin
   try
      DmUsuario.ListarUsuarioLocal;

      if DmUsuario.QryUsuario.RecordCount > 0 then
      begin
         //Abrir o form Principal...
         if not Assigned(FrmPrincipal) then
            Application.CreateForm(TFrmPrincipal, FrmPrincipal);

         Application.MainForm := FrmPrincipal;
         FrmPrincipal.Show;
         FrmLogin.Close;
      end;
   except on ex:Exception do
      ShowMessage(ex.Message);
   end;
end;

procedure TFrmLogin.lblCadContaClick(Sender: TObject);
begin
   TabControl.GotoVisibleTab(1);
end;

procedure TFrmLogin.lblLoginClick(Sender: TObject);
begin
   TabControl.GotoVisibleTab(0);
end;

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

   Application.MainForm := FrmPrincipal;
   FrmPrincipal.Show;
   FrmLogin.Close;
end;

procedure TFrmLogin.btnCriarContaClick(Sender: TObject);
var
   T : TThread;
begin
   TLoading.Show(FrmLogin, '');

   T := TThread.CreateAnonymousThread(procedure
   begin
      DmUsuario.CriarConta(edtNomeCad.Text, edtEmailCad.Text, edtSenhaCad.Text,
                           edtEnderecoCad.Text, edtBairroCad.Text, edtCidadeCad.Text,
                           edtUfCad.Text, edtCepCad.Text);

      // Salvar dados no banco do aparelho..
      with DmUsuario.TabUsuario do
      begin
         if RecordCount > 0 then
         begin
            DmUsuario.SalvarUsuarioLocal(fieldbyname('id_usuario').AsInteger,
                                         edtEmailCad.Text,
                                         edtNomeCad.Text,
                                         edtEnderecoCad.Text,
                                         edtBairroCad.Text,
                                         edtCidadeCad.Text,
                                         edtUfCad.Text,
                                         edtCepCad.Text);
         end;
      end

   end);

   T.OnTerminate := ThreadLoginTerminate;
   T.Start;
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
      with DmUsuario.TabUsuario do
      begin
         if RecordCount > 0 then
         begin
            DmUsuario.SalvarUsuarioLocal(fieldbyname('id_usuario').AsInteger,
                                         fieldbyname('email').AsString,
                                         fieldbyname('nome').AsString,
                                         fieldbyname('endereco').AsString,
                                         fieldbyname('bairro').AsString,
                                         fieldbyname('cidade').AsString,
                                         fieldbyname('uf').AsString,
                                         fieldbyname('cep').AsString);
         end;
      end;

   end);

   T.OnTerminate := ThreadLoginTerminate;
   T.Start;
end;

end.
