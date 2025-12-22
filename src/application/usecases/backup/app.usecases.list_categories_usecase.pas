unit app.usecases.list_categories_usecase;

{$mode delphi}{$H+}

interface

uses
  Classes, SysUtils,
  dom.repositories.icategory_repository,
  dom.entities.category,
  app.dto.category_dto,
  Generics.Collections;

type

  { TListCategoriesUseCase }

  TListCategoriesUseCase = class
    private
      FRepository: ICategoryRepository;
    public
      constructor Create(ARepository : ICategoryRepository);
      function Execute: TArray<TCategoryResponseDTO>;

  end;

implementation

{ TListCategoriesUseCase }

constructor TListCategoriesUseCase.Create(ARepository: ICategoryRepository);
begin
  if not Assigned(ARepository) then
    raise Exception.Create('Repository não pode ser nulo');

  FRepository := ARepository;

end;

function TListCategoriesUseCase.Execute: TArray<TCategoryResponseDTO>;
var
  Categories: TObjectList<TCategory>;
  Category: TCategory;
  Index : Integer;
begin
  Result := nil;

  Categories := FRepository.FindAll;
  try
    SetLength(Result, Categories.Count);
    Index := 0;

    for Category in Categories do
    begin
      Result[Index].Id := Category.Id;
      Result[Index].Nome := Category.Nome;
      Result[Index].Descricao := Category.Descricao;
      Result[Index].Ativo := Category.Ativo;
      Result[Index].CriadoEm := Category.CriadoEm;
      Result[Index].AtualizadoEm := Category.AtualizadoEm;

      Inc(Index);
    end;

  finally
    Categories.Free;
  end;

end;

end.

