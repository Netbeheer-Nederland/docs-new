#!/bin/env bash

# Generate documentation for `cim-dataproduct`.


function generate_antora_component_version {
    echo Generating Antora component version…
    echo

    mv $OUT/documentation/* $OUT/
    rmdir $OUT/documentation

    mkdir -p $OUT/modules/schema
    uv run python -m linkml_asciidoc_generator.main \
        $OUT/models/$NAME.linkml.yml \
        $OUT/modules/schema \
        --relations-diagrams

    # Create and register component version nav file
    echo 'include::ROOT::partial$nav.adoc[]' > $OUT/modules/ROOT/nav.adoc
    echo -e "nav:\n  - modules/ROOT/nav.adoc" >> $OUT/antora.yml

    echo
    cp $OUT/models/$NAME.linkml.yml $OUT/modules/schema/attachments/

    echo … OK.
    echo
}


### Main

generate_antora_component_version
