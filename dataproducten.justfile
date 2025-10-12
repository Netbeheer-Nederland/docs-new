set shell := ["bash", "-uc"]
set windows-shell := ["bash", "-uc"]

ref_name := "git rev-parse --abbrev-ref HEAD"
major_branch_name := "git rev-parse --abbrev-ref HEAD | cut -d . -f 1"

_default:
    @just --list --unsorted --justfile {{justfile()}}

# Build the project
[group("project")]
build name: # generate-json-schema generate-documentation generate-example-data validate-example-data
    #!/bin/env bash
    dir="src/dataproducten/{{ name }}"
    echo $dir
    if [ ! -d $dir ]; then echo "Directory \`$dir\` does not exist." && exit 1; fi
    echo "Generating documentation artifacts for data product '$name'…"
    echo
    cp -r "$dir/artifacts/information_models" "artifacts/documentation/modules/schema/attachments/"
    #cp -r "artifacts/schemas" "artifacts/documentation/modules/schema/attachments/"
    #cp -r "artifacts/examples" "artifacts/documentation/modules/schema/attachments/"
    #@echo "… OK."
    #@echo
    #@echo "All project artifacts have been generated and post-processed, and can found in: artifacts/"
    #@echo

# Generate documentation
[group("generators")]
generate-documentation:
    @echo "Generating documentation…"
    @echo
    cp -r "documentation" "artifacts"
    mkdir -p "artifacts/documentation/modules/schema"
    poetry run python -m linkml_asciidoc_generator.main \
        "artifacts/information_models/dp_capaciteitskaart.schema.linkml.yml" \
        "artifacts/documentation/modules/schema" \
        "--relations-diagrams"
    echo "- modules/schema/nav.adoc" >> artifacts/documentation/antora.yml
    @echo "… OK."
    @echo
    @echo -e "Generated documentation files at: artifacts/documentation"
    @echo

# Generate example data
[group("generators")]
generate-example-data:
    @echo "Generating JSON example data…"
    @echo
    mkdir -p "artifacts/examples"
    for example_file in examples/*.yml; do \
        [ -f "$example_file" ] || continue; \
        poetry run gen-linkml-profile  \
            convert \
            "$example_file" \
            --out "artifacts/${example_file%.*}.json"; \
    done
    @echo "… OK."
    @echo
    @echo -e "Generated example JSON data at: artifacts/examples"
    @echo

# Generate JSON Schema
[group("generators")]
generate-json-schema:
    @echo "Generating JSON Schema…"
    @echo
    mkdir -p "artifacts/schemas/json_schema"
    poetry run gen-json-schema \
        --not-closed \
        "artifacts/information_models/dp_capaciteitskaart.schema.linkml.yml" \
        > "artifacts/schemas/json_schema/dp_capaciteitskaart.json_schema.json"
    @echo "… OK."
    @echo
    @echo "Generated JSON Schema at: artifacts/schemas/json_schema/dp_capaciteitskaart.json_schema.json"
    @echo

# Validate example data
[group("validate")]
validate-example-data: generate-json-schema generate-example-data
    @echo "Validating example data against JSON schema…"
    @echo
    for example_file in artifacts/examples/*.json; do \
        [ -f "$example_file" ] || continue; \
        poetry run check-jsonschema --schemafile "artifacts/schemas/json_schema/dp_capaciteitskaart.json_schema.json" $example_file; \
    done
    @echo "… OK."
    @echo
