with Ada.Text_IO;    use Ada.Text_IO;
with Id_Dispenser;
with Message_Server;

procedure Multi_Cast is

   package Positive_Dispenser is new Id_Dispenser (Element => Positive);

   Number_Of_Tasks : constant Positive := 3;

   type Colour is (Red, Green, Blue, Yellow, Magenta, Cyan);

   package Colour_Server is new Message_Server (Message   => Colour,
                                                Postboxes => Number_Of_Tasks);
   use Colour_Server;

   task type Client;

   Clients : array (Box) of Client;

   task body Client is

      Data : Colour;
      Id   : Box;

   begin
      Positive_Dispenser.Dispenser.Draw_Id (Id);

      for i in 1 .. 3 loop -- collecting the three messages per task
         Post_Office.Receive (Id) (Data);
         Put_Line ("Task" & Box'Image (Id) & " received: " & Colour'Image (Data));
      end loop;
   end Client;

begin
   -- Broadcast data (resulting in 1 message per task)
   Post_Office.Broadcast (Cyan);
   delay 0.1;

   -- Send individual data (1 message per task)
   declare
      Paint : Colour := Colour'First;
   begin
      for i in Clients'Range loop
         Post_Office.Send (i, Paint);
         Paint := Colour'Succ (Paint);
      end loop;
   end;
   delay 0.1;

   -- Multicast data to some and individual to the rest (1 message per task)
   declare
      Recipients : constant Boxes := (1, 3);
   begin
      Post_Office.Multicast (Recipients, Magenta);
      Post_Office.Send      (2,          Yellow);
   end;

end Multi_Cast;
