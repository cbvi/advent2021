with Ada.Text_IO;
with Ada.IO_Exceptions;

procedure day09 is
   
   package IO renames Ada.Text_IO;
   
   type Height_Map is array (1 .. 128, 1 .. 128) of Natural;

   Heights : Height_Map;
   File : IO.File_Type;
   Line : String (1 .. 128);
   Last : Natural;
   Row  : Natural := 0;
   Col  : Natural := 1;
   Flag : Boolean := False;
   Current : Natural;
   Tale : Natural := 0;
begin
   IO.Open (File, IO.In_File, "day9.txt", "WCEM=8");
   
   loop
      begin
         IO.Get_Line (File, Line, Last);
         Row := Row + 1;
         for I in Line'First .. Last loop
            Heights (Row, Col) := Integer'Value (Line (I .. I));
            Col := Col + 1;
         end loop;
         Col := 1;
      exception
         when Ada.IO_Exceptions.End_Error => exit;
      end;
   end loop;
   
   for I in 1 .. Row loop
      for J in 1 .. Last loop
         Current := Heights (I, J);
         Flag := (I = 1 or else Current < Heights (I-1, J)) and then
           (I = Row or else Current < Heights (I+1, J)) and then
           (J = 1 or else Current < Heights (I, J-1)) and then
           (J = Last or else Current < Heights (I, J+1));
         
         if Flag then
            -- IO.Put ("(" & Natural'Image (I) & "," & Natural'Image (J) & ")");
            -- IO.Put_Line (Natural'Image (Heights (I, J)));
            Tale := Tale + Current + 1;
         end if;
      end loop;
   end loop;
   
   IO.Put_Line (Natural'Image (Tale));
   
end day09;
