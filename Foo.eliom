open Eliom_lib
open Eliom_content
open Html.D

let%server counter action =
    let state = [%client ref 0 ] in
    button
      (* ~button_type:`Button *)
      ~a:[a_onclick [%client fun _ -> incr ~%state; ~%action !(~%state) ]]
      [pcdata "Increment"]
