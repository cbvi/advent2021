with Ada.Text_IO;
with Ada.Containers.Formal_Vectors;

procedure day01 is
   package IO renames Ada.Text_IO;
   
   package Integer_Vector is new Ada.Containers.Formal_Vectors
     (Index_Type   => Natural,
      Element_Type => Integer);
   
   package IV renames Integer_Vector;
   
   procedure Groups_Of_Three
     (V : Integer_Vector.Vector;
      Result : in out Integer_Vector.Vector)
   is
      Cur : Integer;
   begin
      for I in IV.First_Index (V)..IV.Last_Index (V) loop
         exit when I > IV.Last_Index (V) - 2;
         Cur := IV.Element (V, I + 0);
         Cur := Cur + IV.Element (V, I + 1);
         Cur := Cur + IV.Element (V, I + 2);
         IV.Append (Result, Cur);
      end loop;
   end Groups_Of_Three;
   
   File : IO.File_Type;
   Increases : Integer := 0;
   Vec : Integer_Vector.Vector (4096);
   Ext : Integer_Vector.Vector (4096);
begin
   IO.Open (File, IO.In_File, "day1.txt", "WCEM=8");
   
   declare
      Line : String (1..1024);
      Last : Natural;    
      Current : Integer;
      Previous : Integer := Integer'Last;
   begin
      while true loop
         IO.Get_Line (File, Line, Last);
         Current := Integer'Value (Line (Line'First..Last));
         
         Integer_Vector.Append (Vec, Current);
         
         if Current > Previous then
            Increases := Increases + 1;
         end if;
         Previous := Current;
      end loop;
   exception
      when others => null;
   end;
   
   IO.Put_Line (Integer'Image (Increases));
   
   Groups_Of_Three (Vec, Ext);
   Increases := 0;
   
   declare
      Previous : Integer := Integer'Last;
      Current : Integer;
   begin
      for I in IV.First_Index (Ext)..IV.Last_Index (Ext) loop
         Current := IV.Element (Ext, I);
         if Current > Previous then
            Increases := Increases + 1;
         end if;
         Previous := Current;
      end loop;
   end;
   
   IO.Put_Line (Integer'Image (Increases));
   IO.Close (File);
end day01;
