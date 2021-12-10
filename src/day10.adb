with Ada.Text_IO;
with Ada.IO_Exceptions;
with Ada.Containers.Formal_Vectors;

procedure day10 is
   package IO renames Ada.Text_IO;
   
   package Token_Vector is new Ada.Containers.Formal_Vectors
     (Index_Type => Natural,
      Element_Type => Character);
   
   package Score_Vector is new Ada.Containers.Formal_Vectors
     (Index_Type => Natural,
      Element_Type => Long_Long_Integer);
   
   package Sort_Score is new Score_Vector.Generic_Sorting;
   
   package TV renames Token_Vector;
   package SV renames Score_Vector;
   
   function Validate_Line (Line : String) return Boolean
   is
      Toks : TV.Vector (4096);
      C : Character;
      D : Character;
   begin
      for I in Line'First .. Line'Last loop
         C := Line (I);
         case C is
            when '<' | '{' | '[' | '(' =>
               TV.Append (Toks, C);
            when '>' | '}' | ']' | ')' =>
               D := TV.Last_Element (Toks);
               TV.Delete_Last (Toks);
               if D = '<' and then C /= '>' then
                  return False;
               elsif D = '{' and then C /= '}' then
                  return False;
               elsif D = '[' and then C /= ']' then
                  return False;
               elsif D = '(' and then C /= ')' then
                  return False;
               end if;
            when others => null;
         end case;
      end loop;
      return True;
   end Validate_Line;
   
   function Get_Score (Line : String) return Long_Long_Integer
   is
      Tale : Long_Long_Integer := 0;
      Toks : TV.Vector (4096);
   begin
      declare
         C : Character;
      begin
         for I in Line'First .. Line'Last loop
            C := Line (I);
            case C is
            when '<' | '{' | '[' | '(' =>
               TV.Append (Toks, C);
            when '>' | '}' | ']' | ')' =>
               TV.Delete_Last (Toks);
            when others => null;
            end case;
         end loop;
      end;
      
      TV.Reverse_Elements (Toks);
      
      for C of Toks loop
         Tale := Tale * 5;
         case C is
            when '<' => Tale := Tale + 4;
            when '{' => Tale := Tale + 3;
            when '[' => Tale := Tale + 2;
            when '(' => Tale := Tale + 1;
            when others => null;
         end case;
      end loop;

      return Tale;
   end Get_Score;
   
   File : IO.File_Type;
   Line : String (1 .. 1024);
   Last : Natural;
   Scores : SV.Vector (4096);
begin
   IO.Open (File, IO.In_File, "day10.txt", "WCEM=8");
   loop
      begin
         IO.Get_Line (File, Line, Last);
         if Validate_Line (Line (Line'First .. Last)) then
            sv.Append (Scores, Get_Score (Line (Line'First .. Last)));
         end if;
      exception
         when Ada.IO_Exceptions.End_Error => exit;
      end;
   end loop;
   
   Sort_Score.Sort (Scores);
   
   IO.Put_Line
     (Long_Long_Integer'Image
        (SV.Element
             (Scores, SV.First_Index (Scores) + Sv.Last_Index (Scores) / 2)));
end day10;
