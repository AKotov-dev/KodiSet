program kodiset;

{$mode objfpc}{$H+}

uses
 {$IFDEF UNIX}
  cthreads,
   {$ENDIF} {$IFDEF HASAMIGA}
  athreads,
   {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms,
  Unit1 { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Title:='KodiSet v0.1';
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
