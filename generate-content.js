'use strict'
const { pathToFileURL } = require('node:url');


module.exports.register = function () {
  const logger = this.getLogger('logger')

  this.once('contentAggregated', ({ contentAggregate, playbook }) => {
    for (const { origins } of contentAggregate) {
      for (const origin of origins) {
        if (origin.reftype != "tag" || !origin.refname.startsWith("v")) continue
        if (origin.descriptor.type == "conceptual-model") {
          const collector = {
            run: {
              command: 'just scripts/conceptual-modeling/build',
              dir: '.'
              //dir: playbook.env.PWD,
            },
            // scan: './artifacts/',
          }
          Object.assign((origin.descriptor.ext ??= {}), { collector })
        }
        else if (origin.descriptor.type == "data-model") {
          logger.warn(origin.reftype)
          const collector = {
            run: {
              command: `just ${playbook.env.PWD}/scripts/data-modeling/build`,
              //dir: playbook.env.PWD,
            },
            scan: {
              dir: './artifacts/'
              //dir: `${playbook.env.PWD}/artifacts/${origin.descriptor.name}`,
            }
          }
          Object.assign((origin.descriptor.ext ??= {}), { collector })
        }
      }
    }
  })
}



/*
 *
 * Logic to scan the tag filter in the playbook.
 * This is a WIP.
 *
        if (origin.url.startsWith("file:")) {
          const contentSource = playbook.content.sources.filter(e => pathToFileURL(e.url) == origin.url)
        }
        else {
          const contentSource = playbook.content.sources.filter(e => e.url == origin.url)
        }
 *
*/
