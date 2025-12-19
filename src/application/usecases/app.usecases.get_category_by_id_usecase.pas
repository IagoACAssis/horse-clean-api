unit app.usecases.get_category_by_id_usecase;

{$mode delphi}{$H+}

interface

uses
  dom.repositories.icategory_repository,
  app.dto.category_dto,
  dom.entities.category;

type
  TGetCategoryByIdUseCase = class
  private
    FRepository: ICategoryRepository;
  public
    constructor Create(ARepository: ICategoryRepository);
    function Execute(AId: Integer): TCategoryResponseDTO;
  end;

implementation

uses
  SysUtils;

constructor TGetCategoryByIdUseCase.Create(ARepository: ICategoryRepository);
begin
  if not Assigned(ARepository) then
    raise Exception.Create('Repository não pode ser nulo');

  FRepository := ARepository;
end;

function TGetCategoryByIdUseCase.Execute(AId: Integer): TCategoryResponseDTO;
var
  Category: TCategory;
begin
  Category := FRepository.FindById(AId);
  if not Assigned(Category) then
    raise Exception.Create('Categoria não encontrada');

  try
    Result.Id := Category.Id;
    Result.Nome := Category.Nome;
    Result.Descricao := Category.Descricao;
    Result.Ativo := Category.Ativo;
    Result.CriadoEm := Category.CriadoEm;
    Result.AtualizadoEm := Category.AtualizadoEm;
  finally
    Category.Free;
  end;
end;

end.

