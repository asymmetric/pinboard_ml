module type DB = Caqti_lwt.CONNECTION
module T = Caqti_type

type link = {
  id : int;
  title : string;
  url : string;
  description: string;
  (* should it actually be an array? *)
  tag_ids : int list;
  (* date *)
}

type tag = {
  id : int;
  name : string;
  link_id: int;
}

let list_tags =
  let query =
    let open Caqti_request.Infix in
    (T.unit ->* T.(tup2 int string))
    "SELECT id, name FROM tags" in
  fun (module Db : DB) ->
    Lwt.bind (Db.collect_list query ()) (fun tags_or_error -> Caqti_lwt.or_fail tags_or_error)
