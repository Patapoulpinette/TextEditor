unit TextEditorUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.DialogService.Sync,
  FMX.Memo.Types, System.Actions, FMX.ActnList, FMX.ScrollBox, FMX.Memo,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Menus;

type
  TTextEditorForm = class(TForm)
    ActionList: TActionList;
    MainMenu: TMainMenu;
    StatusBar: TStatusBar;
    Editor: TMemo;
    OpenFileDialog: TOpenDialog;
    SaveFileDialog: TSaveDialog;
    NewAction: TAction;
    OpenAction: TAction;
    SaveAction: TAction;
    SaveAsAction: TAction;
    ExitAction: TAction;
    CutAction: TAction;
    CopyAction: TAction;
    PasteAction: TAction;
    SelectAllAction: TAction;
    UndoAction: TAction;
    DeleteAction: TAction;
    FileMenu: TMenuItem;
    EditMenu: TMenuItem;
    FormatMenu: TMenuItem;
    NewMenuItem: TMenuItem;
    OpenFileMenuItem: TMenuItem;
    SaveFileMenuItem: TMenuItem;
    SaveAsMenuItem: TMenuItem;
    ExitMenuItem: TMenuItem;
    CutMenuItem: TMenuItem;
    CopyMenuItem: TMenuItem;
    PasteMenuItem: TMenuItem;
    SelectAllMenuItem: TMenuItem;
    UndoMenuItem: TMenuItem;
    DeleteMenuItem: TMenuItem;
    WordWrapMenuItem: TMenuItem;
    ColumnNumber: TLabel;
    LineCount: TLabel;
    LineNumber: TLabel;
    WordWrapAction: TAction;
		procedure WordWrapActionExecute(Sender: TObject);
		procedure CopyActionExecute(Sender: TObject);
		procedure CutActionExecute(Sender: TObject);
		procedure DeleteActionExecute(Sender: TObject);
		procedure ExitActionExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
		procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift:
				TShiftState);
		procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift:
				TShiftState; X, Y: Single);
		procedure NewActionExecute(Sender: TObject);
		procedure OpenActionExecute(Sender: TObject);
		procedure PasteActionExecute(Sender: TObject);
		procedure SaveActionExecute(Sender: TObject);
		procedure SaveAsActionExecute(Sender: TObject);
		procedure SelectAllActionExecute(Sender: TObject);
		procedure UndoActionExecute(Sender: TObject);
  private
    { Déclarations privées }
    CurrentFile: String;
    procedure UpdateStatusBar;
  public
    { Déclarations publiques }
  end;

var
  TextEditorForm: TTextEditorForm;

implementation

{$R *.fmx}

procedure TTextEditorForm.UpdateStatusBar;
begin
	LineNumber.Text := 'L: ' + (Editor.CaretPosition.Line+1).ToString;
	ColumnNumber.Text := 'C: ' + (Editor.CaretPosition.Pos+1).ToString;
	LineCount.Text := 'Lines: ' + Editor.Lines.Count.ToString;
end;

procedure TTextEditorForm.FormCreate(Sender: TObject);
begin
  Editor.Lines.Add('');
  Editor.WordWrap := True;
  WordWrapAction.Checked := Editor.WordWrap;
  UpdateStatusBar;
end;

procedure TTextEditorForm.FormKeyUp(Sender: TObject; var Key: Word; var
		KeyChar: Char; Shift: TShiftState);
begin
  UpdateStatusBar;
end;

procedure TTextEditorForm.FormMouseUp(Sender: TObject; Button: TMouseButton;
		Shift: TShiftState; X, Y: Single);
begin
  UpdateStatusBar;
end;

// File > New
procedure TTextEditorForm.NewActionExecute(Sender: TObject);
var
  UserResponse: Integer;
begin
  // Ask for confirmation if the memo is not empty.
  if not Editor.Text.IsEmpty then
  begin
    UserResponse := TDialogServiceSync.MessageDialog(
      'This will clear the current document. Do you want to continue?',
      TMsgDlgType.mtInformation, mbYesNo, TMsgDlgBtn.mbYes, 0);
    if UserResponse = mrYes then
    begin
      Editor.Text := '';
      Editor.Lines.Add(''); // Initialize the memo line count to "1".
      UpdateStatusBar;
      CurrentFile := ''; // New files have no file name until saved.
    end;
  end;
end;

// File > Open
procedure TTextEditorForm.OpenActionExecute(Sender: TObject);
var
  FileName: String;
begin
  if OpenFileDialog.Execute = True then
  begin
    FileName := OpenFileDialog.FileName;
    if FileExists(FileName) then
    begin
      Editor.Lines.LoadFromFile(FileName);
      CurrentFile := FileName;
      Caption := 'Text Editor - ' + ExtractFileName(FileName);
    end;
  end;
end;

// File > Save
procedure TTextEditorForm.SaveActionExecute(Sender: TObject);
begin
  if CurrentFile = '' then
    SaveAsAction.Execute()
  else
    Editor.Lines.SaveToFile(CurrentFile);
end;

// File > Save as
procedure TTextEditorForm.SaveAsActionExecute(Sender: TObject);
var
  FileName: String;
  UserResponse: TModalResult;
begin
  if SaveFileDialog.Execute = True then
  begin
    FileName := SaveFileDialog.FileName;
    if FileExists(FileName) then
    begin
      UserResponse := TDialogServiceSync.MessageDialog(
        'File already exists. Do you want to overwrite?',
        TMsgDlgType.mtInformation, mbYesNo, TMsgDlgBtn.mbYes, 0);
      if UserResponse = mrNo then
        Exit;
    end;
    Editor.Lines.SaveToFile(FileName);
    CurrentFile := FileName;
    Caption := 'Text Editor - ' + ExtractFileName(FileName);
  end;
end;

// File > Exit
procedure TTextEditorForm.ExitActionExecute(Sender: TObject);
begin
  Application.Terminate;
end;

// Edit > Cut
procedure TTextEditorForm.CutActionExecute(Sender: TObject);
begin
  Editor.CutToClipboard;
  UpdateStatusBar;
end;

// Edit > Copy
procedure TTextEditorForm.CopyActionExecute(Sender: TObject);
begin
  Editor.CopyToClipboard;
end;

// Edit > Paste
procedure TTextEditorForm.PasteActionExecute(Sender: TObject);
begin
  Editor.PasteFromClipboard;
  UpdateStatusBar;
end;

// Edit > Select all
procedure TTextEditorForm.SelectAllActionExecute(Sender: TObject);
begin
  Editor.SelectAll;
  UpdateStatusBar;
end;

// Edit > Undo
procedure TTextEditorForm.UndoActionExecute(Sender: TObject);
begin
  Editor.UnDo;
  UpdateStatusBar;
end;

// Edit > Delete
procedure TTextEditorForm.DeleteActionExecute(Sender: TObject);
begin
  if Editor.SelLength > 0 then
    Editor.DeleteSelection
  else
    Editor.DeleteFrom(Editor.CaretPosition, 1, [TDeleteOption.MoveCaret]);
  UpdateStatusBar;
end;

// Format > Word Wrap
procedure TTextEditorForm.WordWrapActionExecute(Sender: TObject);
begin
  Editor.WordWrap := not Editor.WordWrap;
  WordWrapAction.Checked := Editor.WordWrap;
  UpdateStatusBar;
end;

end.
