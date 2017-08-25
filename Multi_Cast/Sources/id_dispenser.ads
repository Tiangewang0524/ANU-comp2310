

generic
   type Element is (<>);

package Id_Dispenser is

   protected Dispenser is
      procedure Draw_Id (Id : out Element);
   private
      counter : Element := Element'First;
   end Dispenser;

end Id_Dispenser;
