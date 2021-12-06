with Ada.Text_IO;
with Ada.Strings.Fixed;

procedure day06 is  
   
   type Fish_Count is mod 2**64;
   type Fish_Cycle is range 0 .. 8;
   type Fish_Map is array (Fish_Cycle) of Fish_Count;
   
   Spawn_Point : constant Fish_Cycle := 8;
   Reset_Point : constant Fish_Cycle := 6;
    
   package IO renames Ada.Text_IO;
   
   procedure Spawn_Lanternfish
     (Lanternfishes : in out Fish_Map; Life : Fish_Cycle := 8)
   is
   begin
      Lanternfishes (Life) := Lanternfishes (Life) + 1;
   end Spawn_Lanternfish;
   
   procedure Spawn_Initial_Lanternfish
     (Line : String; Lanternfishes : in out Fish_Map)
   is
      Index : Natural;
      Last  : Natural := Line'First;
      Life  : Fish_Cycle;
   begin
      loop
         Index := Ada.Strings.Fixed.Index (Line (Last .. Line'Last), ",");
         if Index /= 0 then
            Life := Fish_Cycle'Value (Line (Last .. Index - 1));
            Spawn_Lanternfish (Lanternfishes, Life);
         else
            Life := Fish_Cycle'Value (Line (Last .. Line'Last));
            Spawn_Lanternfish (Lanternfishes, Life);
            exit;
         end if;
         Last := Index + 1;
      end loop;
   end Spawn_Initial_Lanternfish;
   
   procedure Tick_Day (Lanternfishes : in out Fish_Map)
   is
      New_Fish : constant Fish_Count := Lanternfishes (Fish_Cycle'First);
   begin
      for I in Lanternfishes'First + 1 .. Lanternfishes'Last loop
         Lanternfishes (I - 1) := Lanternfishes (I);
      end loop;
      Lanternfishes (Spawn_Point) := New_Fish;
      Lanternfishes (Reset_Point) := Lanternfishes (Reset_Point) + New_Fish;
   end Tick_Day;
   
   function Total_Fish (Lanternfishes : Fish_Map) return Fish_Count
   is
      Total : Fish_Count := 0;
   begin
      for I in Lanternfishes'Range loop
         Total := Total + Lanternfishes (I);
      end loop;
      return Total;
   end Total_Fish;
   
   Lanternfishes : Fish_Map := (others => 0);
   File : IO.File_Type;
   Line : String (1 .. 1024);
   Last : Natural;
begin
   IO.Open (File, IO.In_File, "day6.txt", "WCEM=8");
   IO.Get_Line (File, Line, Last);
   IO.Close (File);
   
   Spawn_Initial_Lanternfish (Line (Line'First .. Last), Lanternfishes);

   for I in 1 .. 256 loop
      Tick_Day (Lanternfishes);
   end loop;
   
   IO.Put_Line (Fish_Count'Image (Total_Fish (Lanternfishes)));
end day06;
