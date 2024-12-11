module T = Caqti_type
module type DB = Caqti_lwt.CONNECTION

let list_links (module Db : DB) =
  let query =
    let open Caqti_request.Infix in (* this provides ->*  *)
    T.(unit ->* (t4 int string string string))
    "SELECT * FROM links" in
  let open Lwt.Infix in
  Db.collect_list query () >>= Caqti_lwt.or_fail

(* TODO: add saved_at *)
let add_link (title, url, description) (module Db : DB) =
  let query =
    let open Caqti_request.Infix in
    T.((t3 string string string) ->. unit)
    "INSERT INTO links (title, url, description) VALUES ($1, $2, $3)" in
  let open Lwt.Infix in
  Db.exec query (title, url, description) >>= Caqti_lwt.or_fail

let get_link name (module Db: DB) =
  let query =
    let open Caqti_request.Infix in
    T.(int ->? (t4 int string string string))
    "SELECT * from links WHERE id = $1" in
  let open Lwt.Infix in
  Db.find_opt query name >>= Caqti_lwt.or_fail


