module.exports.register = function () {
  this.once('contentAggregated', ({ contentAggregate }) => {
    for (const { origins } of contentAggregate) {
      for (const origin of origins) {
        // if (origin.reftype !== 'branch') continue
        const collector = {
          run: {
            command: 'scripts/generate-register.sh',
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
                'value': 'scripts/conceptuele-informatiemodellen-templates'
              }
            ]
          },
          scan: {
              'dir': 'output/artifacts'
          }
        }
        Object.assign((origin.descriptor.ext ??= {}), { collector })
      }
    }
  })
}
