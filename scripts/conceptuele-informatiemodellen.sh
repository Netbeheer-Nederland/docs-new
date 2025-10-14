#!/bin/env bash


COMPONENT_NAME=$1
COMPONENT_DIR_SRC=src/conceptuele-informatiemodellen/$COMPONENT_NAME
COMPONENT_DIR_OUT=output/artifacts/conceptuele-informatiemodellen/$COMPONENT_NAME


function generate_antora_component_version {
    local version=$1
    local component_version_dir_src=$COMPONENT_DIR_SRC/$version
    local component_version_dir_out=$COMPONENT_DIR_OUT/$version

    echo Generating Antora component version…
    echo

    # Append main nav with this component
    # echo "*** xref:$model::index.adoc[]" >> "artifacts/documentation/conceptuele-informatiemodellen/_/modules/ROOT/partials/nav.adoc"

    cp -r $component_version_dir_src $component_version_dir_out

    # Generate antora.yml
    echo -e "name: $COMPONENT_NAME\ntitle: $(grep -oP '(?<=title: ).*' $component_version_dir_src/$COMPONENT_NAME.linkml.yml)\nversion: $version\nnav:\n  - modules/ROOT/nav.adoc" > $component_version_dir_out/antora.yml

    # Create ROOT module directories
    mkdir -p $component_version_dir_out/modules/ROOT/attachments
    mkdir -p $component_version_dir_out/modules/ROOT/examples
    mkdir -p $component_version_dir_out/modules/ROOT/images
    mkdir -p $component_version_dir_out/modules/ROOT/pages
    mkdir -p $component_version_dir_out/modules/ROOT/partials
    touch $component_version_dir_out/modules/ROOT/attachments/.gitkeep
    touch $component_version_dir_out/modules/ROOT/examples/.gitkeep
    touch $component_version_dir_out/modules/ROOT/images/.gitkeep
    touch $component_version_dir_out/modules/ROOT/pages/.gitkeep
    touch $component_version_dir_out/modules/ROOT/partials/.gitkeep

    # Copy model source files into module
    mv $component_version_dir_out/$COMPONENT_NAME.linkml.yml $component_version_dir_out/modules/ROOT/attachments/
    mv $component_version_dir_out/$COMPONENT_NAME.drawio.svg $component_version_dir_out/modules/ROOT/images/

    # Create component version nav file
    # echo 'include::conceptuele-informatiemodellen::partial$nav.adoc[]' > "artifacts/documentation/$model/$version/modules/ROOT/nav.adoc"

    # Generate AsciiDoc
    uv run linkml generate doc \
        --template-directory scripts/conceptuele-informatiemodellen-templates \
        -d $component_version_dir_out/modules/ROOT/pages \
        $component_version_dir_src/$COMPONENT_NAME.linkml.yml
    echo
    echo Renaming \`index.md\` to \`index.adoc\`…
    mv $component_version_dir_out/modules/ROOT/pages/index.md $component_version_dir_out/modules/ROOT/pages/index.adoc
    echo
    echo Removing unwanted files…
    find $component_version_dir_out/modules/ROOT/pages -type f -name "*.md" -delete
    echo … OK.
}


function generate_antora_component {
    echo Generating Antora component…
    echo

    if [ ! -d $COMPONENT_DIR_SRC ] || [ -z $COMPONENT_NAME ] ; then
        echo Not a valid source directory: "$COMPONENT_DIR_SRC" && exit 1
    fi

    echo Cleaning $COMPONENT_DIR_OUT…
    rm -rf $COMPONENT_DIR_OUT
    mkdir -p $COMPONENT_DIR_OUT

    for version_dir in $COMPONENT_DIR_SRC/* ; do
        version=$(basename $version_dir)
        generate_antora_component_version $version
    done
    echo … OK.
    echo
    echo -e Generated documentation files at: output/artifacts/
}


### Main

generate_antora_component
