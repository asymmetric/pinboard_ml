let list links =
  <html>
  <body>
%   links |> List.iter (fun (id, title, _url, _description) ->
%     let url = Printf.sprintf "/links/%d" id in
      <p><a href="<%s url %>"><%s title %></a></p>
%   );
  </body>
  </html>

let add request =
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

let show (link : Types.link) =
  <html>
  <body>
    <div>Title: <%s link.title %></div>
    <div>URL: <%s link.url %></div>
    <div>Desc: <%s link.description %></div>
  </body>
  </html>

