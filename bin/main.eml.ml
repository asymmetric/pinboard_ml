let render tags request =
  <html>
  <body>

%   tags |> List.iter (fun (_id, tag) ->
      <p><%s tag %></p><% ); %>

    <form method="POST" action="/">
      <%s! Dream.csrf_tag request %>
      <input name="text" autofocus>
    </form>

  </body>
  </html>

let () =
  Dream.run
  @@ Dream.logger
  @@ Dream.sql_pool "sqlite3:db.sqlite?create=true"
  @@ Dream.sql_sessions
  @@ Dream.router [
    Dream.get "/" (fun _ -> Dream.html "pinboard_ml");

    (* return all tags *)
    Dream.get "/tags"
      @@ fun request ->
        Lwt.bind
          (Dream.sql request Pinboard_ml.Types.list_tags)
          (fun tags -> Dream.html (render tags request));

  ]
  (* @@ Dream.not_found *)
