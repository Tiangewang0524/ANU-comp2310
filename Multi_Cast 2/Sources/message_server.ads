generic
   type Message is private;
   Postboxes : Positive := 3;

package Message_Server is

   subtype Box      is Positive range 1 .. Postboxes;
   type Boxes       is array (Positive range <>) of Box;
   type Box_Content is record
      Available : Boolean := False;
      Data      : Message;
   end record;
   type Box_Contents is array (Box) of Box_Content;

   protected Post_Office is

      procedure Send      (To : Box;   Data :     Message);
      procedure Multicast (To : Boxes; Data :     Message);
      procedure Broadcast             (Data :     Message);
      entry     Receive        (Box)  (Data : out Message);

   private
      Store           : Box_Contents;
      Check_Multicast : Boolean := True;
   end Post_Office;

end Message_Server;
