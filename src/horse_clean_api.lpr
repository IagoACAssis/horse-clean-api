program horse_clean_api;


{$mode delphi}{$H+}

uses
  Horse,
  Horse.CORS,
  Horse.Jhonson,
  SysUtils,
  presentation.routes;

begin
  THorse.Use(CORS);
  THorse.Use(Jhonson());

  RegisterRoutes;

  Writeln('API rodando em http://localhost:9000');
  THorse.Listen(9000);
end.

