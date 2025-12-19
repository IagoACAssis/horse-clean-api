unit app.usecases.update_category_usecase;

{$mode delphi}{$H+}

interface

uses
  dom.repositories.icategory_repository,
  app.dto.category_dto,
  dom.entities.category;

type
  TUpdateCategoryUseCase = class
  private
    FRepository: ICategoryRepository;
  public
    constructor Create(ARepository: ICategoryRepository);
    function Execute(AId: Integer; const AInput: TUpdateCategoryDTO): TCategoryResponseDTO;
  end;

implementation

uses
  SysUtils;

constructor TUpdateCategoryUseCase.Create(ARepository: ICategoryRepository);
begin
  if not Assigned(ARepository) then
    raise Exception.Create('Repository não pode ser nulo');

  FRepository := ARepository;
end;

function TUpdateCategoryUseCase.Execute(
  AId: Integer;
  const AInput: TUpdateCategoryDTO
): TCategoryResponseDTO;
var
  Category: TCategory;
begin
  Category := FRepository.FindById(AId);
  if not Assigned(Category) then
    raise Exception.Create('Categoria não encontrada');

  try
    // regra de negócio vive na entidade
    Category.Atualizar(AInput.Nome, AInput.Descricao);

    Category := FRepository.Update(Category);

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

