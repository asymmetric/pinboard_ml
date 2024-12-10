module App = Pinboard_ml

let () =
  Dream.run
  @@ Dream.logger
  @@ Dream.sql_pool "sqlite3:db.sqlite"
  @@ Dream.memory_sessions
  @@ let open Lwt.Infix in Dream.router [
    Dream.get "/" (fun _ -> App.Templates.index |> Dream.html);

    (* return all tags *)
    Dream.get "/tags"
      (fun request ->
        Dream.sql request App.Actions.list_tags >>= fun tags -> App.Templates.list_tags tags |> Dream.html);

    Dream.post "/tags"
      (fun request ->
        match%lwt Dream.form request with
        | `Ok [ "name", name ] ->
            Dream.sql request (App.Actions.add_tag name) >>= fun () -> Dream.redirect request "/tags"
        | _ -> Dream.empty `Bad_Request);

    Dream.get "/tags/new" (fun request -> App.Templates.add_tag request |> Dream.html);

    Dream.get "/tags/:name" @@
      fun request ->
        let name = Dream.param request "name" in
        Dream.sql request (App.Actions.get_tag name) >>= function
          | Some (id, name, link_id) -> App.Templates.view_tag { id; name; link_id }  |> Dream.html;
          | None -> Dream.empty `Not_Found
  ]
  (* @@ Dream.not_found *)
