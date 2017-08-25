package body Message_Server is

   protected body Post_Office is

      procedure Send (To : Box; Data : Message) is

      begin
         Store (To) := (Available => True, Data => Data);
      end Send;

      procedure Multicast (To : Boxes; Data : Message) is

      begin
         for B in To'Range loop
            Send (To (B), Data);
         end loop;
      end Multicast;

      procedure Broadcast (Data : Message) is

      begin
         for B in Box loop
            Send (B, Data);
         end loop;
      end Broadcast;

      entry Receive (for B in Box) (Data : out Message) when Store (B).Available is

      begin
         Store (B).Available := Receive (B)'Count > 0;
         Data                := Store (B).Data;
         Check_Multicast     := True;
      end Receive;

   end Post_Office;
end Message_Server;
