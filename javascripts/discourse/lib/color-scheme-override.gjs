export const COLOR_SCHEME_OVERRIDE_KEY = "color_scheme_override";

export function colorSchemeOverride(type) {
  const lightScheme = document.querySelector("link.light-scheme");
  const darkScheme =
    document.querySelector("link.dark-scheme") ||
    document.querySelector("link#cs-preview-dark");

  // If neither exists, nothing to do
  if (!lightScheme && !darkScheme) {
    return;
  }

  // Helper: stash original media once
  const stash = (el) => {
    if (!el) return;
    if (el.origMedia == null) el.origMedia = el.media;
  };

  // Helper: restore and clean up
  const restore = (el) => {
    if (!el) return;
    if (el.origMedia != null) {
      el.media = el.origMedia;
      delete el.origMedia;
    }
  };

  switch (type) {
    case "dark":
      stash(lightScheme);
      if (lightScheme) lightScheme.media = "none";

      stash(darkScheme);
      if (darkScheme) darkScheme.media = "all";
      break;

    case "light":
      stash(lightScheme);
      if (lightScheme) lightScheme.media = "all";

      stash(darkScheme);
      if (darkScheme) darkScheme.media = "none";
      break;

    default:
      restore(lightScheme);
      restore(darkScheme);
      break;
  }

  changeHomeLogo(type);
}

export function changeHomeLogo(type) {
  const logoDarkSrc = document.querySelector(".title picture source");
  if (!logoDarkSrc) return;

  const stash = () => {
    if (logoDarkSrc.origMedia == null) logoDarkSrc.origMedia = logoDarkSrc.media;
  };

  const restore = () => {
    if (logoDarkSrc.origMedia != null) {
      logoDarkSrc.media = logoDarkSrc.origMedia;
      delete logoDarkSrc.origMedia;
    }
  };

  switch (type) {
    case "dark":
      stash();
      logoDarkSrc.media = "all";
      break;
    case "light":
      stash();
      logoDarkSrc.media = "none";
      break;
    default:
      restore();
      break;
  }
}