(function () {
  const navContainer = document.querySelector('body > .nav-container')
  if (navContainer.dataset.component !== 'ROOT')
    return

  const ul = document.querySelector('nav.nav-menu ul');

  // Create a new <li> element.
  const li = document.createElement('li');
  li.classList.add('nav-item');
  li.dataset.depth = "0"

  const backToHome = document.createElement('a');
  backToHome.href = '/';
  backToHome.classList.add('nav-link');
  backToHome.textContent = 'Terug naar startpagina';

  // Add `↰`.
  const backToHomeSymbol = document.createElement('span');
  backToHomeSymbol.classList.add('nav-symbol');
  backToHomeSymbol.textContent = '↰ ';

  li.appendChild(backToHomeSymbol)
  li.appendChild(backToHome)

  // Prepend it to the <ul>.
  ul.prepend(li);
})();
