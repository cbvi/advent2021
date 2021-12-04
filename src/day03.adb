with Ada.Text_IO;
with Ada.IO_Exceptions;
with Ada.Containers.Formal_Vectors;

procedure day03 is
   
   package IO renames Ada.Text_IO;
   package EX_IO renames Ada.IO_Exceptions;
 
   subtype String_Length is Integer range 1 .. 12;
   subtype Binary_String is String (String_Length);
   
   package String_Vector is new Ada.Containers.Formal_Vectors
     (Index_Type => Positive,
      Element_Type => Binary_String);
   
   package SV renames String_Vector;
   
   function Uncommon_Culled (Vec : SV.Vector) return Binary_String
   is
      Zero_Vec : SV.Vector (4096);
      One_Vec  : SV.Vector (4096);
      New_Vec  : SV.Vector (4096);
      Position : String_Length := 1;
      
      use Ada.Containers; -- need operators for Count_Type
   begin
      SV.Append (New_Vec, Vec);
      
      while True loop
         for S of New_Vec loop
            if S (Position) = '0' then
               SV.Append (Zero_Vec, S);
            else
               SV.Append (One_Vec, S);
            end if;
         end loop;
      
         SV.Clear (New_Vec);
      
         if SV.Length (Zero_Vec) < SV.Length (One_Vec) then
            SV.Append (New_Vec, Zero_Vec);
         elsif SV.Length (Zero_Vec) = SV.Length (One_Vec) then
            Sv.Append (New_Vec, Zero_Vec);
         else
            SV.Append (New_Vec, One_Vec);
         end if;
         
         exit when SV.Length (New_Vec) = 1;
         
         Position := Position + 1;
         
         SV.Clear (One_Vec);
         SV.Clear (Zero_Vec);
      end loop;
      
      return SV.First_Element (New_Vec);
   end Uncommon_Culled;
   
   function Common_Culled (Vec : SV.Vector) return Binary_String
   is
      Zero_Vec : SV.Vector (4096);
      One_Vec  : SV.Vector (4096);
      New_Vec  : SV.Vector (4096);
      Position : String_Length := 1;
      
      use Ada.Containers; -- need operators for Count_Type
   begin
      SV.Append (New_Vec, Vec);
      
      while True loop
         for S of New_Vec loop
            if S (Position) = '0' then
               SV.Append (Zero_Vec, S);
            else
               SV.Append (One_Vec, S);
            end if;
         end loop;
      
         SV.Clear (New_Vec);
      
         if SV.Length (Zero_Vec) > SV.Length (One_Vec) then
            SV.Append (New_Vec, Zero_Vec);
         elsif SV.Length (Zero_Vec) = SV.Length (One_Vec) then
            Sv.Append (New_Vec, One_Vec);
         else
            SV.Append (New_Vec, One_Vec);
         end if;
         
         exit when SV.Length (New_Vec) = 1;
         
         Position := Position + 1;
         
         SV.Clear (One_Vec);
         SV.Clear (Zero_Vec);
      end loop;
      
      return SV.First_Element (New_Vec);
   end Common_Culled;
   
   function Common_Bit (Vec : SV.Vector; Position : String_Length)
                        return Character
   is
      Zero_Count : Integer := 0;
      One_Count  : Integer := 0;
   begin
      for S of Vec loop
         case S (Position) is
            when '0' =>
              Zero_Count := Zero_Count + 1;
            when '1' =>
              One_Count := One_Count + 1;
            when others => null;
         end case;
      end loop;
      if Zero_Count > One_Count then
         return '0';
      else
         return '1';
      end if;
   end Common_Bit;
   
   File : IO.File_Type;
   Line : Binary_String;
   Last : Natural;
   Vec  : SV.Vector (4096);
   Gamma_String : Binary_String;
   Epsilon_String : Binary_String;
   Gamma_Result : Integer;
   Epsilon_Result : Integer;
begin
   IO.Open (File, IO.In_File, "day3.txt", "WCEM=8");
   
   while True loop
      begin
         IO.Get_Line (File, Line, Last);
         if Last > 0 then
            SV.Append (Vec, Line (Line'First .. Last));
         end if;
      exception
         when EX_IO.End_Error =>
            exit;
      end;
   end loop;
   
   for I in String_Length loop
      Gamma_String (I) := Common_Bit (Vec, I);
      if Gamma_String (I) = '0' then
         Epsilon_String (I) := '1';
      else
         Epsilon_String (I) := '0';
      end if;
      -- IO.Put_Line (Character'Image (Common_Bit (Vec, I)));
   end loop;
   
   Gamma_Result := Integer'Value ("2#" & Gamma_String & "#");
   IO.Put_Line (Integer'Image (Gamma_Result));
   
   Epsilon_Result := Integer'Value ("2#" & Epsilon_String & "#");
   IO.Put_Line (Integer'Image (Epsilon_Result));
   
   IO.Put_Line (Integer'Image (Epsilon_Result * Gamma_Result));
   
   declare
      Oxygen_String : Binary_String;
      CO2_String : Binary_String;
      
      Oxygen : Long_Long_Integer;
      CO2 : Long_Long_Integer;
   begin
      Oxygen_String := Common_Culled (Vec);
      CO2_String := Uncommon_Culled (Vec);
      
      Oxygen := Long_Long_Integer'Value ("2#" & Oxygen_String & "#");
      CO2    := Long_Long_Integer'Value ("2#" & CO2_String & "#");
      IO.Put_Line (Long_Long_Integer'Image (Oxygen * CO2));
   end;
      
end day03;
