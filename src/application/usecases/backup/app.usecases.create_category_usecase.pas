unit app.usecases.create_category_usecase;

{$mode delphi}{$H+}

interface

uses
  dom.repositories.icategory_repository,
  app.dto.category_dto,
  dom.entities.category;

type
  TCreateCategoryUseCase = class
  private
    FRepository: ICategoryRepository;
  public
    constructor Create(ARepository: ICategoryRepository);
    function Execute(const AInput: TCreateCategoryDTO): TCategoryResponseDTO;
  end;

implementation

uses
  SysUtils;

{ TCreateCategoryUseCase }

constructor TCreateCategoryUseCase.Create(ARepository: ICategoryRepository);
begin
  if not Assigned(ARepository) then
    raise Exception.Create('Repository não pode ser nulo');

  FRepository := ARepository;
end;

function TCreateCategoryUseCase.Execute(
  const AInput: TCreateCategoryDTO): TCategoryResponseDTO;
var
  Category: TCategory;
begin
  // Regra de aplicação (orquestração)
  Category := TCategory.Create(AInput.Nome, AInput.Descricao);
  try
    Category := FRepository.Save(Category);

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

