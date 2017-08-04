program fps1_01; {s/ inimigos, s/ pulo, s/ cenario, resto ok!}
uses crt;  {erro com mudanca d arma: som soh muda dps d um tiro!}
Const
     xinf = 2;
     xsup = 79;
     esc = #27;
     maxtiro = 25;
var
   party_x, party_y, tirx, tiry, backx, arma, som_1,som_2 : integer;
   sair, atirando, atirou, som, sinal_backup, x_sinal, abaixado, pulo : boolean;

{$I tela.pas}

procedure teclas;
Var
   action1, action2 : char;
Begin
     action1 := readkey;
     action1 := upcase(action1);
     if ord(action1)=0 then
     Begin
          action2:=readkey;
          case action2 of
          chr(72) : if not(abaixado) then
                    Begin
                         if not(pulo) then
                         pulo:= true else
                         pulo:= false;
                    End else abaixado := false;
          chr(80) : if not(abaixado) then abaixado := true;
          chr(75) : if party_x > xinf then
                    Begin
                         if x_sinal then x_sinal := false
                         else if not(abaixado) then dec(party_x);;
                    End;
          chr(77) : if party_x < xsup then
                    Begin
                         if not(x_sinal) then x_sinal:= true
                         else if not(abaixado) then inc(party_x);
                    End;
          End;
     End Else
     Begin
          case action1 of
               'G', 'g' : if (not(atirando))and(not(atirou)) then atirou := true; {previne mts tiros consecutivos}
               '1' : if not(atirando) and not(atirou) then arma := 1;
               '2' : if not(atirando) and not(atirou) then arma := 2;
               esc : sair := true;
               'S' : if som then som := false else som := true;
          End;
     End;
End;

procedure empe;
Begin
     writecolorxy(party_x, party_y -1,white,'O');
     if not(x_sinal) then case arma of
                          1 : writexy(party_x -2, party_y,'<= \');
                          2 : writexy(party_x -2, party_y,'>= \');
                          End;
     if x_sinal then case arma of
                     1 : writexy(party_x -2, party_y,' / =>');
                     2 : writexy(party_x -2, party_y,' / =<');
                     End;
     writecolorxy(party_x, party_y,red,'Î');
     writecolorxy(party_x -1, party_y +1,blue,'/ \');
End;

procedure agachado;
Begin
     gotoxy(party_x -1, party_y);
     textcolor(white);
     if x_sinal then write('\O') else write(' O/');
     if x_sinal then
     Begin
          writecolorxy(party_x -1, party_y +1,blue,'Ú Â');
          textcolor(white);
          case arma of
          1 : write('>');
          2 : write('<');
          End;
     End Else
     Begin
          gotoxy(party_x -2, party_y +1);
          textcolor(white);
          case arma of
          1 : write('<');
          2 : write('>');
          End;
          textcolor(blue);
          write('Â ¿');
     End;
     writecolorxy(party_x, party_y+1,red,'Î');
End;

procedure party;
Begin
     if not abaixado then empe;
     if abaixado then agachado;
End;

procedure tipo_arma;
Begin
     case arma of
     1 : Begin
                som_1 := 2000;
                som_2 := 1900;
                textcolor(green);
                gotoxy(tirx, tiry);
                write('-');
           End;
     2 : Begin
                som_1 := 2100;
                som_2 := 2300;
                textcolor(yellow);
                gotoxy(tirx, tiry);
                write('*');
          End;
     End;
End;

procedure projetil;
Begin
     if atirou then
     Begin
        if x_sinal then tirx := party_x +2 else tirx := party_x - 2;
        if abaixado then tiry := party_y+1 else tiry := party_y;
        backx := tirx;
        atirando := true;
        if som then sound(som_1);
        atirou := false;
        sinal_backup := x_sinal;
     End Else
     Begin
          If atirando = true then
          Begin
               if sinal_backup then
               Begin
                    if (tirx- backx < maxtiro)and(not(tirx>=80)) then inc(tirx) else
                    Begin
                         atirou := false;
                         atirando := false;
                    End;
                    if som then
                    Begin
                         if backx - party_x = 3 then nosound;
                         if backx - party_x = 4 then sound(som_2);
                         if backx - party_x = 7 then nosound;
                    end;
               End Else
               Begin
                    if (backx - tirx < maxtiro)and(not(tirx<=1)) then dec(tirx) else
                    Begin
                         atirou := false;
                         atirando := false;
                    End;
                    if som then
                    Begin
                         if party_x - backx = 3 then nosound;
                         if party_x - backx = 4 then sound(1900);
                         if party_x - backx = 7 then nosound;
                    end;
               End;
               tipo_arma;
               gotoxy(1,1);
               textcolor(black);
               delay(25); {define a velo do tiro, 50 eh um valor bom...}
          End;
     End;
End;

procedure coisas;
Begin
     tabela(1,1,25,7);
     textcolor(10);
     gotoxy(2,2);
     write('Som: ');
     if som then writeln('Ligado') else writeln('Desligado');
     gotoxy(wherex+1,wherey);
     writeln('Posicao: (', party_x,',', party_y,')');
     gotoxy(wherex+1,wherey);
     write('Sinal do X (lado): ');
     if x_sinal then writeln('+') else writeln('-');
     gotoxy(wherex+1,wherey);
     write('Abaixado: ');
     if abaixado then writeln('S') else writeln('N');
     gotoxy(wherex+1,wherey);
     write('Pulo: ');
     if pulo then writeln('S') else writeln('N');
     textcolor(black);
     gotoxy(1,1);
End;
procedure tela;
Begin
     if atirou or atirando then
     Begin
          Repeat
                Repeat
                      clrscr;
                      party;
                      coisas;
                      projetil;
                      if (not(atirou))and(not(atirando)) then tela;
                      if sair then exit;
                Until keypressed;
                teclas;
          Until (not(atirou))and(not(atirando));
     End Else
     Begin
          clrscr;
          party;      (*necess rio party vir ants, s naum da pau*)
          coisas;
          projetil;
          if not(atirou) and not(atirando) then nosound;
          teclas;
     End;
End;

Begin (* programa principal*)
      party_x := 40;
      party_y := 24;
      sair := false;
      atirou := sair;
      pulo := sair;
      abaixado := false;
      atirando := sair;
      som := false;
      arma := 1;
      textbackground(black);
      clrscr;
      write('Bem vindo ao meu teste, utilize as setas: ');
      party;
      teclas;
      while not(sair) do tela;
      nosound;
end.