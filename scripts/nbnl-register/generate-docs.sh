#!/bin/env bash

# Generate documentation for `nbnl-register`.


function generate_antora_component_version {
    echo Generating Antora component version…
    echo

    rm -rf $OUT  # TODO: Why does `clean` in Antora Collector not do this properly?
    mkdir -p $OUT
    cp -r $SRC/* $OUT

    # Create ROOT module directories
    mkdir -p $OUT/modules/ROOT/attachments && touch $OUT/modules/ROOT/attachments/.gitkeep
    mkdir -p $OUT/modules/ROOT/examples && touch $OUT/modules/ROOT/examples/.gitkeep
    mkdir -p $OUT/modules/ROOT/images && touch $OUT/modules/ROOT/images/.gitkeep
    mkdir -p $OUT/modules/ROOT/pages && touch $OUT/modules/ROOT/pages/.gitkeep
    mkdir -p $OUT/modules/ROOT/partials && touch $OUT/modules/ROOT/partials/.gitkeep

    # Copy model source files into module
    mv $OUT/$NAME.linkml.yml $OUT/modules/ROOT/attachments/
    mv $OUT/$NAME.drawio.svg $OUT/modules/ROOT/images/

    # Create component version nav file
    # echo 'include::conceptuele-informatiemodellen::partial$nav.adoc[]' > "artifacts/documentation/$model/$version/modules/ROOT/nav.adoc"

    # Generate AsciiDoc
    uv run linkml generate doc \
        --template-directory $TEMPLATES_DIR \
        -d $OUT/modules/ROOT/pages \
        $SRC/$NAME.linkml.yml
    echo
    echo Renaming \`index.md\` to \`index.adoc\`…
    mv $OUT/modules/ROOT/pages/index.md $OUT/modules/ROOT/pages/index.adoc
    echo
    echo Removing unwanted files…
    find $OUT/modules/ROOT/pages -type f -name "*.md" -delete
    echo … OK.
}


### Main

generate_antora_component_version
