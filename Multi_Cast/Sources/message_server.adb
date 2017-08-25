package body Message_Server is

   protected body Post_Office is

      procedure Send (To : Box; Data : Message) is
      begin
         Store (To) := (Available => True, Data => Data);
      end Send;

      entry Multicast (To : Boxes; Data : Message) when Check_Multicast is
      begin
          if (for some i in To'Range => Store ( To (i)).Available) then
              Check_Multicast := False;
              requeue Multicast;
          else
              for B in To'Range loop
                  Send (To (B), Data);
              end loop;
          end if;
      end Multicast;

      entry Broadcast (Data : Message) 
          when (for all B in Box => not Store(B).Available) is
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
