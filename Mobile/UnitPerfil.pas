unit UnitPerfil;

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
  FMX.Edit,
  uLoading,
  uSession;

type
  TFrmPerfil = class(TForm)
    lytToolbar: TLayout;
    lblTitulo: TLabel;
    imgVoltar: TImage;
    imgSalvar: TImage;
    Layout3: TLayout;
    Layout4: TLayout;
    Rectangle9: TRectangle;
    edtUf: TEdit;
    Rectangle8: TRectangle;
    edtCidade: TEdit;
    Rectangle6: TRectangle;
    edtEndereco: TEdit;
    Rectangle7: TRectangle;
    edtBairro: TEdit;
    Rectangle10: TRectangle;
    edtCep: TEdit;
    Rectangle1: TRectangle;
    edtNome: TEdit;
    Rectangle2: TRectangle;
    edtEmail: TEdit;
    Rectangle3: TRectangle;
    edtSenha: TEdit;
    procedure FormShow(Sender: TObject);
    procedure imgSalvarClick(Sender: TObject);
    procedure imgVoltarClick(Sender: TObject);
  private
    procedure CarregarDados;
    procedure ThreadDadosTerminate(Sender: TObject);
    procedure ThreadSalvarTerminate(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPerfil: TFrmPerfil;

implementation

uses
  DataModule.Usuario, UnitPrincipal;

{$R *.fmx}

procedure TFrmPerfil.FormShow(Sender: TObject);
begin
  CarregarDados;
end;

procedure TFrmPerfil.imgSalvarClick(Sender: TObject);
var
   T : TThread;
   foto : TBitmap;
begin
   TLoading.Show(FrmPerfil, '');

   T := TThread.CreateAnonymousThread(procedure
   begin
      // Salvar dados do usuario...
      DmUsuario.EditarUsuario(TSession.ID_USUARIO,
                              edtNome.Text,
                              edtEmail.Text,
                              edtSenha.Text,
                              edtEndereco.Text,
                              edtBairro.Text,
                              edtCidade.Text,
                              edtUf.Text,
                              edtCep.Text);

      // Salvar dados do usuario Localmente...
      DmUsuario.SalvarUsuarioLocal(TSession.ID_USUARIO,
                                   edtEmail.Text,
                                   edtNome.Text,
                                   edtEndereco.Text,
                                   edtBairro.Text,
                                   edtCidade.Text,
                                   edtUf.Text,
                                   edtCep.Text);

      FrmPrincipal.lblMenuEmail.Text := edtEmail.Text;
      FrmPrincipal.lblMenuNome.Text  := edtNome.Text;

   end);

   T.OnTerminate := ThreadSalvarTerminate;
   T.Start;
end;

procedure TFrmPerfil.imgVoltarClick(Sender: TObject);
begin
   Close;
end;

procedure TFrmPerfil.ThreadSalvarTerminate(Sender: TObject);
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

   Close;
end;

procedure TFrmPerfil.CarregarDados;
var
   T : TThread;
   foto : TBitmap;
begin
   TLoading.Show(FrmPerfil, '');

   T := TThread.CreateAnonymousThread(procedure
   begin
      // Buscar dados do usuario...
      DmUsuario.ListarUsuarioId(TSession.ID_USUARIO);

      with DmUsuario.TabUsuario do
      begin
         TThread.Synchronize(TThread.CurrentThread, procedure
         begin
            edtNome.Text      := fieldbyname('nome').asstring;
            edtEmail.Text     := fieldbyname('email').asstring;
            edtSenha.Text     := fieldbyname('senha').asstring;
            edtEndereco.Text  := fieldbyname('endereco').AsString;
            edtBairro.Text    := fieldbyname('bairro').asstring;
            edtCidade.Text    := fieldbyname('cidade').asstring;
            edtUF.Text        := fieldbyname('uf').asstring;
            edtCEP.Text       := fieldbyname('cep').asstring;
         end);
      end;
   end);

   T.OnTerminate := ThreadDadosTerminate;
   T.Start;
end;

procedure TFrmPerfil.ThreadDadosTerminate(Sender: TObject);
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

end.
