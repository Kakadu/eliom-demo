[%%shared
    open Eliom_lib
    open Eliom_content
    open Html.D
]

module Counter_app =
  Eliom_registration.App (
    struct
      let application_name = "counter"
      let global_data_path = None
    end)

let main_service =
  Eliom_service.create
    ~path:(Eliom_service.Path [])
    ~meth:(Eliom_service.Get Eliom_parameter.unit)
    ()

(* module C : sig
 *   val%server counter: (int -> unit) fragment -> Html.t
 * end = struct *)
(* end *)

let%server save_counter = print_endline

let () =
  Counter_app.register
    ~service:main_service
    (fun () () ->
      Lwt.return
        (Eliom_tools.F.html
           ~title:"counter"
           ~css:[["css";"counter.css"]]
           Html.F.(body [
             h1 [pcdata "Welcome from Eliom's distillery!"];
             Foo.content [%client ~%save_counter_rpc]
           ])))
