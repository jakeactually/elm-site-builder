elm make src/SiteBuilder.elm --output src/output.js
cat src\output.js, src\wrapper.js | sc dist\site-builder.js
copy dist\* ..\elm-site-builder-demo\static
