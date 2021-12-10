with Ada.Text_IO;
with Ada.IO_Exceptions;
with Ada.Containers.Formal_Vectors;

procedure day10 is
   package IO renames Ada.Text_IO;
   
   package Token_Vector is new Ada.Containers.Formal_Vectors
     (Index_Type => Natural,
      Element_Type => Character);
   
   package TV renames Token_Vector;
   
   Wtf : TV.Vector (4096);
   
   function Parse_Line (Line : String; Stack : in out TV.Vector)
                        return Character
   is
      C : Character;
      D : Character;
   begin
      for I in Line'First .. Line'Last loop
         C := Line (I);
         case C is
            when '<' | '{' | '[' | '(' =>
               TV.Append (Stack, C);
            when '>' | '}' | ']' | ')' =>
               D := TV.Last_Element (Stack);
               TV.Delete_Last (Stack);
               if D = '<' and then C /= '>' then
                  TV.Append (Wtf, '<');
                  return C;
               elsif D = '{' and then C /= '}' then
                  TV.Append (Wtf, '{');
                  return C;
               elsif D = '[' and then C /= ']' then
                  TV.Append (Wtf, '[');
                  return C;
               elsif D = '(' and then C /= ')' then
                  TV.Append (Wtf, '(');
                  return C;
               end if;
            when others => null;
         end case;
      end loop;
      return '0';
   end Parse_Line;
   
   Delims : TV.Vector (4096);
   File : IO.File_Type;
   Line : String (1 .. 1024);
   Last : Natural;
   Tale : Natural := 0;
   Illegal : TV.Vector (4096);
   Char : Character;
begin
   IO.Open (File, IO.In_File, "day10.txt", "WCEM=8");
   loop
      begin
         IO.Get_Line (File, Line, Last);
         Char := Parse_Line (Line (Line'First .. Last), Delims);
         case Char is
            when '>' | '}' | ']' | ')' =>
               TV.Append (Illegal, Char);
            when others =>
               null;
         end case;
      exception
         when Ada.IO_Exceptions.End_Error => exit;
      end;
   end loop;
   
   for C of Illegal loop
      case C is
         when '>' => Tale := Tale + 25137;
         when '}' => Tale := Tale + 1197;
         when ']' => Tale := Tale + 57;
         when ')' => Tale := Tale + 3;
         when others => null;
      end case;
   end loop;
   
   IO.Put_Line (Natural'Image (Tale));
end day10;
