# elm-site-builder
A backend agnostic site builder. Written in Elm. [Demo](http://jakeactually.com:3001/static/index.html)

# How to
Include [site-builder.css](https://github.com/jakeactually/elm-site-builder/blob/master/dist/site-builder.css) and [site-builder.js](https://github.com/jakeactually/elm-site-builder/blob/master/dist/site-builder.js) in your html. Then you can inject it like this:

```javascript
const site = "http://localhost:3001";

SiteBuilder.init({
    container: container,
    schema: SiteBuilder.defaultSchema,
    thumbnailsUrl: site + "/static/files",
    fileManager: FileManager({
        api: site,
        thumbnailsUrl: site + "/static/files",
        uploadsUrl: site + "/upload",
        downloadsUrl: site + "/static/files",
    }),
    data:  ``
});
```

## Required
- **container** a node to insert the site builder.
- **thumbnailsUrl** a url for thumbnails. It gets the image name appended. Here is just a static server.
- **fileManager** a valid file manager, like [elm-file-manager](https://github.com/jakeactually/elm-file-manager).

## Optional
- **schema** a custom schema.
- **data** initial data.

## fileManager
A valid file manager is any object with these two functions:

- **open()** should open some interface to manage files.
- **onClose(callback: (\[String\]) => void)** should notify the site builder that some files were choosen files via the callback. The files must be an array of strings, these strings must be full file names (/dir/dir/file.ext)

## schema
An array of "blocks"

```javascript
{
    name: "Text",
    fields: [
        { type: 'RichText', id: 'content', title: "Content" },
        { type: 'Text', id: 'className', title: "Class" }
    ]
}
```

- **name** a custom name for the block.
- **fields** an array of "fields".
- **type** the type of the field. It must be one of the availables.
- **id** this will be used as a property in the generated json so it should be a valid variable name.
- **title** this will appear on top of the field when rendered.

The available fields are:
- Text
- TextArea
- RichText
- Image
- Images

Try `console.log(SiteBuilder.defaultSchema);` to inspect how the default blocks are made. Also you could add custom blocks by extending this array.

The site builder will use the schema to generate json like this. This json can be used in a server to render sites!. Blocks are rendered according to its "type", which comes from the name in the schema. Note how the "ids" from the schema are used as property names.

```json
[
    {
        "type": "Row",
        "id": "",
        "class": "",
        "columns": [
            {
                "id": "",
                "class": "",
                "rows": [
                    {
                        "type": "Text",
                        "content": "<p>Hello</p>",
                        "className": ""
                    }
                ]
            },
            {
                "id": "",
                "class": "",
                "rows": [
                    {
                        "type": "Image",
                        "image": "/Image 1.jpg",
                        "className": ""
                    }
                ]
            }
        ]
    }
]
```
