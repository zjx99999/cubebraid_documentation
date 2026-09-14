/* Clear Sphinx's temporary search highlight state when opening the homepage. */
(function () {
  const clearSearchHighlight = () => {
    try {
      window.localStorage.removeItem("sphinx_highlight_terms");
    } catch (error) {
      // Storage can be unavailable in private browsing or restricted contexts.
    }
  };

  const isHomepagePath = (pathname) => {
    const normalizedPath = pathname.replace(/\/+$/, "");
    return normalizedPath === "" || normalizedPath.endsWith("/index.html");
  };

  const isHomepageLink = (link) => {
    if (!link || !link.href) return false;

    try {
      const target = new URL(link.href, window.location.href);
      const current = new URL(window.location.href);
      return target.origin === current.origin && isHomepagePath(target.pathname);
    } catch (error) {
      return false;
    }
  };

  if (isHomepagePath(window.location.pathname)) clearSearchHighlight();

  document.addEventListener("click", (event) => {
    const link = event.target.closest && event.target.closest("a");
    if (isHomepageLink(link)) clearSearchHighlight();
  }, true);
})();
