open Knowledge
module Sys = Core.Sys
module Filename = Core.Filename

(**
  root
  ├── thought-1_123e4567-e89b-12d3-a456-426655440000
  │   ├── .metadata.json
  │   ├── file1.md
  │   └── file2.pdf
  └── thought-2_27ba5954-09e7-4822-a06d-3f29d5ec9856
      └── ...

  .metadata.json:
  ```json
  {
    "essence": string,
    "parents": [uuid],
    "children": [uuid],
  }
  ```
*)

(* TODO file system error handling *)
(* TODO uuid error *)
(* TODO metadata parse error *)
(* TODO attachments *)

type pensine_path = string

let metadata_filename = ".metadata.json"

let uuid_of_directory_name = let uuid_length = 36 in Core.Fn.compose Uuid.of_string (fun s -> String.sub s ((String.length s) - uuid_length) uuid_length)

let load_thought (uuid, metadata): (Thought.t * Uuid.t list * Uuid.t list) =
  let json = Yojson.Basic.from_string metadata in
  let open Yojson.Basic.Util in
  (
    {
      uuid=uuid;
      essence=json |> member "essence" |> to_string;
      parents=[];
      children=[];
      attachments=[];
    },
    [],
    []
  )

let load thought_nodes: Thought.t list option =
  thought_nodes
  |> List.map load_thought
  |> List.map (fun (t, _, _) -> t)
  |> List.filter (fun (thought : Thought.t) -> (List.length thought.parents) = 0)
  |> fun thoughts -> Some thoughts


let load_path (root: pensine_path): Thought.t list option =
  (* TODO link ts *)
  Sys.ls_dir root
  |> List.filter (Sys.is_directory_exn ~follow_symlinks:true)
  |> List.map (fun directory -> (uuid_of_directory_name directory, Core.In_channel.read_all (Filename.concat directory metadata_filename)))
  |> load
