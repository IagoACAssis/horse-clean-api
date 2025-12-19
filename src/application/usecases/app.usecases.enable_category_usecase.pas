unit app.usecases.enable_category_usecase;

{$mode delphi}{$H+}

interface

uses
  dom.repositories.icategory_repository;

type
  TEnableCategoryUseCase = class
  private
    FRepository: ICategoryRepository;
  public
    constructor Create(ARepository: ICategoryRepository);
    procedure Execute(AId: Integer);
  end;

implementation

uses
  SysUtils;

constructor TEnableCategoryUseCase.Create(ARepository: ICategoryRepository);
begin
  FRepository := ARepository;
end;

procedure TEnableCategoryUseCase.Execute(AId: Integer);
begin
  if not Assigned(FRepository.FindById(AId)) then
    raise Exception.Create('Categoria não encontrada');

  FRepository.UpdateStatus(AId, True);
end;

end.

