with Ada.Text_IO;
with Ada.Containers.Formal_Vectors;

procedure day02 is
   
   package IO renames Ada.Text_IO;
   
   type Direction_Type is (Forward, Down, Up);
   
   Oops : exception;
   
   type Instruction is record
      Direction : Direction_Type;
      Distance  : Long_Long_Integer;
   end record;
   
   package Integer_Vector is new Ada.Containers.Formal_Vectors
     (Index_Type   => Natural,
      Element_Type => Integer);
   
   package IV renames Integer_Vector;
   
   function Get_Instruction (Line : String) return Instruction
   is
      Ins : Direction_Type;
      -- Dis : Long_Long_Integer;
      Break : Integer := 0;
   begin
      for C of Line loop
         Break := Break + 1;
         if C = ' ' then
            exit;
         end if;
      end loop;
      
      declare
         Word : String := Line (Line'First .. Break - 1);
         Number : String := Line (Break + 1 .. Line'Last);
         Int : Long_Long_Integer;
         Res : Instruction;
      begin
         Int := Long_Long_Integer'Value (Number);
         
         Ins := Direction_Type'Value (Word);
         

         
         Res.Direction := Ins;
         Res.Distance := Int;
         return Res;
      end;
   end Get_Instruction;
   
   File : IO.File_Type;
   Line : String (1..1024);
   Last : Natural;
   
   Horiz : Long_Long_Integer := 0;
   Depth : Long_Long_Integer := 0;
   My_Ins : Instruction;
   Aim : Long_Long_Integer := 0;
begin
   IO.Open (File, IO.In_File, "day2.txt", "WCEM=8");
   
   while true loop
      begin
         IO.Get_Line (File, Line, Last);
         My_Ins := Get_Instruction (Line (Line'First .. Last));
         case My_Ins.Direction is
            when Up =>
               --Depth := Depth - My_Ins.Distance;
               Aim := Aim - My_Ins.Distance;
            when Down =>
               --Depth := Depth + My_Ins.Distance;
               Aim := Aim + My_Ins.Distance;
            when Forward =>
               Horiz := Horiz + My_Ins.Distance;
               Depth := Depth + (Aim * My_Ins.Distance);
         end case;
      exception
         when others => exit;
      end;
   end loop;
   
   IO.Put_Line (Long_Long_Integer'Image (Horiz));
   IO.Put_Line (Long_Long_Integer'Image (Depth));
   IO.Put_Line (Long_Long_Integer'Image (Depth * Horiz));
end day02;
