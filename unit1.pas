unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  StdCtrls, Unit2;

type

  { TForm1 }

  TForm1 = class(TForm)
    executeBtn: TButton;
    profileList: TComboBox;
    cProfileLbl: TLabel;
    nProfileLbl: TLabel;
    current: TLabel;
    procedure executeBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;
  Test: TStringList;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormShow(Sender: TObject);
var
  currentProfile: String;
begin
  //Read the current profile
    currentProfile := getCurrentProfile();

    if (currentProfile = '') then
    begin
      ShowMessage('There was a problem loading the current profile!');
      halt;
    end;

  //Get and set it to our list of profiles
  try
    profileList.items := findAllProfiles();
    profileList.ItemIndex := 0;
  except
    ShowMessage('There was a problem loading the profile list!');
    halt;
  end;

  //Set the current profile
    current.caption := currentProfile;
end;

procedure TForm1.executeBtnClick(Sender: TObject);
var
  currentProfile: String;
begin
  //Get the current profile
  currentProfile := profileList.Items[profileList.ItemIndex];

  //Set the profile
  setCurrentProfile(currentProfile);

  ShowMessage('Profile Switched!');

  current.caption := currentProfile;
end;

end.

