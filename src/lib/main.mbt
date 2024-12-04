pub(readonly) struct T {
  extentionToType : Map[String, String]
  typeToExtension : Map[String, String]
  typeToExtensions : Map[String, Array[String]]
}

pub fn T::new() -> T {
  let typesIter = types.iter()
  fn chooseFirst(item : (String, Array[String])) -> (String, String) {
    (item.0, item.1[0])
  }

  {
    extentionToType: typesIter.flat_map(
      fn { (k, xs) => xs.map(fn(x) { (x, k) }).iter() },
    ).to_array()
    |> Map::from_array,
    typeToExtension: typesIter.map(chooseFirst).to_array() |> Map::from_array,
    typeToExtensions: types,
  }
}

pub fn T::getType(self : T, pathOrExtension : String) -> String? {
  let mut extension = if pathOrExtension.contains(".") {
    pathOrExtension.split(".").to_array().rev()[0]
  } else {
    pathOrExtension
  }
  if extension.contains(";") {
    extension = extension.split(";").to_array()[0]
  }
  extension = extension.trim_space().to_lower()
  self.extentionToType.get(extension)
}

pub fn T::getExtension(self : T, mimeType : String) -> String? {
  let mime = mimeType.trim_space().to_lower()
  self.typeToExtension.get(mime)
}

pub fn T::getAllExtensions(self : T, mimeType : String) -> Array[String] {
  let mime = mimeType.trim_space().to_lower()
  self.typeToExtensions.get(mime).or([])
}

test {
  let mime = T::new()
  inspect!(
    mime.getType("txt"),
    content=
      #|Some("text/plain")
    ,
  )
  inspect!(
    mime.getType("main.js"),
    content=
      #|Some("text/javascript")
    ,
  )
  inspect!(
    mime.getExtension("text/html"),
    content=
      #|Some("html")
    ,
  )
  inspect!(
    mime.getAllExtensions("image/jpeg"),
    content=
      #|["jpeg", "jpg", "jpe"]
    ,
  )
}
