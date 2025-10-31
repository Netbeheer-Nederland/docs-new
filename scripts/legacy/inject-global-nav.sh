#!/bin/env bash

# Inject global navigation for legacy projects.


function inject_global_nav {
    echo Injecting global navigation…
    echo

    # Overwrite and component version nav file
    echo 'include::ROOT::partial$nav.adoc[]' > $SRC/modules/ROOT/nav.adoc
    #echo -e "nav:\n  - modules/ROOT/nav.adoc" >> $SRC/antora.yml

    echo … OK.
    echo
}


### Main

inject_global_nav
