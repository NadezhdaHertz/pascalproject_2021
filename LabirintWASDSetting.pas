PROGRAM Labirint(INPUT, OUTPUT); USES CRT, MMSystem;
CONST
  MaxSize = 20;
TYPE
  TLab = RECORD
            Cells: ARRAY[1..MaxSize + 1 , 1..MaxSize + 1] OF CHAR;
            Height, Width: INTEGER
         END;
  TPers = RECORD
            I, J, Steps: INTEGER;
          END;
VAR
  Score: ARRAY[1..10000] OF INTEGER;
  Lab: TLab;
  Ch: CHAR;
  EscLab, GameStatus: BOOLEAN;
  Pers: TPers;
  T: INTEGER;

PROCEDURE InitLabirint(VAR Lab: TLab; VAR Pers: TPers);
VAR
  F: TEXT;
  I, J: INTEGER;
  S: CHAR;
BEGIN
  CURSOROFF;
  ASSIGN(F, 'Labirint.txt');
  RESET(F);
  READ(F, Lab.Width, Lab.Height);
  READLN(F);
  FOR I := 1 TO Lab.Height
  DO
    BEGIN
      FOR J := 1 TO Lab.Width
      DO
        BEGIN
          READ(F, S);
          Lab.Cells[I, J] := S;
          IF S = '2'
          THEN
            BEGIN
              Pers.I := I;
              Pers.J := J;
              Pers.Steps := 0
            END
        END;

      READLN(F)
    END;

  CLOSE(F);
END;

PROCEDURE DrawLabirint(VAR T: INTEGER; VAR Lab: TLab; VAR Pers: TPers; VAR GameStatus: BOOLEAN);
VAR
  I, J, CountW: INTEGER;
BEGIN
  IF GameStatus = FALSE
  THEN
    BEGIN
      GOTOXY(1, 1);
      WRITELN('Game on! ');
    END
  ELSE
    BEGIN
      clrscr();
      GOTOXY(1, 1);
      WRITELN('YOU WIN! Press TAB restart or press ESC to exit.');
      GOTOXY(1,2);
      CountW := 1;
      SCORE[T] := Pers.Steps;
      WHILE CountW <= T DO
        BEGIN
          WRITELN('YOUR ', CountW, ' SCORE: ', SCORE[CountW]);
          CountW := CountW + 1;
        END;
      T := T + 1;
      WHILE GameStatus = TRUE
      DO 
        IF KeyPressed
        THEN
          BEGIN
            Ch := readkey();
            IF (Ch = #9)
            THEN
              BEGIN
                GameStatus := FALSE;
                clrscr();
                InitLabirint(Lab, Pers);
                DrawLabirint(T, Lab, Pers, GameStatus);
              END; 
            IF (Ch = #27)
            THEN
              BEGIN
                GameStatus := FALSE;
                EscLab := TRUE;
                clrscr();
              END;
          END;
    END;
      GOTOXY(1, 2);
      WRITELN('STEPS: ', Pers.Steps);
      GOTOXY(1, 3);
      FOR I := 1 TO Lab.Height
      DO
        BEGIN
          GOTOXY(1, I + 3);
          FOR J := 1 TO Lab.Width
          DO
            BEGIN
              IF Lab.Cells[I, J] = '2'
              THEN
                WRITE(CHR(1));
              IF Lab.Cells[I, J] = '1'
              THEN
                BEGIN
                  TEXTCOLOR(4);
                  TEXTBACKGROUND(4);
                  WRITE('#')
                END;
              IF Lab.Cells[I, J] = '0'
              THEN
                WRITE(' ');

              TEXTCOLOR(15);
              TEXTBACKGROUND(0)
            END
        END
    END;


PROCEDURE MoveMan(Ch: CHAR; VAR Pers: TPers);
BEGIN
  IF ((Ch = #115) OR (Ch = #83) OR (Ch = #219) OR (Ch = #251) OR (Ch = #80)) AND (Lab.Cells[Pers.I + 1, Pers.J] = '0') AND (Pers.I < Lab.Height) {S 115}
  THEN
    BEGIN
      Lab.Cells[Pers.I, Pers.J] := '0';
      Pers.I := Pers.I + 1;
      Lab.Cells[Pers.I, Pers.J] := '2';
      Pers.Steps := Pers.Steps + 1;
      SOUND(1000);
      DELAY(100);
      NOSOUND()
    END;
  IF ((Ch = #100) OR (Ch = #68) OR (Ch = #194) OR (Ch = #226) OR (Ch = #77)) AND (Lab.Cells[Pers.I, Pers.J + 1] = '0') AND (Pers.J < Lab.Width) {D 100}
  THEN
    BEGIN
      Lab.Cells[Pers.I, Pers.J] := '0';
      Pers.J := Pers.J + 1;
      Lab.Cells[Pers.I, Pers.J] := '2';
      Pers.Steps := Pers.Steps + 1;
      SOUND(2000);
      DELAY(100);
      NOSOUND()
    END;
  IF ((Ch = #119) OR (Ch = #87) OR (Ch = #246) OR (Ch = #214) OR (Ch = #72)) AND (Lab.Cells[Pers.I - 1, Pers.J] = '0') AND (Pers.I > 1) {W 119}
  THEN
    BEGIN
      Lab.Cells[Pers.I, Pers.J] := '0';
      Pers.I := Pers.I - 1;
      Lab.Cells[Pers.I, Pers.J] := '2';
      Pers.Steps := Pers.Steps + 1;
      SOUND(1000);
      DELAY(100);
      NOSOUND()
    END;
  IF ((Ch = #97) OR (Ch = #65) OR (Ch = #244) OR (Ch = #212) OR (Ch = #75)) AND (Lab.Cells[Pers.I, Pers.J - 1] = '0') AND (Pers.J > 1) {A 97}
  THEN
    BEGIN
      Lab.Cells[Pers.I, Pers.J] := '0';
      Pers.J := Pers.J - 1;
      Lab.Cells[Pers.I, Pers.J] := '2';
      Pers.Steps := Pers.Steps + 1;
      SOUND(2000);
      DELAY(100);
      NOSOUND()
    END
END;

BEGIN
  T := 1;
  EscLab := FALSE;
  GameStatus := FALSE;

  InitLabirint(Lab, Pers);
  DrawLabirint(T, Lab, Pers, GameStatus);
  sndPlaySound('newbackg_2.wav', snd_Async or snd_NoDefault);
  REPEAT
    WHILE KeyPressed
    DO
      Ch := ReadKey;

    IF Ch = #27
    THEN
    BEGIN
      EscLab := TRUE;
    END;

    IF Ch <> #0
    THEN
      BEGIN 
        IF (NOT GameStatus) AND (Ch IN [#9, #75, #72, #77, #80, #97, #65, #244, #212, #115, #83, #219, #251, #100, #68, #194, #226, #119, #87, #246, #214])
        THEN
          BEGIN
            MoveMan(Ch, Pers);
            GameStatus := (Pers.I = Lab.Height) OR (Pers.J = Lab.Width) OR (Pers.I = 1) OR (Pers.J = 1);
            DrawLabirint(T, Lab, Pers, GameStatus)
          END;

      Ch := #0
      END;

  UNTIL EscLab;
  {DrawLabirint(Lab, Pers, GameStatus);}
  clrscr();
END.








