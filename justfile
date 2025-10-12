#set dotenv-required
#set dotenv-load
set shell := ["bash", "-uc"]
set windows-shell := ["bash", "-uc"]


ref_name := "git rev-parse --abbrev-ref HEAD"
major_branch_name := "git rev-parse --abbrev-ref HEAD | cut -d . -f 1"


_default:
    @just --list --unsorted --justfile {{justfile()}}

# Build the project
[group("project")]
build: clean generate-documentation
    @echo
    @echo "All project artifacts have been generated and post-processed, and can found in: artifacts/"
    @echo

# Clean up the output directory
[group("project")]
clean:
    @echo "Cleaning up generated artifacts…"
    @echo
    @if [ -d "artifacts" ]; then \
        rm -rf "artifacts"; \
    fi
    mkdir -p "artifacts"
    @echo "… OK."
    @echo

# Generate documentation
[group("generators")]
generate-documentation: clean
    #!/bin/env bash
    echo "Generating documentation…"
    echo
    mkdir "artifacts/documentation"
    cp -r "documentation" "artifacts/documentation/dataproducten"

    # Append main nav with "Models" heading
    echo -e '** Modellen' >> "artifacts/documentation/dataproducten/_/modules/ROOT/partials/nav.adoc"
    
    # Loop through models and their version
    for model_dir in models/* ; do \
        model=$(basename $model_dir) ; \
        mkdir -p "artifacts/documentation/$model"; \

        # Append main nav with this component
        echo "*** xref:$model::index.adoc[]" >> "artifacts/documentation/dataproducten/_/modules/ROOT/partials/nav.adoc"

        for version_dir in "$model_dir/"* ; do \
            version=$(basename $version_dir) ; \
            echo "$version"; \
            cp -r "models/$model/$version" "artifacts/documentation/$model/$version"; \

            # Generate antora.yml
            echo -e "name: $model\ntitle: $(grep -oP '(?<=title: ).*' models/$model/$version/$model.linkml.yml)\nversion: $version\nnav:\n  - modules/ROOT/nav.adoc" > "artifacts/documentation/$model/$version/antora.yml"

            # Create ROOT module directories
            mkdir -p "artifacts/documentation/$model/$version/modules/ROOT/attachments"; \
            mkdir -p "artifacts/documentation/$model/$version/modules/ROOT/examples"; \
            mkdir -p "artifacts/documentation/$model/$version/modules/ROOT/images"; \
            mkdir -p "artifacts/documentation/$model/$version/modules/ROOT/pages"; \
            mkdir -p "artifacts/documentation/$model/$version/modules/ROOT/partials"; \
            touch "artifacts/documentation/$model/$version/modules/ROOT/attachments/.gitkeep"; \
            touch "artifacts/documentation/$model/$version/modules/ROOT/examples/.gitkeep"; \
            touch "artifacts/documentation/$model/$version/modules/ROOT/images/.gitkeep"; \
            touch "artifacts/documentation/$model/$version/modules/ROOT/pages/.gitkeep"; \
            touch "artifacts/documentation/$model/$version/modules/ROOT/partials/.gitkeep"; \

            # Copy model source files into module
            mv "artifacts/documentation/$model/$version/$model.linkml.yml" "artifacts/documentation/$model/$version/modules/ROOT/attachments/"; \
            mv "artifacts/documentation/$model/$version/$model.drawio.svg" "artifacts/documentation/$model/$version/modules/ROOT/images/"; \

            # Create component version nav file
            echo 'include::dataproducten::partial$nav.adoc[]' > "artifacts/documentation/$model/$version/modules/ROOT/nav.adoc"

            # Generate AsciiDoc
            poetry run linkml generate doc \
                --template-directory templates \
                -d "artifacts/documentation/$model/$version/modules/ROOT/pages" \
                models/$model/$version/$model.linkml.yml; \
            echo; \
            echo Renaming \`index.md\` to \`index.adoc\`…; \
            mv "artifacts/documentation/$model/$version/modules/ROOT/pages/index.md" "artifacts/documentation/$model/$version/modules/ROOT/pages/index.adoc"; \
            echo; \
            echo Removing unwanted files…; \
            find "artifacts/documentation/$model/$version/modules/ROOT/pages" -type f -name "*.md" -delete; \
            echo "… OK."; \
            echo; \
            echo -e "Generated documentation files at: artifacts/documentation"; \
            echo; \
        done;
    done
    cat artifacts/documentation/dataproducten/_/modules/ROOT/partials/nav.adoc


