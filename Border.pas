unit Border;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls;

type
  TfrmBorder = class(TForm)
    Timer: TTimer;
    CloseTimer: TTimer;
    procedure CloseTimerTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
  private
    Draw: boolean;
    BWidth: integer;
    BColor: TColor;
    BTime: integer;
    CloseTime: integer;
    Silent: boolean;
  end;

var
  frmBorder: TfrmBorder;

implementation

uses Windows;

{$R *.lfm}

procedure TfrmBorder.FormCreate(Sender: TObject);
var
  ExStyle: Longint;
  i: integer;
  hexColor: string;
  R, G, B: smallint;
begin
  // valores padrão
  Draw:= True;
  Left   := 100;
  Top    := 100;
  Width  := 400;
  Height := 300;
  BWidth := 3;
  BColor := clRed;
  BTime := 0;
  CloseTime:= 0;
  Silent:= False;

  // necessário verificar Silent antes de todos os parâmetros
  for i:= 1 to ParamCount do
    if ParamStr(i) = '-s' then Silent:= True;

  // outros parâmetros
  for i:= 1 to ParamCount do
  begin
    if (i + 1) > ParamCount then
       Break;
    try
      if ParamStr(i) = '-x' then
        Left:= StrToInt(ParamStr(i + 1));
      if ParamStr(i) = '-y' then
        Top:= StrToInt(ParamStr(i + 1));
      if ParamStr(i) = '-w' then
         Width:= StrToInt(ParamStr(i + 1));
      if ParamStr(i) = '-h' then
         Height:= StrToInt(ParamStr(i + 1));
      if ParamStr(i) = '-b' then
         BWidth:= StrToInt(ParamStr(i + 1));
      if ParamStr(i) = '-t' then
         CloseTime:= StrToInt(ParamStr(i + 1));
      if ParamStr(i) = '-k' then
         BTime:= StrToInt(ParamStr(i + 1));
      if ParamStr(i) = '-c' then
      begin
        hexColor:= ParamStr(i + 1);
        if hexColor[1] = '#' then
           Delete(hexColor, 1, 1);
        if Length(hexColor) <> 6 then
        begin
          if not Silent then
             ShowMessage('Invalid color format. Use #RRGGBB ou RRGGBB.');
          Halt;
        end;

        R:= StrToInt('$' + Copy(hexColor, 1, 2));
        G:= StrToInt('$' + Copy(hexColor, 3, 2));
        B:= StrToInt('$' + Copy(hexColor, 5, 2));

        BColor:= RGBToColor(R, G, B);
      end;
    except
      if not Silent then
         ShowMessage('Incorrect parameter, please check.');
      Halt;
    end;
  end;

  // Configura o estilo da janela para permitir transparência
  ExStyle := GetWindowLong(Handle, GWL_EXSTYLE);
  SetWindowLong(Handle, GWL_EXSTYLE, ExStyle or WS_EX_LAYERED);

  // Define a cor transparente
  SetLayeredWindowAttributes(Handle, ColorToRGB(clFuchsia), 0, LWA_COLORKEY);
end;

procedure TfrmBorder.FormPaint(Sender: TObject);
begin
  if Draw then
    with Canvas do
    begin
      Pen.Color := BColor;
      Pen.Width := BWidth;
      Brush.Style := bsClear;
      Rectangle(0, 0, Width, Height);
    end;
end;

procedure TfrmBorder.FormShow(Sender: TObject);
begin
  if BTime > 0 then
  begin
    Timer.Interval:= BTime;
    Timer.Enabled:= True;
  end;

  if CloseTime > 0 then
  begin
    CloseTimer.Interval:= CloseTime;
    CloseTimer.Enabled:= True;
  end;
end;

procedure TfrmBorder.TimerTimer(Sender: TObject);
begin
  Draw:= not Draw;
  Repaint;
end;

procedure TfrmBorder.CloseTimerTimer(Sender: TObject);
begin
  Application.Terminate;
  Close;
end;

end.

