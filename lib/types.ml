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
