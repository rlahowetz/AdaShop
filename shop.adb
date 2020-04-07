with Ada.Text_IO; use Ada.Text_IO;
with ada.Integer_Text_IO; use ada.Integer_Text_IO;
with ada.Float_Text_IO; use ada.Float_Text_IO;

procedure Shop is

   totalDis : Integer;
   swap : Integer;                      --used for swapping first and last items
   isleCount : Integer;
   distanceOfIsleFront : Integer;       --distance from first item of current aisle
                                        --to last item in next aisle

   distanceOfisleBack  : Integer;       --distance from last item of current aisle
                                        --to first item of next aisle
   avgDis: Float;

   distanceAroundFront : Integer;       --distance from first item of current aisle
                                        --to first item of next aisle

   distanceAroundBack  : Integer;       --distance from last item of current aisle
                                        --to last item of next aisle

   subtype Number_of_Isles is Integer range 0 .. 100;
   nextIsle : Number_of_Isles;
   currentIsle : Number_of_Isles;
   firstIsle : Number_of_Isles;

   subtype Item_Locations is Integer range 0 .. 100; -- "shelves"
   nextLoc : Item_Locations;
   currentLoc: Item_Locations;
   firstItem : Item_Locations;

   type nextEnt is (front, back);   --where the entrence should be
   entrence : nextEnt;

   type direction is (forward, backward);  --direction person is going
   dir : direction;


begin

   --instantiation
   entrence := front;
   dir := forward;
   currentLoc := 0;
   totalDis := 0;
   isleCount := 0;
   avgDis :=  0.0;

   get(nextIsle);
   currentIsle := nextIsle;
   firstIsle := nextIsle;

   while nextIsle /= 0 loop             --exits when next isle is 0
      isleCount := isleCount + 1;

      get(nextLoc);
      firstItem := nextLoc;

      loop  --inside isles

         get(nextIsle);
         exit when nextIsle = 0 or nextIsle /= currentIsle;

         get(nextLoc);

      end loop;


      --first time, don't compare distances
      if currentIsle = firstIsle then
         totalDis := totalDis + nextLoc;

         Put_line("Continue and enter aisle " &
                    currentIsle'img & " at " & currentLoc'img &
                    " and proceed to location " & nextLoc'img &
                 ", traveling " & nextLoc'img);

      else --second and beyond
           --find distance around front and back
         distanceAroundFront := currentLoc + firstItem;
         distanceAroundBack := (Item_Locations'last - currentLoc +
                                  Item_Locations'last - nextLoc);


         --compare them and find direction
         --when going around the front is faster
         if distanceAroundBack > distanceAroundFront then
            entrence := front;

            if dir = forward then --going forward
               Put("Reverse  and enter aisle " & currentIsle'img);
            else                  --going backward
               Put("Continue and enter aisle " & currentIsle'img);
            end if;

            dir := forward;
            distanceOfIsleFront := distanceAroundFront + nextLoc - firstItem;

            --update distance traveled
            totalDis := totalDis + distanceOfIsleFront;


         --when going around the back is faster
         elsif distanceAroundBack < distanceAroundFront then
            entrence := back;

            if dir = forward then
               Put("Continue and enter aisle " & currentIsle'img);
            else
               Put("Reverse  and enter aisle " & currentIsle'img);
            end if;

            dir := backward;
            distanceOfisleBack := distanceAroundBack + nextLoc - firstItem;
            totalDis := totalDis + distanceAroundBack + (nextLoc - firstItem);

         else  --when the distances are equal
            if dir = forward then --keep going forward
               entrence := back;

               dir := backward;
               distanceOfisleBack := distanceAroundBack + nextLoc - firstItem;
               totalDis := totalDis + distanceAroundBack + (nextLoc - firstItem);

            elsif dir = backward then --keep going backward
               entrence := front;

               dir := forward;
               distanceOfIsleFront := distanceAroundFront + nextLoc - firstItem;
               totalDis := totalDis + distanceOfIsleFront;

            end if;

            put_Line("Continue and enter aisle " & currentIsle'img);

         end if;

         --finnishing the sentence:
         --going around the front
         if entrence = front then
            Put_Line(" at " & Item_Locations'first'img & " and proceed to location "
                     & nextLoc'img & ", traveling " & distanceOfIsleFront'img);

         else --going around the back
            Put(" at " & Item_Locations'last'img & " and proceed to location ");
            swap := firstItem;
            firstItem := nextLoc;
            nextLoc := swap;
            Put_Line(nextLoc'img & ", traveling " & distanceOfisleBack'img);

         end if;

      end if;

      exit when nextIsle = 0;

      --updates between aisles
      currentIsle := nextIsle;
      currentLoc := nextLoc;

   end loop;
   Put_Line("");

   Put_Line("total distance: " & totalDis'img); --final distance
   Put_Line("isle count: " & isleCount'img);

   avgDis := Float(totalDis)/Float(isleCount);  --final average
   Put_Line("Aisle average: " & avgDis'img);

end Shop;
