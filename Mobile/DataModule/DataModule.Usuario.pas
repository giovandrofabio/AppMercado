unit DataModule.Usuario;

interface

uses
  System.SysUtils,
  System.Classes,
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
  DataSet.Serialize.Config,
  RESTRequest4D,
  System.JSON,
  uConsts;

type
  TDmUsuario = class(TDataModule)
    TabUsuario: TFDMemTable;
    procedure DataModuleCreate(Sender: TObject);
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
