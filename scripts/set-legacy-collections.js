module.exports.register = function () {
  this.once('contentAggregated', ({ contentAggregate, playbook }) => {
    for (const { origins } of contentAggregate) {
      for (const origin of origins) {
        if (origin.descriptor.name.startsWith("dp-")) {
          origin.descriptor.ext = { "collection": "cim-dataproduct" }
        }
      }
    }
  })
}
