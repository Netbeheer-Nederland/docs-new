module.exports.register = function () {
  this.once('contentAggregated', ({ contentAggregate, playbook }) => {
    const outDir = `${playbook.env.PWD}/output/artifacts`
    const scriptsDir = `${playbook.env.PWD}/scripts`

    for (const { origins } of contentAggregate) {
      for (const origin of origins) {

        let collector = {}

        if (origin.descriptor.ext?.collection === undefined) {
          if (!origin.branch.match(/docs|docs-dev/)) continue  // Regular documentation: no work necessary.

          // Legacy data product repo
          collector = {
            run: {
              command: `${scriptsDir}/legacy/inject-global-nav.sh`,
              env: [
                {
                  'name': 'SRC',
                  'value': `./${origin.startPath}`
                }
              ]
            },
            scan: {
              dir: origin.startPath
            }
          }
        } else if (origin.descriptor.ext.collection === "nbnl-register") {
          collector = {
            run: {
              command: `${scriptsDir}/nbnl-register/generate-docs.sh`,
              env: [
                {
                  'name': 'NAME',
                  'value': origin.descriptor.name
                },
                {
                  'name': 'SRC',
                  'value': `./${origin.startPath}`
                },
                {
                  'name': 'OUT',
                  'value': outDir
                },
                {
                  'name': 'TEMPLATES_DIR',
                  'value': `${scriptsDir}/nbnl-register/templates`
                }
              ]
            },
            scan: {
              clean: true,
              dir: outDir
            }
          }
        } else if (origin.descriptor.ext.collection === "cim-dataproduct") {
          collector = {
            run: {
              command: `${scriptsDir}/cim-dataproduct/generate-docs.sh`,
              env: [
                {
                  'name': 'NAME',
                  'value': origin.descriptor.name
                },
                {
                  'name': 'SRC',
                  'value': `./${origin.startPath}`
                },
                {
                  'name': 'OUT',
                  'value': outDir
                }
              ]
            },
            scan: {
              clean: true,
              dir: outDir
            }
          }
        }
        Object.assign((origin.descriptor.ext ??= {}), { collector })
      }
    }
  })
}
