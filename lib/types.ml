type link = {
  id : int;
  title : string;
  url : string;
  description: string;
  (* TODO *)
  (* saved_at: Ptime.t; *)
}

type tag = {
  id : int;
  name : string;
}

type link_tag_mapping = {
  link_id: int;
  tag_id: int;
}
