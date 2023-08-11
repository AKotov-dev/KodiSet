unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  DefaultTranslator, Buttons, IniPropStorage, ComCtrls, ExtCtrls, Process, ClipBrd;

type

  { TMainForm }

  TMainForm = class(TForm)
    ApplyBtn: TSpeedButton;
    ApplyBtn1: TSpeedButton;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    DeleteBtn: TSpeedButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Image1: TImage;
    IniPropStorage1: TIniPropStorage;
    Label1: TLabel;
    Label10: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    PageControl1: TPageControl;
    StaticText1: TStaticText;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    procedure ApplyBtn1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure CheckBox5Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ApplyBtnClick(Sender: TObject);
    procedure DeleteBtnClick(Sender: TObject);
    procedure SetDefault;
  private

  public

  end;

var
  MainForm: TMainForm;
  buffer: ansistring;

resourcestring
  SApplyMsg = 'Restart your Kodi...';
  SYouTubeNotFound = 'YouTube plugin not installed!';
  SKodiNotInstalled = 'Kodi not installed!';

implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.SetDefault;
begin
  if not FileExists(GetUserDir + '.kodi/userdata/advancedsettings.xml') then
  begin
    Button1.Click;
    Button2.Click;

    CheckBox5.Checked := False;
    CheckBox1.Checked := False;
    CheckBox2.Checked := False;
    CheckBox6.Checked := False;
    DeleteBtn.Enabled := False;
  end
  else
    DeleteBtn.Enabled := True;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  MainForm.Caption := Application.Title;

  //Настройки редактора
  if not DirectoryExists(GetUserDir + '.config') then MkDir(GetUserDir + '.config');
  IniPropStorage1.IniFileName := GetUserDir + '.config/adeditor.ini';
end;

//Poster >= v18
procedure TMainForm.CheckBox5Change(Sender: TObject);
begin
  if CheckBox5.Checked then
  begin
    Edit1.Text := '9999';
    Edit2.Text := '9999';
    Edit1.Enabled := False;
    Edit2.Enabled := False;
    CheckBox1.Checked := True;
    CheckBox2.Checked := True;
    CheckBox1.Enabled := False;
    CheckBox2.Enabled := False;
    Button1.Enabled := False;
    Button2.Enabled := False;
  end
  else
  begin
    Edit1.Enabled := True;
    Edit2.Enabled := True;
    CheckBox1.Enabled := True;
    CheckBox2.Enabled := True;
    Button1.Enabled := True;
    Button2.Enabled := True;
    Button1.Click;
    Button2.Click;
  end;
end;


procedure TMainForm.Button1Click(Sender: TObject);
begin
  Edit1.Text := '720';
  CheckBox1.Checked := True;
end;

//Apply YouTube Settings
procedure TMainForm.ApplyBtn1Click(Sender: TObject);
var
  S: TStringList;
begin
  try
    S := TStringList.Create;
    S.Add('{');
    S.Add('    "keys": {');
    S.Add('        "developer": {},');
    S.Add('        "personal": {');
    S.Add('            "api_key": "' + Trim(Edit3.Text) + '",');
    S.Add('            "client_id": "' + Trim(Edit5.Text) + '",');
    S.Add('            "client_secret": "' + Trim(Edit6.Text) + '"');
    S.Add('        }');
    S.Add('    }');
    S.Add('}');

    S.SaveToFile(GetUserDir +
      '.kodi/userdata/addon_data/plugin.video.youtube/api_keys.json');

    MessageDlg(SApplyMsg, mtInformation, [mbOK], 0);
  finally
    S.Free;
  end;
end;

procedure TMainForm.Button2Click(Sender: TObject);
begin
  Edit2.Text := '1080';
  CheckBox2.Checked := True;
end;

//Paste api_key
procedure TMainForm.Button3Click(Sender: TObject);
begin
  Edit3.SetFocus;
  Edit3.Text := ClipBoard.AsText;
  Edit3.SelLength := 0;
  Edit3.SelStart := Length(Edit3.Text);
end;

//Paste client_id
procedure TMainForm.Button4Click(Sender: TObject);
begin
  Edit5.SetFocus;
  Edit5.Text := ClipBoard.AsText;
  Edit5.SelLength := 0;
  Edit5.SelStart := Length(Edit5.Text);
end;

//Paste client_secret
procedure TMainForm.Button5Click(Sender: TObject);
begin
  Edit6.SetFocus;
  Edit6.Text := ClipBoard.AsText;
  Edit6.SelLength := 0;
  Edit6.SelStart := Length(Edit6.Text);
end;

procedure TMainForm.Button6Click(Sender: TObject);
begin
  Edit3.SetFocus;
  Edit3.Clear;
end;

procedure TMainForm.Button7Click(Sender: TObject);
begin
  Edit5.SetFocus;
  Edit5.Clear;
end;

procedure TMainForm.Button8Click(Sender: TObject);
begin
  Edit6.SetFocus;
  Edit6.Clear;
end;

procedure TMainForm.FormShow(Sender: TObject);
var
  S: ansistring;
