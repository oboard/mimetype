# oboard/mimetype

An API for MIME type information.

- All `mime-db` types

## Installation

```bash
moon add oboard/mimetype
```

## Quick Start

For the full version (800+ MIME types, 1,000+ extensions):

```moonbit
let mime = @mimetype.new()
mime.get_type("txt")                    // ⇨ "text/plain"
mime.get_extension("text/plain")        // ⇨ Some("txt")
```

## API

### `mime.get_type(path_or_extension)`

Get mime type for the given file path or extension. E.g.

```moonbit
mime.get_type("js") // ⇨ "text/javascript"
mime.get_type("json") // ⇨ "application/json"

mime.get_type("txt") // ⇨ "text/plain"
mime.get_type("dir/text.txt") // ⇨ "text/plain"
mime.get_type("dir\\text.txt") // ⇨ "text/plain"
mime.get_type(".text.txt") // ⇨ "text/plain"
mime.get_type(".txt") // ⇨ "text/plain"
```

`None` is returned in cases where an extension is not detected or recognized

```moonbit
mime.get_type("foo/txt") // ⇨ None
mime.get_type("bogus_type") // ⇨ None
```

### `mime.get_extension(type)`

Get file extension for the given mime type. Charset options (often included in Content-Type headers) are ignored.

```moonbit
mime.get_extension("text/plain") // ⇨ Some("txt")
mime.get_extension("application/json") // ⇨ Some("json")
mime.get_extension("text/html; charset=utf8") // ⇨ Some("html")
```

### `mime.get_all_extensions(type)`

Get all file extensions for the given mime type.

```moonbit
mime.get_all_extensions("image/jpeg") // ⇨ ["jpeg", "jpg", "jpe"]
```
