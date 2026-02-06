///|
#alias(T)
pub struct MimeType {
  extention_to_type : @hashmap.HashMap[String, String]
  type_to_extension : @hashmap.HashMap[String, String]
  type_to_extensions : @hashmap.HashMap[String, FixedArray[String]]
}

///|
/// Creates a new MIME type database with mappings between file extensions and
/// MIME types.
///
/// Returns a new MIME type database containing:
///
/// * A mapping from file extensions to MIME types
/// * A mapping from MIME types to their default file extensions
/// * A mapping from MIME types to all their associated file extensions
pub fn MimeType::new() -> MimeType {
  {
    extention_to_type: types
    .iter()
    .flat_map(t => {
      match t {
        (k, xs) => xs.iter().map(fn(x) { (x, k) })
      }
    })
    |> @hashmap.from_iter(),
    type_to_extension: types
    .iter()
    .map(t => {
      match t {
        (t, e) => (t, e[0])
      }
    })
    |> @hashmap.from_iter(),
    type_to_extensions: types.iter() |> @hashmap.from_iter(),
  }
}

///|
pub fn MimeType::get_type(
  self : MimeType,
  path_or_extension : String,
) -> String? {
  let after_dot = path_or_extension
    .split(".")
    .last()
    .unwrap_or(path_or_extension)
  let extension = after_dot
    .split(";")
    .head()
    .unwrap_or(after_dot)
    .trim()
    .to_lower()
    .to_string()
  self.extention_to_type.get(extension)
}

///|
pub fn MimeType::get_extension(self : MimeType, mime_type : String) -> String? {
  let mime = mime_type.trim().to_lower().to_string()
  self.type_to_extension.get(mime)
}

///|
pub fn MimeType::get_all_extensions(
  self : MimeType,
  mime_type : String,
) -> Iter[String] {
  let mime = mime_type.trim().to_lower().to_string()
  self.type_to_extensions.get(mime).unwrap_or([]).iter()
}

///|
test {
  let mime = MimeType::new()
  inspect(
    mime.get_type("txt"),
    content=(
      #|Some("text/plain")
    ),
  )
  inspect(
    mime.get_type("main.js"),
    content=(
      #|Some("text/javascript")
    ),
  )
  inspect(
    mime.get_extension("text/html"),
    content=(
      #|Some("html")
    ),
  )
  inspect(
    mime.get_all_extensions("image/jpeg"),
    content=(
      #|["jpeg", "jpg", "jpe"]
    ),
  )
  inspect(mime.get_extension("text/html; charset=utf8"), content="None")
}
