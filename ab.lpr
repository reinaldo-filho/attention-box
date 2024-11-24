program ab;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  Dialogs,
  Forms, Interfaces, Windows,
  Border;

{$R *.res}

var
  Ex : Integer;

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;

  // não mostra na barra de tarefas
  Ex:= GetWindowLong(FindWindow(nil, 'ab'), GWL_EXSTYLE);
  SetWindowLong(FindWindow(nil, 'ab'),GWL_EXSTYLE, Ex or WS_EX_TOOLWINDOW and not WS_EX_APPWINDOW);

  if ParamCount = 0 then
  begin
    ShowMessage('Parameters:'+#13+'-x <X>'+#13+'-y <Y>'+#13+'-w <Width>'+#13+
    '-h <Height>'+#13+'-b <Border Width>'+#13+'-c <Border Color>'+#13+
    '-t <Countdown ms>'+#13+'-k <Blink every ms>'+#13+'-s <Silent>');
    Halt;
  end;

  Application.CreateForm(TfrmBorder, frmBorder);
  Application.Run;
end.

