module T = Caqti_type
module type DB = Caqti_lwt.CONNECTION

let list (module Db : DB) =
  let query =
    let open Caqti_request.Infix in (* this provides ->*  *)
    (* this means: do a SELECT with no WHERE, returning a tuple of (int, string) *)
    T.(unit ->* (t2 int string))
    "SELECT id, name FROM tags" in

  (* the first argument returns a promise, the second is the callback for when the
     promise is fulfilled, which also returns a promise (or is it a future?) *)

  (* these 4 are equivalent: *)

  (* 1. *)
  (* Lwt.bind (Db.collect_list query ()) Caqti_lwt.or_fail *)

  (* 2 *)
  (* let%lwt tags_or_error = Db.collect_list query () in *)
  (* Caqti_lwt.or_fail tags_or_error *)

  (* 3 *)
  (* let open Lwt.Infix in *)
  (* Db.collect_list query () >>= Caqti_lwt.or_fail *)

  (* 4 *)
  Lwt.(Db.collect_list query () >>= Caqti_lwt.or_fail)

let add text (module Db : DB) =
  let query =
    let open Caqti_request.Infix in
    T.(string ->. unit)
    "INSERT INTO tags (name) VALUES ($1)" in
  let open Lwt.Infix in
  Db.exec query text >>= Caqti_lwt.or_fail

let get name (module Db: DB) =
  let query =
    let open Caqti_request.Infix in
    T.(int ->? (t2 int string))
    "SELECT * from tags WHERE id = $1" in
  let open Lwt.Infix in
  Db.find_opt query name >>= Caqti_lwt.or_fail
