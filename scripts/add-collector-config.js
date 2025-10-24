module.exports.register = function () {
  this.once('contentAggregated', ({ contentAggregate }) => {
    for (const { origins } of contentAggregate) {
      for (const origin of origins) {
        // if (origin.descriptor.ext.collection === 'data-product' && origin.reftype !== 'branch') continue
        if (origin.descriptor.ext?.collection === undefined) continue

        let collector
        switch (origin.descriptor.ext.collection) {
          case "nbnl-register":
            collector = {
              run: {
                command: 'scripts/nbnl-register/generate-docs.sh',
                env: [
                  {
                    'name': 'NAME',
                    'value': origin.descriptor.name
                  },
                  {
                    'name': 'SRC',
                    'value': origin.startPath
                  },
                  {
                    'name': 'OUT',
                    'value': 'output/artifacts'
                  },
                  {
                    'name': 'TEMPLATES_DIR',
                    'value': 'scripts/nbnl-register/templates'
                  }
                ]
              },
              scan: {
                  'dir': 'output/artifacts'
              }
            }
            break
          case "cim-dataproduct":
            collector = {
              run: {
                command: 'scripts/cim-dataproduct/generate-docs.sh',
                env: [
                  {
                    'name': 'NAME',
                    'value': origin.descriptor.name
                  },
                  {
                    'name': 'SRC',
                    'value': origin.startPath
                  },
                  {
                    'name': 'OUT',
                    'value': 'output/artifacts'
                  }
                ]
              },
              scan: {
                  'dir': 'output/artifacts'
              }
            }
            break
        }
        Object.assign((origin.descriptor.ext ??= {}), { collector })
      }
    }
  })
}
