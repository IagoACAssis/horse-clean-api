unit dom.entities.category;

{$mode delphi}{$H+}

interface

uses
  SysUtils;

type
  TCategory = class
  private
    FId: Integer;
    FNome: string;
    FDescricao: string;
    FAtivo: Boolean;
    FCriadoEm: TDateTime;
    FAtualizadoEm: TDateTime;

    procedure SetNome(const Value: string);
  public
    constructor Create(const ANome, ADescricao: string);

    procedure Atualizar(const ANome, ADescricao: string);
    procedure Ativar;
    procedure Desativar;

    property Id: Integer read FId write FId;
    property Nome: string read FNome write SetNome;
    property Descricao: string read FDescricao;
    property Ativo: Boolean read FAtivo ;
    property CriadoEm: TDateTime read FCriadoEm write FCriadoEm;
    property AtualizadoEm: TDateTime read FAtualizadoEm write FAtualizadoEm;
  end;

implementation

{ TCategory }

constructor TCategory.Create(const ANome, ADescricao: string);
begin
  if Trim(ANome) = '' then
    raise Exception.Create('Nome da categoria é obrigatório');

  FNome := ANome;
  FDescricao := ADescricao;
  FAtivo := True;
  FCriadoEm := Now;
end;

procedure TCategory.Atualizar(const ANome, ADescricao: string);
begin
  SetNome(ANome);
  FDescricao := ADescricao;
  FAtualizadoEm := Now;
end;

procedure TCategory.Ativar;
begin
  FAtivo := True;
  FAtualizadoEm := Now;
end;

procedure TCategory.Desativar;
begin
  FAtivo := False;
  FAtualizadoEm := Now;
end;

procedure TCategory.SetNome(const Value: string);
begin
  if Trim(Value) = '' then
    raise Exception.Create('Nome da categoria não pode ser vazio');

  FNome := Value;
end;



end.

