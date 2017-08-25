
package body Id_Dispenser is

   protected body Dispenser is

      procedure Draw_Id (Id : out Element) is
      begin

         Id := counter;

         counter := Element'Succ (counter);

      end Draw_Id;

   end Dispenser;

end Id_Dispenser;
