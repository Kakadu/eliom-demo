[%%shared
    open Eliom_lib
    open Eliom_content
    open Html.D
]

module Ex_app =
  Eliom_registration.App (
    struct
      let application_name = "counter"
      let global_data_path = None
    end)

(* let main_service =
 *   Eliom_service.create
 *     ~path:(Eliom_service.Path [])
 *     ~meth:(Eliom_service.Get Eliom_parameter.unit)
 *     () *)

let new_set () = [%client ( ref (fun () -> ()) : (unit -> unit) ref)]

let%client switch_visibility elt =
  let elt = Eliom_content.Html.To_dom.of_element elt in
  if Js.to_bool (elt##.classList##(contains (Js.string "hidden"))) then
    elt##.classList##remove (Js.string "hidden")
  else
    elt##.classList##add (Js.string "hidden")

let%shared mywidget set s1 s2 = Eliom_content.Html.D.(
  let button  = div ~a:[a_class ["button"]] [pcdata s1] in
  let content = div ~a:[a_class ["content"; "hidden"]] [pcdata s2] in
  let _ = [%client
    (Lwt.async (fun () ->
       Lwt_js_events.clicks (Eliom_content.Html.To_dom.of_element ~%button) (fun _ _ ->
         ! ~%set ();
         ~%set := (fun () -> switch_visibility ~%content);
         switch_visibility ~%content;
	       Lwt.return ()))
       : unit)]
  in
  div ~a:[a_class ["mywidget"]] [button; content]
)

let _ = Eliom_content.Html.D.(
  Ex_app.create
    ~path:(Eliom_service.Path [""])
    ~meth:(Eliom_service.Get Eliom_parameter.unit)
    (fun () () ->
      let set1 = new_set () in
      let set2 = new_set () in
      let _ = [%client (
	Dom.appendChild
	  (Dom_html.document##.body)
	  (Eliom_content.Html.To_dom.of_element (mywidget ~%set2 "Click me" "client side"))
	  : unit)
	      ] in
      Lwt.return
        (Eliom_tools.D.html ~title:"ex" ~css:[["css"; "ex.css"]]
           (body [
             h2 [pcdata "Welcome to Ocsigen!"];
             mywidget set1 "Click me" "server side";
             mywidget set1 "Click me" "server side";
             mywidget set2 "Click me" "server side"
           ])))
)


let%client switch_visibility elt =
  let elt = Eliom_content.Html.To_dom.of_element elt in
  if Js.to_bool (elt##.classList##(contains (Js.string "hidden"))) then
    elt##.classList##remove (Js.string "hidden")
  else
    elt##.classList##add (Js.string "hidden")

(* let mywidget s1 s2 = Eliom_content.Html.D.(
 *   let button  = div ~a:[a_class ["button"]] [pcdata s1] in
 *   let content = div ~a:[a_class ["content"]] [pcdata s2] in
 *   let _ = [%client
 *     (Lwt.async (fun () ->
 *        Lwt_js_events.clicks (Eliom_content.Html.To_dom.of_element ~%button)
 *          (fun _ _ -> switch_visibility ~%content; Lwt.return ()))
 *      : unit)
 *   ] in
 *   div ~a:[a_class ["mywidget"]] [button; content]
 * )
 *
 * let () =
 *   Counter_app.register
 *     ~service:main_service
 *     (fun () () ->
 *       Lwt.return
 *         (Eliom_tools.F.html
 *            ~title:"counter"
 *            ~css:[["css";"counter.css"]; ["css"; "ex.css"]]
 *            Html.F.(body [
 *              h1 [pcdata "Welcome from Eliom's distillery!"];
 *              mywidget "Click me" "Hello!"
 *            ]))) *)
