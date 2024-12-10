module App = Pinboard_ml

let render_index = 
  <html>
  <head>
    <title>pinboard_ml</title>
  </head>
  <body>
    <h1>pinboard_ml</h1>
    <p>Welcome to pinboard_ml</p>
  </body>
  </html>

let render_tags tags =
  <html>
  <body>
%   tags |> List.iter (fun (_id, tag) ->
      <p><%s tag %></p>
%   );
  </body>
  </html>

let render_add_tag request =
  <html>
  <body>
    <h1>Add a new tag</h1>
    <form method="POST" action="/tags">
      <%s! Dream.csrf_tag request %>
      <input name="name" autofocus>
    </form>

  </body>
  </html>

let render_view_tag (tag : App.Types.tag) =
  <html>
  <body>
    <div><%s tag.name %></div>
  </body>
  </html>

let () =
  Dream.run
  @@ Dream.logger
  @@ Dream.sql_pool "sqlite3:db.sqlite"
  @@ Dream.memory_sessions
  @@ let open Lwt.Infix in Dream.router [
    Dream.get "/" (fun _ -> render_index |> Dream.html);

    (* return all tags *)
    Dream.get "/tags"
      (fun request ->
        Dream.sql request App.Types.list_tags >>= fun tags -> render_tags tags |> Dream.html);

    Dream.post "/tags"
      (fun request ->
        match%lwt Dream.form request with
        | `Ok [ "name", name ] ->
            Dream.sql request (App.Types.add_tag name) >>= fun () -> Dream.redirect request "/tags"
        | _ -> Dream.empty `Bad_Request);

    Dream.get "/tags/new" (fun request -> render_add_tag request |> Dream.html);

    Dream.get "/tags/:name" @@
      fun request ->
        let name = Dream.param request "name" in
        Dream.sql request (App.Types.get_tag name) >>= function
          | Some (id, name, link_id) ->
            let tag : App.Types.tag = { id = id; name = name; link_id = link_id } in
            render_view_tag tag |> Dream.html;
          | None -> Dream.empty `Not_Found
  ]
  (* @@ Dream.not_found *)
