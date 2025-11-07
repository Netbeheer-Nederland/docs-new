'use strict'

const expandPath = require('@antora/expand-path-helper')
const util = require('util')
const { promises: fsp } = require('fs')

module.exports.register = function () {
  this.once('beforePublish', async ({ playbook, siteAsciiDocConfig, contentCatalog, siteCatalog }) => {
    const { 'site-component-order': siteComponentOrder, 'site-navigation-data-path': siteNavigationDataPath } =
      siteAsciiDocConfig.attributes
    const ownComponents = contentCatalog.getComponents().filter(({ site }) => !site)

    console.log(util.inspect(ownComponents, {showHidden: false, depth: null, colors: true}))
  })
}
