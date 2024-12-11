let list tags =
  <html>
  <body>
%   tags |> List.iter (fun (id, tag) ->
%     let url = Printf.sprintf "/tags/%d" id in
    <p><a href="<%s url %>"><%s tag %></a></p>
%   );
  </body>
  </html>

let add request =
  <html>
  <body>
    <h1>Add a new tag</h1>
    <form method="POST" action="/tags">
      <%s! Dream.csrf_tag request %>
      <input name="name" autofocus>
    </form>

  </body>
  </html>

let show (tag : Types.tag) =
  <html>
  <body>
    <div><%s tag.name %></div>
  </body>
  </html>


