unit TextEditorUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Memo.Types,
  System.Actions, FMX.ActnList, FMX.ScrollBox, FMX.Memo,
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

{ TTextEditorForm }

procedure TTextEditorForm.UpdateStatusBar;
begin
     LineNumber.Text := 'L: ' + (Editor.CaretPosition.Line+1).ToString;
     ColumnNumber.Text := 'C: ' + (Editor.CaretPosition.Pos+1).ToString;
     LineCount.Text := 'Lines: ' + Editor.Lines.Count.ToString;
end;

end.
