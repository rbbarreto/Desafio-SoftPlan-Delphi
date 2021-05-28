unit Threads;

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
  system.Threading;

type
  TProcesso = class(TThread)
  private
    FMemo : TMemo;
    FProgress : TProgressBar;
    FAxu : string;
    FFinal : string;
    FMSegundo: Integer;
    QtdExecutar: Integer;
  public
    constructor create(aMemo: TMemo; aProgress: TProgressBar; aMiliSegundo: Integer; aQtd: Integer); reintroduce;
    procedure Execute; override;
    procedure Sincronizar;
  end;

  TfThreads = class(TForm)
    NumeroThread: TEdit;
    edtTempo: TEdit;
    Button1: TButton;
    ProgressBar1: TProgressBar;
    Memo1: TMemo;
    Label1: TLabel;
    Label2: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    Processo : TProcesso;
  public
    { Public declarations }
  end;

var
  fThreads: TfThreads;

const
  CONST_VALOR_MAX = 100;

implementation

{$R *.dfm}

uses
  system.SyncObjs;

procedure TfThreads.Button1Click(Sender: TObject);
begin
  Processo := TProcesso.create(Memo1,
                      ProgressBar1,
                      StrToInt(edtTempo.Text),
                      StrToInt(NumeroThread.Text));
  Processo.Start;

end;


{ TProcesso }

constructor TProcesso.create(aMemo: TMemo; aProgress: TProgressBar; aMiliSegundo: Integer; aQtd: Integer);
begin
  inherited create(True);
  Self.FreeOnTerminate := True;
  Self.FMemo := aMemo;;
  Self.FProgress := aProgress;
  Self.FMSegundo := aMiliSegundo;
  Self.QtdExecutar := aQtd;
end;

procedure TProcesso.Execute;
var
  i, qtd : Integer;
  lRandom: Integer;
begin
  inherited;

  FProgress.Max := CONST_VALOR_MAX;
  Self.FMemo.Clear;


  for qtd := 0 to pred(QtdExecutar)  do
     begin
        FProgress.Position := 0;
        FMemo.Lines.Clear;

        for I := 0 to Pred(CONST_VALOR_MAX) do
         begin
            if Self.Terminated then Break;

            Sleep(FMSegundo);
            FProgress.Position := FProgress.Position + 1;

            lRandom := Random(1024);
            FAxu := lRandom.ToString + ' - Iniciando processamento';

            lRandom := Random(1024);
            FFinal :=  lRandom.ToString + '- Processamento Finalizado';

            Self.Queue(Self.Sincronizar);

            if (i = CONST_VALOR_MAX) then
                Self.Terminate;
         end;
     end;
end;

procedure TProcesso.Sincronizar;
begin
  if not(FAxu.IsEmpty) then
    FMemo.Lines.Add(FAxu);

  if not(FFinal.IsEmpty) then
   FMemo.Lines.Add(FFinal);
end;

procedure TfThreads.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 if Processo <> nil then
   if not (Processo.Terminated)  then
     begin
       Action := caNone;
       ShowMessage('Existem um processo em andamento. Ele seá parado');
       Processo.Terminate;
     end;
end;

end.
