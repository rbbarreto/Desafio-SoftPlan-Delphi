unit Gerenciador.Exception;

interface

uses
  System.SysUtils;

type
  TGerenciandoException = class
    private
      FLogFile : string;
    public
      constructor create;
      procedure TrataException(Sender : TObject; E: Exception);
      procedure GravaLog(Value: string);

  end;


implementation

uses
  Vcl.Forms, System.Classes, Vcl.Dialogs;

{ TGerenciandoException }

constructor TGerenciandoException.create;
begin
  FLogFile := ChangeFileExt(ParamStr(0), '.log');
  Application.OnException  := TrataException;
end;

procedure TGerenciandoException.GravaLog(Value: string);
var
  ArqLog: TextFile;
begin
  AssignFile(ArqLog, FLogFile);

  if FileExists(FLogFile) then
      Append(ArqLog)
   else
     Rewrite(ArqLog);

  Writeln(ArqLog, FormatDateTime('dd/mm/yy hh:nn:ss - ', Now) + Value);
  CloseFile(ArqLog);
end;

procedure TGerenciandoException.TrataException(Sender: TObject; E: Exception);
begin
  GravaLog('=========================================================');
  if TComponent(Sender) is TForm then
   begin
     GravaLog('Form: ' + TForm(Sender).Name);
     GravaLog('Caption: ' + TForm(Sender).Caption);
     GravaLog('ClassName: ' + E.ClassName);
     GravaLog('Erro: ' + E.Message);
   end else
   begin
     GravaLog('Form: ' + TForm(TComponent(Sender).Owner).Name);
     GravaLog('Caption: ' + TForm(TComponent(Sender).Owner).Caption);
     GravaLog('ClasseName: '+ E.ClassName);
     GravaLog('Erro: ' + E.Message);
   end;

 showMessage(E.Message);
end;

var
  TrataException : TGerenciandoException;

initialization
  TrataException := TGerenciandoException.create;

finalization
  TrataException.Free;

end.
