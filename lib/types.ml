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

let list_tags (module Db : Caqti_lwt.CONNECTION) =
  let query =
    let open Caqti_request.Infix in (* this provides ->*  *)
    (* this means: do a SELECT with no WHERE, returning a tuple of (int, string) *)
    T.(unit ->* (t2 int string))
    "SELECT id, name FROM tags" in

  (* the first argument returns a promise, the second is the callback for when the
     promise is fulfilled, which also returns a promise (or is it a future?) *)

  (* these 3 are equivalent: *)

  (* 1. *)
  (* Lwt.bind (Db.collect_list query ()) Caqti_lwt.or_fail *)

  (* 2 *)
  (* let open Lwt.Infix in *)
  (* Db.collect_list query () >>= Caqti_lwt.or_fail *)

  (* 3 *)
  Lwt.(Db.collect_list query () >>= Caqti_lwt.or_fail)
