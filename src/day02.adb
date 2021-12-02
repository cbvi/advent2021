with Ada.Text_IO;
with Ada.IO_Exceptions;

procedure day02 is
   
   type Direction_Type is (Forward, Down, Up);
   
   package IO renames Ada.Text_IO;
   
   package Long_IO      is new IO.Integer_IO     (Long_Long_Integer);
   package Direction_IO is new IO.Enumeration_IO (Direction_Type);
   
   File : IO.File_Type;
   
   Horiz  : Long_Long_Integer := 0;
   Depth  : Long_Long_Integer := 0;
   Aim    : Long_Long_Integer := 0;
   
   Direction : Direction_Type;
   Distance  : Long_Long_Integer;
begin
   IO.Open (File, IO.In_File, "day2.txt", "WCEM=8");
   
   while true loop
      begin
         Direction_IO.Get (File, Direction);
         Long_IO.Get (File, Distance);
         case Direction is
            when Up =>
               --Depth := Depth - Distance;
               Aim := Aim - Distance;
            when Down =>
               --Depth := Depth + Distance;
               Aim := Aim + Distance;
            when Forward =>
               Horiz := Horiz + Distance;
               Depth := Depth + (Aim * Distance);
         end case;
      exception
         when Ada.IO_Exceptions.End_Error =>
            exit;
      end;
   end loop;
   
   IO.Close (File);
   
   IO.Put_Line (Long_Long_Integer'Image (Horiz));
   IO.Put_Line (Long_Long_Integer'Image (Depth));
   IO.Put_Line (Long_Long_Integer'Image (Depth * Horiz));
end day02;
