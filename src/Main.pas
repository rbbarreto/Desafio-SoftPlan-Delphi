unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TfMain = class(TForm)
    btDatasetLoop: TButton;
    btThreads: TButton;
    btStreams: TButton;
    procedure btDatasetLoopClick(Sender: TObject);
    procedure btStreamsClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btThreadsClick(Sender: TObject);
  private
  public
  end;

var
  fMain: TfMain;

implementation

uses
  DatasetLoop, ClienteServidor, Threads;

{$R *.dfm}

procedure TfMain.btDatasetLoopClick(Sender: TObject);
begin
  Application.CreateForm(TfDatasetLoop, fDatasetLoop);
  fDatasetLoop.Show;
end;

procedure TfMain.btStreamsClick(Sender: TObject);
begin
  Application.CreateForm(TfClienteServidor, fClienteServidor);
  fClienteServidor.Show;
end;


procedure TfMain.btThreadsClick(Sender: TObject);
begin
  Application.CreateForm(TfThreads, fThreads);
  fThreads.Show;
end;

procedure TfMain.FormCreate(Sender: TObject);
begin
  ReportMemoryLeaksOnShutdown := true;
end;


end.
