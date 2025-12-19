unit dom.repositories.icategory_repository;

{$mode delphi}{$H+}

interface

uses
  Generics.Collections,
  dom.entities.category;

type
  ICategoryRepository = interface
    ['{B9AFA20E-5B69-4C65-AAB7-9A56C6C0F201}']

    function Save(ACategory: TCategory): TCategory;
    function Update(ACategory: TCategory): TCategory;
    procedure UpdateStatus(AId: Integer; AAtivo: Boolean);
    function FindById(AId: Integer): TCategory;
    function FindAll: TObjectList<TCategory>;
    procedure Delete(AId: Integer);
  end;

implementation

end.

