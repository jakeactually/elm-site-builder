if [ $1 = "optimize" ]
    then
        elm make src/SiteBuilder.elm --optimize --output src/output.js
        args="pure_funcs='F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9',pure_getters,keep_fargs=false,unsafe_comps,unsafe"
        uglifyjs src/output.js src/wrapper.js -c $args -o dist/site-builder.js
        uglifyjs dist/site-builder.js -m -o dist/site-builder.js
    else
        elm make src/SiteBuilder.elm --output dist/site-builder.js
        cat src/wrapper.js >> dist/site-builder.js
fi
