procedure tabela(x1, y1, x2, y2 : integer);
Var
   cont, cont2 : integer;
begin
  cont2 := y1;
  Repeat
    for cont := x1+1 to x2-1 do
    Begin
      gotoxy(cont, cont2);
      write('Í');
    End;
    if cont2 < y2 then cont2 := y2 else inc(cont2);
  Until cont2>y2;
  cont := x1;
  Repeat
    for cont2 := y1+1 to y2-1 do
    Begin
      gotoxy(cont, cont2);
      write('º');
    End;
    if cont < x2 then cont := x2 else inc(cont);
  Until cont>x2;
  gotoxy(x1,y1);
  write('É');
  gotoxy(x2,y1);
  write('»');
  gotoxy(x1,y2);
  write('È');
  gotoxy(x2,y2);
  write('¼');
end;

Procedure writexy(col, lin : integer; cadeia : string);
Begin
  gotoxy(col, lin);
  write(cadeia);
End;

procedure writecolorxy(colu, linh, cor : integer; cade : string);
Begin
  textcolor(cor);
  writexy(colu,linh,cade);
End;