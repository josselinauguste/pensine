type t = {
  uuid: Uuid.t;
  essence: string;
  parents: t list;
  children: t list;
  attachments: attachment list;
}
and attachment = FileName of string

let root loader: t = loader

