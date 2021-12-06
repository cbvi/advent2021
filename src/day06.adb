with Ada.Text_IO;
with Ada.Strings.Fixed;
with Ada.Containers.Formal_Vectors;

procedure day06 is
   type Lanternfish is record
      Timer : Integer;
   end record;
   
   package Lanternfish_Vector is new Ada.Containers.Formal_Vectors
     (Index_Type => Natural,
      Element_Type => Lanternfish);
   
   package LV renames Lanternfish_Vector;
   package IO renames Ada.Text_IO;
   
   procedure Spawn_Lanternfish
     (Lanternfishes : in out LV.Vector; Life : Integer := 8)
   is
      Fish : Lanternfish;
   begin
      Fish.Timer := Life;
      LV.Append (Lanternfishes, Fish);
   end Spawn_Lanternfish;
   
   procedure Spawn_Initial_Lanternfish
     (Line : String; Lanternfishes : in out LV.Vector)
   is
      Index : Natural;
      Last  : Natural := Line'First;
      Life : Integer;
   begin
      loop
         Index := Ada.Strings.Fixed.Index (Line (Last .. Line'Last), ",");
         if Index /= 0 then
            Life := Integer'Value (Line (Last .. Index - 1));
            Spawn_Lanternfish (Lanternfishes, Life);
         else
            Life := Integer'Value (Line (Last .. Line'Last));
            Spawn_Lanternfish (Lanternfishes, Life);
            exit;
         end if;
         Last := Index + 1;
      end loop;
   end Spawn_Initial_Lanternfish;
   
   procedure Tick_Day (Lanternfishes : in out LV.Vector)
   is
      Fish : Lanternfish;
   begin
      for I in LV.First_Index (Lanternfishes) .. LV.Last_Index (Lanternfishes)
      loop
         Fish := LV.Element (Lanternfishes, I);
         if Fish.Timer = 0 then
            Fish.Timer := 6;
            Spawn_Lanternfish (Lanternfishes);
         else
            Fish.Timer := Fish.Timer - 1;
         end if;
         LV.Replace_Element (Lanternfishes, I, Fish);
      end loop;
   end Tick_Day;
   
   Lanternfishes : LV.Vector (524288);
   File : IO.File_Type;
   Line : String (1 .. 1024);
   Last : Natural;
begin
   IO.Open (File, IO.In_File, "day6.txt", "WCEM=8");
   IO.Get_Line (File, Line, Last);
   IO.Close (File);
   
   Spawn_Initial_Lanternfish (Line (Line'First .. Last), Lanternfishes);
   
   for I in 1 .. 80 loop
      Tick_Day (Lanternfishes);
   end loop;
   
   IO.Put_Line (Integer'Image (Integer (LV.Length (Lanternfishes))));
end day06;
