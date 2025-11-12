(function () {
  const navMenuTitle = document.querySelector('nav.nav-menu h3')

  /* Add component home page. */
  const navContainer = document.querySelector('.nav-container')
  const componentName = navContainer.dataset.component
  const componentVersion = navContainer.dataset.version

  // Create a new <li> element.
  const compHome = document.createElement('li')
  compHome.classList.add('nav-item')
  compHome.dataset.depth = "0"

  const compHomeLink = document.createElement('a')
  compHomeLink.href = '/'
  compHomeLink.classList.add('nav-link')
  compHomeLink.textContent = 'Startpagina'

  // Add `↰`.
  const compHomeLinkSymbol = document.createElement('span')
  compHomeLinkSymbol.classList.add('nav-symbol')
  compHomeLinkSymbol.innerHTML = '<svg xmlns="http://www.w3.org/2000/svg" width="16px" height="16px" viewBox="0 -6 24 24"><path d="M6.906.384a1.75 1.75 0 0 1 2.187 0l5.25 4.2c.415.332.657.835.657 1.367v7.019a1.75 1.75 0 0 1-1.75 1.75h-2.5a.75.75 0 0 1-.75-.75V8.72H6v5.25a.75.75 0 0 1-.75.75h-2.5A1.75 1.75 0 0 1 1 12.97V5.95c0-.531.242-1.034.657-1.366l5.249-4.2Z"/></svg>'

  compHome.appendChild(compHomeLinkSymbol)
  compHome.appendChild(compHomeLink)

  /* Add "Back to Home". */

  // Create a new <li> element.
  const home = document.createElement('li')
  home.classList.add('nav-item')
  home.dataset.depth = "0"

  const homeLink = document.createElement('a')
  homeLink.href = navMenuTitle.firstChild.href
  homeLink.classList.add('nav-link')
  homeLink.textContent = navMenuTitle.textContent

  // Add `↰`.
  const homeLinkSymbol = document.createElement('span')
  homeLinkSymbol.classList.add('nav-symbol')
  homeLinkSymbol.textContent = ''

  home.appendChild(homeLinkSymbol)
  home.appendChild(homeLink)

  const ul = document.querySelector('nav.nav-menu ul')
  ul.prepend(home)
  ul.prepend(compHome)

  /* Remove nav component title. */
  navMenuTitle.remove()
})()
