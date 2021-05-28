object fThreads: TfThreads
  Left = 0
  Top = 0
  Caption = 'fThreads'
  ClientHeight = 259
  ClientWidth = 316
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 120
    Top = 16
    Width = 57
    Height = 13
    Caption = 'Valor tempo'
  end
  object Label2: TLabel
    Left = 25
    Top = 16
    Width = 61
    Height = 13
    Caption = 'Qtd TThread'
  end
  object NumeroThread: TEdit
    Left = 24
    Top = 40
    Width = 89
    Height = 21
    TabOrder = 0
    Text = '2'
  end
  object edtTempo: TEdit
    Left = 119
    Top = 40
    Width = 89
    Height = 21
    TabOrder = 1
    Text = '200'
  end
  object Button1: TButton
    Left = 214
    Top = 34
    Width = 75
    Height = 33
    Caption = 'Processar '
    TabOrder = 2
    OnClick = Button1Click
  end
  object ProgressBar1: TProgressBar
    Left = 24
    Top = 232
    Width = 275
    Height = 17
    TabOrder = 3
  end
  object Memo1: TMemo
    Left = 24
    Top = 88
    Width = 275
    Height = 138
    Lines.Strings = (
      '')
    TabOrder = 4
  end
end