begin
  //KDE DPI
  IniPropStorage1.Restore;

  Button6.Width := Button6.Height;
  Button7.Width := Button7.Height;
  Button8.Width := Button8.Height;

  if DirectoryExists(GetUserDir + '.kodi') then
  begin
    //Новый файл настроек Kodi
    Label1.Caption := GetUserDir + '.kodi/userdata/advancedsettings.xml';

    if not FileExists(Label1.Caption) then
      DeleteBtn.Enabled := False
    else
      DeleteBtn.Enabled := True;


    //Poster like v18
    if RunCommand('/bin/bash',
      ['-c', '[[ $(grep "<imageres>9999</imageres>" ~/.kodi/userdata/advancedsettings.xml) ]] && '
      + '[[ $(grep "<fanartres>9999</fanartres>" ~/.kodi/userdata/advancedsettings.xml) ]] && echo "yes"'], S) then
      if Trim(S) = 'yes' then
        CheckBox5.Checked := True;

    //imageres
    if RunCommand('/bin/bash',
      ['-c', 'grep "imageres" ~/.kodi/userdata/advancedsettings.xml | cut -f2 -d">" | cut -f1 -d "<"'],
      S) then
      if Trim(S) <> '' then
      begin
        CheckBox1.Checked := True;
        Edit1.Text := Trim(S);
      end
      else
        CheckBox1.Checked := False;

    //fanartres
    if RunCommand('/bin/bash',
      ['-c', 'grep "fanartres" ~/.kodi/userdata/advancedsettings.xml | cut -f2 -d">" | cut -f1 -d "<"'],
      S) then
      if Trim(S) <> '' then
      begin
        CheckBox2.Checked := True;
        Edit2.Text := Trim(S);
      end
      else
        CheckBox2.Checked := False;

    //Video Buffer (1/3 RAM)
    if RunCommand('/bin/bash',
      ['-c', 'grep "<cache>" ~/.kodi/userdata/advancedsettings.xml'], S) then
      if Trim(S) <> '' then
        CheckBox6.Checked := True
      else
        CheckBox6.Checked := False;

    //Определяем видеобуфер для stream
    RunCommand('/bin/bash',
      ['-c', 'expr $(free -b | grep Mem: | awk ' + '''' + '{print $2}' + '''' + ') / 3'],
      buffer);
  end
  else
  begin
    Label1.Caption := SKodiNotInstalled;
    TabSheet1.Enabled := False;
  end;


  //YouTube Plugin installed?
  if FileExists(GetUserDir +
    '.kodi/userdata/addon_data/plugin.video.youtube/api_keys.json') then
  begin
    Label10.Caption := GetUserDir +
      '.kodi/userdata/addon_data/plugin.video.youtube/api_keys.json';

    //api_key
    if RunCommand('/bin/bash',
      ['-c', 'grep "api_key" ~/.kodi/userdata/addon_data/plugin.video.youtube/api_keys.json | cut -f4 -d"\""'], S) then
      Edit3.Text := Trim(S);
    //client_id
    if RunCommand('/bin/bash',
      ['-c', 'grep "client_id" ~/.kodi/userdata/addon_data/plugin.video.youtube/api_keys.json | cut -f4 -d"\""'], S) then
      Edit5.Text := Trim(S);
    //client_secret
    if RunCommand('/bin/bash',
      ['-c', 'grep "client_secret" ~/.kodi/userdata/addon_data/plugin.video.youtube/api_keys.json | cut -f4 -d"\""'], S) then
      Edit6.Text := Trim(S);
  end
  else
  begin
    Label10.Caption := SYouTubeNotFound;
    TabSheet2.Enabled := False;
  end;
end;


//Clear Thumbnails and Apply
procedure TMainForm.ApplyBtnClick(Sender: TObject);
var
  S: ansistring;
  F: TStringList;
begin
  if not (CheckBox1.Checked or CheckBox2.Checked or CheckBox5.Checked or
    CheckBox6.Checked) then
  begin
    if DeleteBtn.Enabled then DeleteBtn.Click;
    Exit;
  end;

  try
    F := TStringList.Create;

    F.Add('<advancedsettings version="1.0">');
    F.Add('');
    if CheckBox1.Checked then
      F.Add('    <imageres>' + Trim(Edit1.Text) + '</imageres>');
    if CheckBox2.Checked then
      F.Add('    <fanartres>' + Trim(Edit2.Text) + '</fanartres>');
    if CheckBox6.Checked then
    begin
      F.Add('');
      F.Add('     <cache>');
      F.Add('          <memorysize>' + Trim(buffer) + '</memorysize>');
      F.Add('          <buffermode>2</buffermode>');
      F.Add('     </cache>');
    end;
    F.Add('');
    F.Add('</advancedsettings>');

    //Save
    F.SaveToFile(GetUserDir + '.kodi/userdata/advancedsettings.xml');

    //Clear Thumbnails
    RunCommand('/bin/bash',
      ['-c', 'find ~/.kodi/userdata/Thumbnails -type f -exec rm -rf {} \;'], S);

    SetDefault;

    MessageDlg(SApplyMsg, mtInformation, [mbOK], 0);
  finally
    F.Free;
  end;
end;

//Delete settings
procedure TMainForm.DeleteBtnClick(Sender: TObject);
begin
  if DeleteFile(GetUserDir + '.kodi/userdata/advancedsettings.xml') then SetDefault;
  ShowMessage(SApplyMsg);
end;

end.
