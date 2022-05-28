unit DataModule.Usuario;

interface

uses
  System.SysUtils,
  System.Classes,
  System.IOUtils,

  Data.DB,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Param,
  FireDAC.Stan.Error,
  FireDAC.DatS,
  FireDAC.Phys.Intf,
  FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  FireDAC.UI.Intf,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.Phys,
  FireDAC.FMXUI.Wait,

  DataSet.Serialize.Config,
  RESTRequest4D,
  System.JSON,
  uConsts, FireDAC.DApt, FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteDef,
  FireDAC.Phys.SQLite;


type
  TDmUsuario = class(TDataModule)
    TabUsuario: TFDMemTable;
    conn: TFDConnection;
    QryGeral: TFDQuery;
    FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink;
    procedure DataModuleCreate(Sender: TObject);
    procedure connBeforeConnect(Sender: TObject);
    procedure connAfterConnect(Sender: TObject);
  private
    { Private declarations }
  public
    procedure Login(email, senha: string);
    procedure CriarConta(nome, email, senha, endereco, bairro, cidade, uf,
      cep: string);
    { Public declarations }
  end;

var
  DmUsuario: TDmUsuario;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}


procedure TDmUsuario.DataModuleCreate(Sender: TObject);
begin
   TDataSetSerializeConfig.GetInstance.CaseNameDefinition := cndLower;
   conn.Connected := true;
end;

procedure TDmUsuario.Login(email, senha: string);
var
   resp: IResponse;
   json: TJSONObject;
begin
   json := TJSONObject.Create;
   try
      json.AddPair('email',email);
      json.AddPair('senha',senha);

      resp := TRequest.New.BaseURL(BASE_URL)
              .Resource('usuarios/login')
              .DataSetAdapter(TabUsuario)
              .AddBody(json.ToJSON)
              .Accept('application/json')
              .BasicAuthentication(USER_NAME, PASSWORD)
              .Post;

      if (resp.StatusCode = 401) then
         raise Exception.Create('Usuário não autorizado')
      else if (resp.StatusCode <> 200) then
         raise Exception.Create(resp.Content);
   finally
      json.DisposeOf;
   end;
end;

procedure TDmUsuario.connAfterConnect(Sender: TObject);
begin
    conn.ExecSQL('CREATE TABLE IF NOT EXISTS ' +
                 'TAB_USUARIO(EMAIL VARCHAR(100), ' +
                 'NOME VARCHAR(100), ' +
                 'ENDERECO VARCHAR(100), ' +
                 'BAIRRO VARCHAR(100), ' +
                 'CIDADE VARCHAR(100), ' +
                 'UF VARCHAR(100), ' +
                 'CEP VARCHAR(100))');

    conn.ExecSQL('CREATE TABLE IF NOT EXISTS ' +
                 'TAB_CARRINHO(ID_MERCADO INTEGER, ' +
                 'NOME_MERCADO VARCHAR(100), ' +
                 'ENDERECO_MERCADO VARCHAR(100), ' +
                 'TAXA_ENTREGA DECIMAL(9,2))');

    conn.ExecSQL('CREATE TABLE IF NOT EXISTS ' +
                 'TAB_CARRINHO_ITEM(ID_PRODUTO INTEGER, ' +
                 'URL_FOTO VARCHAR(1000), ' +
                 'NOME VARCHAR(100), ' +
                 'UNIDADE VARCHAR(100), ' +
                 'QTD DECIMAL(9,2),' +
                 'VALOR_UNITARIO DECIMAL(9,2),' +
                 'VALOR_TOTAL DECIMAL(9,2))');
end;

procedure TDmUsuario.connBeforeConnect(Sender: TObject);
begin
   conn.DriverName := 'SQLite';

   {$IFDEF MSWINDOWS}
   conn.Params.Values['Database'] := System.SysUtils.GetCurrentDir + '\banco.db';
   {$ELSE}
   conn.Params.Values['Database'] := TPath.Combine(TPath.GetDocumentsPath, 'banco.db');
   {$ENDIF}
end;

procedure TDmUsuario.CriarConta(nome, email, senha, endereco, bairro,
                                cidade, uf, cep : string);
var
   resp: IResponse;
   json: TJSONObject;
begin
   json := TJSONObject.Create;
   try
      json.AddPair('nome',nome);
      json.AddPair('email',email);
      json.AddPair('senha',senha);
      json.AddPair('endereco',endereco);
      json.AddPair('bairro',bairro);
      json.AddPair('cidade',cidade);
      json.AddPair('uf',uf);
      json.AddPair('cep',cep);

      resp := TRequest.New.BaseURL(BASE_URL)
              .Resource('usuarios/cadastro')
              .DataSetAdapter(TabUsuario)
              .AddBody(json.ToJSON)
              .Accept('application/json')
              .BasicAuthentication(USER_NAME, PASSWORD)
              .Post;

      if (resp.StatusCode = 401) then
         raise Exception.Create('E-meail ou Senha inválida')
      else if (resp.StatusCode <> 201) then
         raise Exception.Create(resp.Content);
   finally
      json.DisposeOf;
   end;
end;

end.
