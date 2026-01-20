import { apiInitializer } from "discourse/lib/api";
import DMenu from "float-kit/components/d-menu";
import DButton from "discourse/components/d-button";

import {
  COLOR_SCHEME_OVERRIDE_KEY,
  colorSchemeOverride,
} from "../lib/color-scheme-override";

const KEY = "collectives_bg_scheme";
const DEFAULT = "day";

function getScheme() {
  try {
    return localStorage.getItem(KEY) || DEFAULT;
  } catch {
    return DEFAULT;
  }
}

function setScheme(value) {
  document.documentElement.dataset.bgScheme = value;
  try {
    localStorage.setItem(KEY, value);
  } catch {}
}

function setSunrise()   { setScheme("sunrise"); }
function setDay()       { setScheme("day"); }
function setSunset()    { setScheme("sunset"); }
function setGreen()     { setScheme("green"); }
function setNight()     { setScheme("night"); }
function setCoral()     { setScheme("coral"); }
function setAstronaut() { setScheme("astronaut"); }

// Services (assigned in initializer)
let keyValueStoreService = null;
let sessionService = null;

function getOSMode() {
  return window.matchMedia("(prefers-color-scheme: dark)").matches ? "dark" : "light";
}

function getStoredOverride() {
  try {
    return keyValueStoreService?.getItem(COLOR_SCHEME_OVERRIDE_KEY) || null;
  } catch {
    return null;
  }
}

function toggleColorScheme() {
  if (!keyValueStoreService) {
    console.warn("keyValueStore service missing; cannot toggle color scheme");
    return;
  }

  const osMode = getOSMode();
  const current = getStoredOverride(); // "light" | "dark" | null

  if (osMode === "light") {
    if (current === "dark") {
      keyValueStoreService.removeItem(COLOR_SCHEME_OVERRIDE_KEY);
    } else {
      keyValueStoreService.setItem(COLOR_SCHEME_OVERRIDE_KEY, "dark");
    }
  } else {
    if (current !== "light") {
      keyValueStoreService.setItem(COLOR_SCHEME_OVERRIDE_KEY, "light");
    } else {
      keyValueStoreService.removeItem(COLOR_SCHEME_OVERRIDE_KEY);
    }
  }

  const newOverride = getStoredOverride();

  if (sessionService?.set) {
    sessionService.set("colorSchemeOverride", newOverride);
  }

  colorSchemeOverride(newOverride);
}

export default apiInitializer("1.8.0", (api) => {
  console.log("Initialiser is loaded");

  // Prefer the official container accessor if present
  const container =
    api.container ||
    api._lookupContainer?.();

  if (!container?.lookup) {
    console.warn("No container lookup available; light/dark toggle may not work");
  } else {
    keyValueStoreService = container.lookup("service:key-value-store");
    sessionService = container.lookup("service:session");
  }

  setScheme(getScheme());
  api.onPageChange(() => setScheme(getScheme()));

  api.headerIcons.add(
    "collectives-theme-controls",
    <template>
      <DMenu class="icon btn-flat" @icon="address-book" @title="Theme controls">
        <DButton @translatedLabel="Sunrise"   @action={{setSunrise}} />
        <DButton @translatedLabel="Day"       @action={{setDay}} />
        <DButton @translatedLabel="Sunset"    @action={{setSunset}} />
        <DButton @translatedLabel="Green"     @action={{setGreen}} />
        <DButton @translatedLabel="Night"     @action={{setNight}} />
        <DButton @translatedLabel="Coral"     @action={{setCoral}} />
        <DButton @translatedLabel="Astronaut" @action={{setAstronaut}} />

        <DButton
          @translatedLabel="Toggle Light/Dark"
          @icon="adjust"
          @action={{toggleColorScheme}}
        />
      </DMenu>
    </template>,
    { before: "search" }
  );
});
