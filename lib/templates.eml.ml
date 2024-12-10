let index = 
  <html>
  <head>
    <title>pinboard_ml</title>
  </head>
  <body>
    <h1>pinboard_ml</h1>
    <p>Welcome to pinboard_ml</p>
  </body>
  </html>

let list_tags tags =
  <html>
  <body>
%   tags |> List.iter (fun (_id, tag) ->
      <p><%s tag %></p>
%   );
  </body>
  </html>

let add_tag request =
  <html>
  <body>
    <h1>Add a new tag</h1>
    <form method="POST" action="/tags">
      <%s! Dream.csrf_tag request %>
      <input name="name" autofocus>
    </form>

  </body>
  </html>

let view_tag (tag : Types.tag) =
  <html>
  <body>
    <div><%s tag.name %></div>
  </body>
  </html>


