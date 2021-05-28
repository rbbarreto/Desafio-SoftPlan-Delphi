unit ClienteServidor;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.ComCtrls,
  Vcl.StdCtrls,
  Datasnap.DBClient,
  Data.DB;


type
  TServidor = class
  private
   // FPath: AnsiString;
    FPath: string;
  public
    constructor Create;
    //Tipo do parâmetro não pode ser alterado
    function SalvarArquivos(AData: OleVariant): Boolean;
  end;

  TfClienteServidor = class(TForm)
    ProgressBar: TProgressBar;
    btEnviarSemErros: TButton;
    btEnviarComErros: TButton;
    btEnviarParalelo: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btEnviarSemErrosClick(Sender: TObject);
    procedure btEnviarComErrosClick(Sender: TObject);
    procedure btEnviarParaleloClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
   // FPath: AnsiString;
    FPath : string;
    FServidor: TServidor;

    function InitDataset: TClientDataset;
    procedure DeletarRegistros(aArquivos: string);
  public
  end;

var
  fClienteServidor: TfClienteServidor;

const
  QTD_ARQUIVOS_ENVIAR = 100;

implementation

uses
  IOUtils, Gerenciador.Exception, System.Threading;

{$R *.dfm}

procedure TfClienteServidor.btEnviarComErrosClick(Sender: TObject);
var
  cds: TClientDataset;
  i: Integer;
begin

  ProgressBar.Max := QTD_ARQUIVOS_ENVIAR;
  ProgressBar.Position := 0;

  for i := 0 to QTD_ARQUIVOS_ENVIAR do
  begin
    cds := InitDataset;
    ProgressBar.Position := ProgressBar.Position + 1;

    cds.Append;
    TBlobField(cds.FieldByName('Arquivo')).LoadFromFile(FPath);
    cds.Post;

    try
      {$REGION Simulação de erro, não alterar}
      if i = (QTD_ARQUIVOS_ENVIAR/2) then
        FServidor.SalvarArquivos(NULL);
      {$ENDREGION}
    except on E: Exception do
       begin
         DeletarRegistros(ExtractFilePath(ParamStr(0)) + 'Servidor\');
         cds.Free;
       end;
    end;

    FServidor.SalvarArquivos(cds.Data);

    cds.Free;
  end;
end;

procedure TfClienteServidor.btEnviarParaleloClick(Sender: TObject);
var
  cds: TClientDataset;
begin
  ProgressBar.Max := QTD_ARQUIVOS_ENVIAR;
  ProgressBar.Position := 0;

  TTask.Run(
  procedure
  begin
   TParallel.&For(1, QTD_ARQUIVOS_ENVIAR,
     procedure(index : Integer)
     begin
       Sleep(200);
       TThread.Queue(nil,
       procedure
       begin
         cds := InitDataset;

         cds.Append;
         TBlobField(cds.FieldByName('Arquivo')).LoadFromFile(FPath);
         cds.Post;

         ProgressBar.Position := ProgressBar.Position + 1;
         FServidor.SalvarArquivos(cds.Data);

         cds.Free;
       end);
     end);

  end);

end;

procedure TfClienteServidor.btEnviarSemErrosClick(Sender: TObject);
var
  cds: TClientDataset;
  i: Integer;
begin

  ProgressBar.Max := QTD_ARQUIVOS_ENVIAR;

  for i := 0 to QTD_ARQUIVOS_ENVIAR do
  begin
    cds := InitDataset;
    ProgressBar.Position := ProgressBar.Position + 1;
    cds.Append;
    TBlobField(cds.FieldByName('Arquivo')).LoadFromFile(FPath);
    cds.Post;

    FServidor.SalvarArquivos(cds.Data);
    cds.Free;
  end;

end;

procedure TfClienteServidor.DeletarRegistros(aArquivos: string);
var
  SR: TSearchRec;
  I: integer;
begin
  I := FindFirst(aArquivos + '*.*', faAnyFile, SR);
  while I = 0 do
  begin
    if (SR.Attr and faDirectory) <> faDirectory then
    begin
      if not DeleteFile(PChar(aArquivos + SR.Name)) then
        Exit;
    end;

    I := FindNext(SR);
  end;
end;

procedure TfClienteServidor.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  FreeAndNil(FServidor);
end;

procedure TfClienteServidor.FormCreate(Sender: TObject);
begin
  inherited;
  FPath := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'pdf.pdf';
  //FPath := IncludeTrailingBackslash(ExtractFilePath(ParamStr(0))) + 'pdf.pdf';
  FServidor := TServidor.Create;
end;

function TfClienteServidor.InitDataset: TClientDataset;
begin
  Result := TClientDataset.Create(nil);
  Result.FieldDefs.Add('Arquivo', ftBlob);
  Result.CreateDataSet;
end;


{ TServidor }

constructor TServidor.Create;
begin
  FPath := ExtractFilePath(ParamStr(0)) + 'Servidor\';
end;

function TServidor.SalvarArquivos(AData: OleVariant): Boolean;
var
  cds: TClientDataSet;
  FileName: string;
begin
  Result := False;

  try
    cds := TClientDataset.Create(nil);
    cds.Data := AData;

    {$REGION Simulação de erro, não alterar}
    if cds.RecordCount = 0 then
      Exit;
    {$ENDREGION}

    cds.First;

    while not cds.Eof do
    begin
      FileName := FPath + cds.RecNo.ToString + '.pdf';
      if TFile.Exists(FileName) then
        TFile.Delete(FileName);

      TBlobField(cds.FieldByName('Arquivo')).SaveToFile(FileName);
      cds.Next;
    end;

    cds.Free;

    Result := True;
  except
    raise;
  end;
end;

end.
