------------------------------------------------------------------------------
--                                                                          --
--                         GNAT COMPILER COMPONENTS                         --
--                                                                          --
--                              G N A T V S N                               --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--          Copyright (C) 1992-2021, Free Software Foundation, Inc.         --
--                                                                          --
-- GNAT is free software;  you can  redistribute it  and/or modify it under --
-- terms of the  GNU General Public License as published  by the Free Soft- --
-- ware  Foundation;  either version 3,  or (at your option) any later ver- --
-- sion.  GNAT is distributed in the hope that it will be useful, but WITH- --
-- OUT ANY WARRANTY;  without even the  implied warranty of MERCHANTABILITY --
-- or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License --
-- for  more details.  You should have  received  a copy of the GNU General --
-- Public License  distributed with GNAT; see file COPYING3.  If not, go to --
-- http://www.gnu.org/licenses for a complete copy of the license.          --
--                                                                          --
-- GNAT was originally developed  by the GNAT team at  New York University. --
-- Extensive contributions were provided by Ada Core Technologies Inc.      --
--                                                                          --
------------------------------------------------------------------------------

package body Gnatvsn is

   ----------------------
   -- Copyright_Holder --
   ----------------------

   function Copyright_Holder return String is
   begin
      return "Free Software Foundation, Inc.";
   end Copyright_Holder;

   ------------------------
   -- Gnat_Free_Software --
   ------------------------

   function Gnat_Free_Software return String is
   begin
      return
        "This is free software; see the source for copying conditions." &
        ASCII.LF &
        "There is NO warranty; not even for MERCHANTABILITY or FITNESS" &
        " FOR A PARTICULAR PURPOSE.";
   end Gnat_Free_Software;

   -------------------------
   -- Gnat_Version_String --
   -------------------------

   function Gnat_Version_String return String is
   begin
      return "12.0.0 20210712 (experimental)";
   end Gnat_Version_String;

end Gnatvsn;
