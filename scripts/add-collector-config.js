module.exports.register = function () {
  this.once('contentAggregated', ({ contentAggregate, playbook }) => {
    for (const { origins } of contentAggregate) {
      for (const origin of origins) {
        if (origin.descriptor.ext?.collection === undefined) continue

        let collector
        const outDir = `${playbook.env.PWD}/output/artifacts`
        const scriptsDir = `${playbook.env.PWD}/scripts`

        switch (origin.descriptor.ext.collection) {
          case "nbnl-register":
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
            break
          case "cim-dataproduct":
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
            break
        }
        Object.assign((origin.descriptor.ext ??= {}), { collector })
      }
    }
  })
}
