#!/bin/env bash

# Generate documentation for `cim-dataproduct`.


function generate_antora_component_version {
    echo Generating Antora component version…
    echo

    mkdir -p $OUT
    cp -r $SRC/* $OUT/

    mkdir -p $OUT/modules/schema
    uv run python -m linkml_asciidoc_generator.main \
        $SRC/../models/$NAME.linkml.yml \
        $OUT/modules/schema \
        --relations-diagrams
    #echo '- modules/schema/nav.adoc' >> $OUT/antora.yml
    echo
    cp $SRC/../models/$NAME.linkml.yml $OUT/modules/schema/attachments/
    echo … OK.
    echo
}


### Main

generate_antora_component_version
