with Ada.Containers.Formal_Vectors;
with Ada.Strings.Fixed;
with Ada.Text_IO;

procedure day07 is
   
   package Crab_Vector is new Ada.Containers.Formal_Vectors
     (Index_Type => Natural,
      Element_Type => Natural);
   
   package CV renames Crab_Vector;
   package IO renames Ada.Text_IO;
   
   procedure Crab_Locations
     (Line : String; Crabs : in out CV.Vector)
   is
      Index     : Natural;
      Last      : Natural := Line'First;
      Position  : Natural;
   begin
      loop
         Index := Ada.Strings.Fixed.Index (Line (Last .. Line'Last), ",");
         if Index /= 0 then
            Position := Natural'Value (Line (Last .. Index - 1));
            CV.Append (Crabs, Position);
         else
            Position := Natural'Value (Line (Last .. Line'Last));
            CV.Append (Crabs, Position);
            exit;
         end if;
         Last := Index + 1;
      end loop;
   end Crab_Locations;
   
   function Lowest_Position (Crabs : CV.Vector) return Natural
   is
      Lowest  : Long_Long_Integer := Long_Long_Integer'Last;
      Position : Natural;
      Current : Long_Long_Integer := 0;
      Distance : Natural := 0;
   begin
      for I in 0 .. 2000 loop
         for C of Crabs loop
            Distance := abs (C - I);
            for J in 1 .. Distance loop
               Current := Current + Long_Long_Integer (J);
            end loop;
         end loop;
         if Current <= Lowest then
            Lowest := Current;
            Position := I;
         end if;
         Current := 0;
      end loop;
      IO.Put_Line (Long_Long_Integer'Image (Lowest));
      return Position;
   end Lowest_Position;
   
   Crabs : CV.Vector (8192);
   File : IO.File_Type;
begin
   IO.Open (File, IO.In_File, "day7.txt", "WCEM=8");
   declare
      Line : String (1 .. 4096);
      Last : Natural;
   begin
      IO.Get_Line (File, Line, Last);
      Crab_Locations (Line (Line'First .. Last), Crabs);
   end;
   IO.Close (File);
   
   declare
      Position : Natural;
   begin
      Position := Lowest_Position (Crabs);
      IO.Put_Line (Natural'Image (Natural (CV.Length (Crabs))));
      IO.Put_Line (Natural'Image (Position));
   end;
end day07;
