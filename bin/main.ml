module App = Pinboard_ml

let () =
  Dream.run
  @@ Dream.logger
  @@ Dream.sql_pool "sqlite3:db.sqlite"
  @@ Dream.memory_sessions
  @@ let open Lwt.Infix in Dream.router [
    Dream.get "/" (fun _ -> App.Templates.Layout.index |> Dream.html);

    Dream.scope "/links" [] [
      (* TODO: add redirect for trailing / *)
      Dream.get ""
        (fun request ->
          Dream.sql request App.Actions.Links.list >>= fun links -> App.Templates.Links.list links |> Dream.html);

      Dream.get "/new" (fun request -> App.Templates.Links.add request |> Dream.html);

      Dream.post ""
        (fun request ->
          match%lwt Dream.form request with
          | `Ok [ "description", description; "title", title; "url", url; ] ->
              Dream.sql request (App.Actions.Links.add (title, url, description)) >>= fun () -> Dream.redirect request "/links"
          | _ -> Dream.empty `Bad_Request);

      Dream.get "/:id" @@
        fun request ->
          (* TODO: make this a UUID? *)
          let id = Dream.param request "id" |> int_of_string in
          Dream.sql request (App.Actions.Links.get id) >>= function
            | Some (id, title, url, description) -> App.Templates.Links.show { id; title; url; description }  |> Dream.html;
            | None -> Dream.empty `Not_Found
    ];

    Dream.scope "/tags" [] [
      (* TODO: add redirect for trailing / *)
      Dream.get ""
        (fun request ->
          Dream.sql request App.Actions.Tags.list >>= fun tags -> App.Templates.Tags.list tags |> Dream.html);

      Dream.post "/"
        (fun request ->
          match%lwt Dream.form request with
          | `Ok [ "name", name ] ->
              Dream.sql request (App.Actions.Tags.add name) >>= fun () -> Dream.redirect request "/tags"
          | _ -> Dream.empty `Bad_Request);

      Dream.get "/new" (fun request -> App.Templates.Tags.add request |> Dream.html);

      Dream.get "/:id" @@
        fun request ->
          (* TODO: make this a UUID? *)
          let id = Dream.param request "id" |> int_of_string in
          Dream.sql request (App.Actions.Tags.get id) >>= function
            | Some (id, name) -> App.Templates.Tags.show { id; name }  |> Dream.html;
            | None -> Dream.empty `Not_Found

    ];
  ]
  (* @@ Dream.not_found *)
