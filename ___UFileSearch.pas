unit UFileSearch;

interface

uses Windows, SysUtils;

type
  TOnSearchEvent = function(const SearchRec: TSearchRec; const FullName: string): Boolean;

  TFileSearch = class
    Folder: string;
    Mask: string;
    Attr: Integer;
    OnSearch: TOnSearchEvent;
    Recursive: Boolean;
    function SearchIn(Folder: string): Boolean;
    procedure SearchAll;
  end;

implementation

function TFileSearch.SearchIn(Folder: string): Boolean;
var
  SearchRec: TSearchRec;
begin
  Result := False;
  //Поиск файлов
  if FindFirst(Folder + '\' + Mask, Attr, SearchRec) = 0 then
  begin
    repeat
      if ((Attr <> 16) and ((SearchRec.Attr and faDirectory) = 0)) or
        ((Attr = 16) and ((SearchRec.Attr and Attr) <> 0) and
        (SearchRec.Name <> '.') and (SearchRec.Name <> '..')) then
      begin
        if Assigned(OnSearch) then
        begin
          if OnSearch(SearchRec, Folder + '\' + SearchRec.Name) = True then
          begin
            Result := True;
            Exit;
          end;
        end;
      end;
    until FindNext(SearchRec) <> 0;
  end;
  FindClose(SearchRec);

  //Поиск папок
  if Recursive then
  begin
    if FindFirst(Folder + '\*.*', faDirectory, SearchRec) = 0 then
    begin
      repeat
        if ((SearchRec.Attr and faDirectory) <> 0) and
          (SearchRec.Name <> '.') and (SearchRec.Name <> '..') then
        begin
          if SearchIn(Folder + '\' + SearchRec.Name) = True then
          begin
            Result := True;
            Exit;
          end;
        end;
      until FindNext(SearchRec) <> 0;
    end;
    FindClose(SearchRec);
  end;
end;

procedure TFileSearch.SearchAll;
begin
  SearchIn(Folder);
end;

end.

