unit Unit2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Fileutil, shlobj, registry;

function getDirs(directory : string): TStringList ;
function findAllProfiles() : TStringList;
function URLDecode(url: string): String;
function getCurrentProfile(): string;
procedure setCurrentProfile(profileName: string);

implementation
  function findAllProfiles() : TStringList;
  var
    MyDocs: Array[0..MaxPathLen] of Char;
    counter: Integer;
    totalItems: Integer;
    profileDir: String;
  begin
    //Create our result
    Result := TStringList.create;

    //Locate the profile folder
    MyDocs := '';
    SHGetSpecialFolderPath(0,MyDocs,CSIDL_PERSONAL,false);
    profileDir := MyDocs + '\ArmA 2 Other Profiles\';

    //Make sure the profile directory exists
    if (DirectoryExists(profileDir) = false) then
    begin
      raise Exception.Create('Cant find profile directory!');
    end;

    //Get a list of everything in the profile folder
    Result := getDirs(profileDir);

    //URL Decode all of these names
    totalItems := Result.Count;
    counter := 0;
    while (counter < totalItems) do
    begin
      Result.strings[counter] := URLDecode(Result.strings[counter]);
      counter := counter + 1;
    end;

    //Return the result
    Result := Result;
  end;

  function getDirs(directory : string): TStringList;
    var
      item : TSearchRec;
    begin
      Result := TStringList.create;
    try
      if FindFirst(IncludeTrailingPathDelimiter(directory) + '*.*', faDirectory, item) < 0 then
        Exit
      else
        repeat
          if ((item.Attr and faDirectory <> 0) AND (item.Name <> '.') AND (item.Name <> '..')) then
            Result.Add(item.Name) ;
        until FindNext(item) <> 0;
    finally
      SysUtils.FindClose(item) ;
    end;
  end;

  function URLDecode(url: string): String;
  begin
    url := StringReplace(url, '%20', ' ', [rfReplaceAll,rfIgnoreCase]);
    url := StringReplace(url, '%21', '!', [rfReplaceAll,rfIgnoreCase]);
    url := StringReplace(url, '%23', '#', [rfReplaceAll,rfIgnoreCase]);
    url := StringReplace(url, '%24', '$', [rfReplaceAll,rfIgnoreCase]);
    url := StringReplace(url, '%26', '&', [rfReplaceAll,rfIgnoreCase]);
    //url := StringReplace(url, '%27', '', [rfReplaceAll,rfIgnoreCase]);  Will implement later Should be '
    url := StringReplace(url, '%28', '(', [rfReplaceAll,rfIgnoreCase]);
    url := StringReplace(url, '%29', ')', [rfReplaceAll,rfIgnoreCase]);
    url := StringReplace(url, '%2A', '*', [rfReplaceAll,rfIgnoreCase]);
    url := StringReplace(url, '%2B', '+', [rfReplaceAll,rfIgnoreCase]);
    url := StringReplace(url, '%2C', ',', [rfReplaceAll,rfIgnoreCase]);
    url := StringReplace(url, '%2F', '/', [rfReplaceAll,rfIgnoreCase]);
    url := StringReplace(url, '%3A', ':', [rfReplaceAll,rfIgnoreCase]);
    url := StringReplace(url, '%3B', ';', [rfReplaceAll,rfIgnoreCase]);
    url := StringReplace(url, '%3D', '=', [rfReplaceAll,rfIgnoreCase]);
    url := StringReplace(url, '%3F', '?', [rfReplaceAll,rfIgnoreCase]);
    url := StringReplace(url, '%40', '@', [rfReplaceAll,rfIgnoreCase]);
    url := StringReplace(url, '%5B', '[', [rfReplaceAll,rfIgnoreCase]);
    url := StringReplace(url, '%5D', ']', [rfReplaceAll,rfIgnoreCase]);
    url := StringReplace(url, '%22', '"', [rfReplaceAll,rfIgnoreCase]);
    url := StringReplace(url, '%25', '%', [rfReplaceAll,rfIgnoreCase]);
    url := StringReplace(url, '%2D', '-', [rfReplaceAll,rfIgnoreCase]);
    url := StringReplace(url, '%2E', '.', [rfReplaceAll,rfIgnoreCase]);
    url := StringReplace(url, '%3C', '<', [rfReplaceAll,rfIgnoreCase]);
    url := StringReplace(url, '%3E', '>', [rfReplaceAll,rfIgnoreCase]);
    url := StringReplace(url, '%5C', '\', [rfReplaceAll,rfIgnoreCase]);
    url := StringReplace(url, '%5E', '^', [rfReplaceAll,rfIgnoreCase]);
    url := StringReplace(url, '%5F', '_', [rfReplaceAll,rfIgnoreCase]);
    url := StringReplace(url, '%60', '`', [rfReplaceAll,rfIgnoreCase]);
    url := StringReplace(url, '%7B', '{', [rfReplaceAll,rfIgnoreCase]);
    url := StringReplace(url, '%7C', '|', [rfReplaceAll,rfIgnoreCase]);
    url := StringReplace(url, '%7D', '}', [rfReplaceAll,rfIgnoreCase]);
    url := StringReplace(url, '%7E', '~', [rfReplaceAll,rfIgnoreCase]);
    Result := url;
  end;

  function getCurrentProfile(): string;
  var
    HKCU: TRegistry;
  begin
    Result := '';
    HKCU := TRegistry.Create;
    try
      HKCU.RootKey := HKEY_CURRENT_USER;
      if (HKCU.OpenKeyReadOnly('\SOFTWARE\Bohemia Interactive Studio\ArmA 2 OA')) then
      begin
        Result := HKCU.ReadString('Player Name');
      end;
    finally
      HKCU.free;
    end;
  end;

  procedure setCurrentProfile(profileName: string);
  var
    HKCU: TRegistry;
  begin
    HKCU := TRegistry.Create;
    try
      if (HKCU.OpenKey('\SOFTWARE\Bohemia Interactive Studio\ArmA 2 OA', true)) then
      begin
        HKCU.WriteString('Player Name', profileName);
      end
      else
      begin
        raise Exception.Create('Could not write new profile!');
      end;
    finally
      HKCU.free;
    end;
  end;

end.

