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
%   tags |> List.iter (fun (id, tag) ->
%     let url = Printf.sprintf "/tags/%d" id in
    <p><a href="<%s url %>"><%s tag %></a></p>
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

let list_links links =
  <html>
  <body>
%   links |> List.iter (fun (id, title, _url, _description) ->
%     let url = Printf.sprintf "/links/%d" id in
      <p><a href="<%s url %>"><%s title %></a></p>
%   );
  </body>
  </html>

let add_link request =
  <html>
  <body>
    <h1>Add a new link</h1>
    <form method="post" action="/links">
      <%s! Dream.csrf_tag request %>
      <label for="title">Title: </label>
      <input name="title" autofocus>
      <label for="url">URL: </label>
      <input name="url">
      <label for="description">Description: </label>
      <input name="description">

      <input type="submit" value="Submit" />
    </form>

  </body>
  </html>

let view_link (link : Types.link) =
  <html>
  <body>
    <div>Title: <%s link.title %></div>
    <div>URL: <%s link.url %></div>
    <div>Desc: <%s link.description %></div>
  </body>
  </html>
