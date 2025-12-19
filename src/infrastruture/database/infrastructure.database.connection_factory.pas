unit infrastructure.database.connection_factory;

{$mode delphi}{$H+}

interface

uses
  SQLite3Conn, SQLDB;

type
  TConnectionFactory = class
  public
    class function CreateSQLiteConnection: TSQLite3Connection;
  end;

implementation

{ TConnectionFactory }

class function TConnectionFactory.CreateSQLiteConnection: TSQLite3Connection;
begin
  Result := TSQLite3Connection.Create(nil);
  Result.DatabaseName := 'database/app.db';
  Result.Connected := True;
end;

end.

