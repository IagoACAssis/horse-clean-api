unit app.dto.category_dto;

{$mode delphi}{$H+}

interface

type
  TCreateCategoryDTO = record
    Nome: string;
    Descricao: string;
  end;

  TCategoryResponseDTO = record
    Id: Integer;
    Nome: string;
    Descricao: string;
    Ativo: Boolean;
    CriadoEm: TDateTime;
    AtualizadoEm: TDateTime;
  end;

  TUpdateCategoryDTO = record
    Nome: string;
    Descricao: string;
  end;

implementation

end.

