unit infrastructure.repositories.category_repository_sqlite;

{$mode delphi}{$H+}

interface

uses
  dom.repositories.icategory_repository,
  dom.entities.category,
  infrastructure.database.connection_factory,
  SQLite3Conn, SQLDB,
  Generics.Collections;

type

  { TCategoryRepositorySQLite }

  TCategoryRepositorySQLite = class(TInterfacedObject, ICategoryRepository)
  private
    FConnection: TSQLite3Connection;
    FTransaction: TSQLTransaction;
  public
    constructor Create;
    destructor Destroy; override;

    function Save(ACategory: TCategory): TCategory;
    function Update(ACategory: TCategory): TCategory;
    procedure UpdateStatus(AId: Integer; AAtivo: Boolean);
    function FindById(AId: Integer): TCategory;
    function FindAll: TObjectList<TCategory>;
    procedure Delete(AId: Integer);
  end;

implementation

uses
  SysUtils;

{ TCategoryRepositorySQLite }

function StringToDateTimeISO(const AValue: string): TDateTime;
var
  FS: TFormatSettings;
begin
  FS := DefaultFormatSettings;
  FS.DateSeparator := '-';
  FS.TimeSeparator := ':';
  FS.ShortDateFormat := 'yyyy-mm-dd';
  FS.LongTimeFormat := 'hh:nn:ss';

  Result := StrToDateTime(AValue, FS);
end;

constructor TCategoryRepositorySQLite.Create;
begin
  FConnection := TConnectionFactory.CreateSQLiteConnection;

  FTransaction := TSQLTransaction.Create(nil);
  FTransaction.DataBase := FConnection;
  FConnection.Transaction := FTransaction;
end;

destructor TCategoryRepositorySQLite.Destroy;
begin
  FTransaction.Free;
  FConnection.Free;
  inherited;
end;

function TCategoryRepositorySQLite.Save(ACategory: TCategory): TCategory;
var
  Query: TSQLQuery;
begin
  Query := TSQLQuery.Create(nil);
  try
    Query.DataBase := FConnection;
    Query.Transaction := FTransaction;

    Query.SQL.Text :=
      'INSERT INTO categories (nome, descricao, ativo, created_at) ' +
      'VALUES (:nome, :descricao, :ativo, :created_at)';

    Query.ParamByName('nome').AsString := ACategory.Nome;
    Query.ParamByName('descricao').AsString := ACategory.Descricao;
    Query.ParamByName('ativo').AsBoolean := ACategory.Ativo;
    Query.ParamByName('created_at').AsString := FormatDateTime('YYYY-MM-DD HH:MM:SS',ACategory.CriadoEm);

    Query.ExecSQL;
    FTransaction.Commit;

    ACategory.Id := FConnection.GetInsertID;
    Result := ACategory;
  finally
    Query.Free;
  end;
end;

function TCategoryRepositorySQLite.Update(ACategory: TCategory): TCategory;
var
  Query: TSQLQuery;
begin
  Query := TSQLQuery.Create(nil);
  try
    Query.DataBase := FConnection;
    Query.Transaction := FTransaction;

    Query.SQL.Text :=
      'UPDATE categories SET ' +
      'nome = :nome, ' +
      'descricao = :descricao, ' +
      'updated_at = :updated_at ' +
      'WHERE id = :id';

    Query.ParamByName('nome').AsString := ACategory.Nome;
    Query.ParamByName('descricao').AsString := ACategory.Descricao;
    Query.ParamByName('updated_at').AsString := FormatDateTime('yyyy-mm-dd hh:nn:ss', Now);
    Query.ParamByName('id').AsInteger := ACategory.Id;

    Query.ExecSQL;
    FTransaction.Commit;

    Result := ACategory;
  finally
    Query.Free;
  end;
end;

procedure TCategoryRepositorySQLite.UpdateStatus(AId: Integer; AAtivo: Boolean);
var
  Query: TSQLQuery;
begin
  Query := TSQLQuery.Create(nil);
  try
    Query.DataBase := FConnection;
    Query.Transaction := FTransaction;

    Query.SQL.Text :=
      'UPDATE categories SET ativo = :ativo, updated_at = :updated_at ' +
      'WHERE id = :id';

    Query.ParamByName('ativo').AsInteger := Ord(AAtivo);
    Query.ParamByName('updated_at').AsString :=
      FormatDateTime('yyyy-mm-dd hh:nn:ss', Now);
    Query.ParamByName('id').AsInteger := AId;

    Query.ExecSQL;
    FTransaction.Commit;
  finally
    Query.Free;
  end;
end;


function TCategoryRepositorySQLite.FindById(AId: Integer): TCategory;
var
  Query: TSQLQuery;
begin
  Result := nil;

  Query := TSQLQuery.Create(nil);
  try
    Query.DataBase := FConnection;
    Query.Transaction := FTransaction;

    Query.SQL.Text :=
      'SELECT id, nome, descricao, ativo, created_at, updated_at ' +
      'FROM categories WHERE id = :id';

    Query.ParamByName('id').AsInteger := AId;

    Query.Open;

    if not Query.EOF then
    begin
      Result := TCategory.Create(
        Query.FieldByName('nome').AsString,
        Query.FieldByName('descricao').AsString
      );

      Result.Id := Query.FieldByName('id').AsInteger;

      if Query.FieldByName('ativo').AsBoolean = False then
        Result.Desativar;

      Result.CriadoEm := StringToDateTimeISO(Query.FieldByName('created_at').AsString); //2025-12-18 23:51:28

      if not Query.FieldByName('updated_at').IsNull then
        Result.AtualizadoEm := StringToDateTimeISO(Query.FieldByName('updated_at').AsString);

    end;
  finally
    Query.Free;
  end;
end;

function TCategoryRepositorySQLite.FindAll: TObjectList<TCategory>;
begin
  Result := TObjectList<TCategory>.Create;
end;

procedure TCategoryRepositorySQLite.Delete(AId: Integer);
begin
  // Soft delete depois
end;

end.

