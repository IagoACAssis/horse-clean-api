unit presentation.routes;

{$MODE DELPHI}{$H+}

interface

procedure RegisterRoutes;

implementation

uses
  Horse,
  presentation.controllers.category_controller;


procedure Health(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
begin
  Res.Send('OK');
end;

procedure RegisterRoutes;
begin
  THorse.Get('/health', Health);


  RegisterCategoryRoutes;
end;

end.

