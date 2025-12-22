unit presentation.controllers.category_controller;

{$mode delphi}{$H+}

interface

uses
  Horse,
  Generics.Collections;

procedure RegisterCategoryRoutes;

implementation

uses
  fpjson,
  jsonparser,
  SysUtils,
  app.dto.category_dto,
  infrastructure.repositories.category_repository_sqlite,
  app.usecases.create_category_usecase,
  app.usecases.get_category_by_id_usecase,
  app.usecases.update_category_usecase,
  app.usecases.enable_category_usecase,
  app.usecases.disable_category_usecase,
  app.usecases.list_categories_usecase
  ;


procedure CreateCategory(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
var
  BodyJSON: TJSONObject;
  JSONData: TJSONData;
  InputDTO: TCreateCategoryDTO;
  UseCase: TCreateCategoryUseCase;
  Repository: TCategoryRepositorySQLite;
  OutputDTO: TCategoryResponseDTO;
begin
  try
    JSONData := GetJSON(Req.Body);
    try
      if not (JSONData is TJSONObject) then
        raise Exception.Create('JSON inválido');

      BodyJSON := TJSONObject(JSONData);

      InputDTO.Nome := BodyJSON.Get('nome', '');
      InputDTO.Descricao := BodyJSON.Get('descricao', '');

      Repository := TCategoryRepositorySQLite.Create;
      UseCase := TCreateCategoryUseCase.Create(Repository);
      try
        OutputDTO := UseCase.Execute(InputDTO);

        Res.Status(201).Send(
          Format(
            '{"id":%d,"nome":"%s","descricao":"%s","ativo":%s}',
            [
              OutputDTO.Id,
              OutputDTO.Nome,
              OutputDTO.Descricao,
              BoolToStr(OutputDTO.Ativo, True)
            ]
          )
        );
      finally
        UseCase.Free;
      end;
    finally
      JSONData.Free;
    end;
  except
    on E: Exception do
      Res.Status(400).Send(
        Format('{"error":"%s"}', [E.Message])
      );
  end;
end;

procedure GetCategoryById(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
var
  Id: Integer;
  UseCase: TGetCategoryByIdUseCase;
  Repository: TCategoryRepositorySQLite;
  OutputDTO: TCategoryResponseDTO;
begin
  Id := StrToInt(Req.Params['id']);

  Repository := TCategoryRepositorySQLite.Create;
  UseCase := TGetCategoryByIdUseCase.Create(Repository);
  try
    OutputDTO := UseCase.Execute(Id);

    Res.Status(200).Send(
      Format(
        '{"id":%d,"nome":"%s","descricao":"%s","ativo":%s,"created_at":"%s","updated_at":"%s"}',
        [
          OutputDTO.Id,
          OutputDTO.Nome,
          OutputDTO.Descricao,
          BoolToStr(OutputDTO.Ativo, True),
          FormatDateTime('yyyy-mm-dd hh:nn:ss', OutputDTO.CriadoEm),
          FormatDateTime('yyyy-mm-dd hh:nn:ss', OutputDTO.AtualizadoEm)
        ]
      )
    );
  finally
    UseCase.Free;
  end;

end;


procedure UpdateCategory(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
var
  Id: Integer;
  JSONData: TJSONData;
  BodyJSON: TJSONObject;
  InputDTO: TUpdateCategoryDTO;
  UseCase: TUpdateCategoryUseCase;
  Repository: TCategoryRepositorySQLite;
  OutputDTO: TCategoryResponseDTO;
begin

  Id := StrToInt(Req.Params['id']);

  JSONData := GetJSON(Req.Body);
  try
    BodyJSON := TJSONObject(JSONData);

    InputDTO.Nome := BodyJSON.Get('nome', '');
    InputDTO.Descricao := BodyJSON.Get('descricao', '');
  finally
    JSONData.Free;
  end;

  Repository := TCategoryRepositorySQLite.Create;
  UseCase := TUpdateCategoryUseCase.Create(Repository);
  try
    OutputDTO := UseCase.Execute(Id, InputDTO);

    Res.Status(200).Send(
      Format(
        '{"id":%d,"nome":"%s","descricao":"%s","updated_at":"%s"}',
        [
          OutputDTO.Id,
          OutputDTO.Nome,
          OutputDTO.Descricao,
          FormatDateTime('yyyy-mm-dd hh:nn:ss', OutputDTO.AtualizadoEm)
        ]
      )
    );
  finally
    UseCase.Free;
  end;
end;

procedure EnableCategory(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
var
  Id: Integer;
  UseCase: TEnableCategoryUseCase;
  Repository: TCategoryRepositorySQLite;
begin
  Id := StrToInt(Req.Params['id']);

  Repository := TCategoryRepositorySQLite.Create;
  UseCase := TEnableCategoryUseCase.Create(Repository);
  try
    UseCase.Execute(Id);
    Res.Status(204).Send('');
  finally
    UseCase.Free;
  end;
end;


procedure DisableCategory(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
var
  Id: Integer;
  UseCase: TDisableCategoryUseCase;
  Repository: TCategoryRepositorySQLite;
begin
  Id := StrToInt(Req.Params['id']);

  Repository:= TCategoryRepositorySQLite.Create;
  UseCase := TDisableCategoryUseCase.Create(Repository);
  try
    UseCase.Execute(Id);
    Res.Status(204).Send('');
  finally
    UseCase.Free;
  end;
end;

procedure ListCategories(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
var
  Repository: TCategoryRepositorySQLite;
  UseCase: TListCategoriesUseCase;
  Items: TArray<TCategoryResponseDTO>;
  Item: TCategoryResponseDTO;
  JsonArray: TStringBuilder;
begin
  Repository := TCategoryRepositorySQLite.Create;
  UseCase := TListCategoriesUseCase.Create(Repository);
  try
    Items := UseCase.Execute;

    JsonArray := TStringBuilder.Create;
    try
      JsonArray.Append('[');

      for Item in Items do
      begin
        JsonArray.Append(
          Format(
            '{"id":%d,"nome":"%s","descricao":"%s","ativo":%s,"created_at":"%s","updated_at":"%s"},',
            [
              Item.Id,
              Item.Nome,
              Item.Descricao,
              BoolToStr(Item.Ativo, True),
              FormatDateTime('yyyy-mm-dd hh:nn:ss', Item.CriadoEm),
              FormatDateTime('yyyy-mm-dd hh:nn:ss', Item.AtualizadoEm)
            ]
          )
        );
      end;

      // remove a última vírgula, se houver itens
      if Length(Items) > 0 then
        JsonArray.Remove(JsonArray.Length - 1, 1);

      JsonArray.Append(']');

      Res.Status(200).Send(JsonArray.ToString);
    finally
      JsonArray.Free;
    end;
  finally
    UseCase.Free;
  end;
end;

procedure RegisterCategoryRoutes;
begin
  THorse.Post('/categories', CreateCategory);               //create
  THorse.Get('/categories/:id', GetCategoryById);           //read
  THorse.Get('/categories', ListCategories);                //read
  THorse.Put('/categories/:id', UpdateCategory);            //update
  THorse.Patch('/categories/:id/enable', EnableCategory);   //update
  THorse.Patch('/categories/:id/disable', DisableCategory); //update

end;

end.

