///|
pub struct T {
  extention_to_type : @hashmap.T[String, String]
  type_to_extension : @hashmap.T[String, String]
  type_to_extensions : @hashmap.T[String, FixedArray[String]]
}

///|
pub fn T::new() -> T {
  {
    extention_to_type: types
    .iter()
    .flat_map(fn { (k, xs) => xs.iter().map(fn(x) { (x, k) }) })
    |> @hashmap.from_iter(),
    type_to_extension: types.iter().map(fn { (t, e) => (t, e[0]) })
    |> @hashmap.from_iter(),
    type_to_extensions: types.iter() |> @hashmap.from_iter(),
  }
}

///|
pub fn T::get_type(self : T, path_or_extension : String) -> String? {
  let after_dot = path_or_extension.split(".").last().or(path_or_extension)
  let extension = after_dot
    .split(";")
    .head()
    .or(after_dot)
    .trim_space()
    .to_lower()
  self.extention_to_type.get(extension)
}

///|
pub fn T::get_extension(self : T, mime_type : String) -> String? {
  let mime = mime_type.trim_space().to_lower()
  self.type_to_extension[mime]
}

///|
pub fn T::get_all_extensions(self : T, mime_type : String) -> Iter[String] {
  let mime = mime_type.trim_space().to_lower()
  self.type_to_extensions[mime].or([]).iter()
}

///|
test {
  let mime = T::new()
  inspect!(
    mime.get_type("txt"),
    content=
      #|Some("text/plain")
    ,
  )
  inspect!(
    mime.get_type("main.js"),
    content=
      #|Some("text/javascript")
    ,
  )
  inspect!(
    mime.get_extension("text/html"),
    content=
      #|Some("html")
    ,
  )
  inspect!(
    mime.get_all_extensions("image/jpeg"),
    content=
      #|["jpeg", "jpg", "jpe"]
    ,
  )
  inspect!(mime.get_extension("text/html; charset=utf8"), content="None")
}
