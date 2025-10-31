module.exports.register = function () {
  this.once('contentAggregated', ({ contentAggregate, playbook }) => {
    const outDir = `${playbook.env.PWD}/output/artifacts`
    const scriptsDir = `${playbook.env.PWD}/scripts`

    for (const { origins } of contentAggregate) {
      for (const origin of origins) {

        let collector = {
          run: [{
            command: `${scriptsDir}/copy-to-out.sh`,
            env: [
              {
                'name': 'SRC',
                'value': `./${origin.startPath}`
              },
              {
                'name': 'OUT',
                'value': outDir
              },
            ]
          }]
        }

        if (origin.descriptor.ext?.collection === "nbnl-register") {
          collector.run.push({
            command: `${scriptsDir}/nbnl-register/generate-docs.sh`,
            env: [
              {
                'name': 'NAME',
                'value': origin.descriptor.name
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
          })
        } else if (origin.descriptor.ext?.collection === "cim-dataproduct") {
          collector.run.push({
            command: `${scriptsDir}/cim-dataproduct/generate-docs.sh`,
            env: [
              {
                'name': 'NAME',
                'value': origin.descriptor.name
              },
              {
                'name': 'OUT',
                'value': outDir
              }
            ]
          })
        }

        // Inject global navigation.
        if (!collector.run) {
          collector.run = []
        }
        collector.run.push({
          command: `$NODE ${scriptsDir}/legacy/inject-global-nav.js`,
          env: [
            {
              'name': 'OUT',
              'value': outDir
            }
          ]
        })

        collector.scan = {
          clean: true,
          dir: outDir
        }

        Object.assign((origin.descriptor.ext ??= {}), { collector })
      }
    }
  })
}
