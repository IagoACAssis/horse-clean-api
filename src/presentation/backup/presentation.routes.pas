unit presentation.routes;

{$MODE DELPHI}{$H+}

interface

procedure RegisterRoutes;

implementation

uses
  Horse;


procedure GetPing(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
begin
  Res.Send('OK');
end;

procedure RegisterRoutes;
begin
  THorse.Get('/health', Health);
end;

end.

