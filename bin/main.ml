module App = Pinboard_ml

let () =
  Dream.run
  @@ Dream.logger
  @@ Dream.sql_pool "sqlite3:db.sqlite"
  @@ Dream.memory_sessions
  @@ let open Lwt.Infix in Dream.router [
    Dream.get "/" (fun _ -> App.Templates.index |> Dream.html);

    Dream.scope "/links" [] [
      (* TODO: add redirect for trailing / *)
      Dream.get ""
        (fun request ->
          Dream.sql request App.Actions.list_links >>= fun links -> App.Templates.list_links links |> Dream.html);

      Dream.get "/new" (fun request -> App.Templates.add_link request |> Dream.html);

      Dream.post ""
        (fun request ->
          match%lwt Dream.form request with
          | `Ok [ "description", description; "title", title; "url", url; ] ->
              Dream.sql request (App.Actions.add_link (title, url, description)) >>= fun () -> Dream.redirect request "/links"
          | _ -> Dream.empty `Bad_Request);

      Dream.get "/:id" @@
        fun request ->
          (* TODO: make this a UUID? *)
          let id = Dream.param request "id" |> int_of_string in
          Dream.sql request (App.Actions.get_link id) >>= function
            | Some (id, title, url, description) -> App.Templates.view_link { id; title; url; description }  |> Dream.html;
            | None -> Dream.empty `Not_Found
    ];

    Dream.scope "/tags" [] [
      (* TODO: add redirect for trailing / *)
      Dream.get ""
        (fun request ->
          Dream.sql request App.Actions.list_tags >>= fun tags -> App.Templates.list_tags tags |> Dream.html);

      Dream.post "/"
        (fun request ->
          match%lwt Dream.form request with
          | `Ok [ "name", name ] ->
              Dream.sql request (App.Actions.add_tag name) >>= fun () -> Dream.redirect request "/tags"
          | _ -> Dream.empty `Bad_Request);

      Dream.get "/new" (fun request -> App.Templates.add_tag request |> Dream.html);

      Dream.get "/:id" @@
        fun request ->
          (* TODO: make this a UUID? *)
          let id = Dream.param request "id" |> int_of_string in
          Dream.sql request (App.Actions.get_tag id) >>= function
            | Some (id, name) -> App.Templates.view_tag { id; name }  |> Dream.html;
            | None -> Dream.empty `Not_Found

    ];
  ]
  (* @@ Dream.not_found *)
