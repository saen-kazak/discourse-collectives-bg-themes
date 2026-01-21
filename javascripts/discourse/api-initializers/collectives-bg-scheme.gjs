import { apiInitializer } from "discourse/lib/api";
import DMenu from "float-kit/components/d-menu";
import DButton from "discourse/components/d-button";

import {
  COLOR_SCHEME_OVERRIDE_KEY,
  colorSchemeOverride,
} from "../lib/color-scheme-override";


const BG_KEY = "collectives_bg_scheme";
const BG_DEFAULT = "day";

function getBgScheme() {
  try {
    return localStorage.getItem(BG_KEY) || BG_DEFAULT;
  } catch {
    return BG_DEFAULT;
  }
}

function setBgScheme(value) {
  document.documentElement.dataset.bgScheme = value;
  try {
    localStorage.setItem(BG_KEY, value);
  } catch {}
}

function setSunrise()   { setBgScheme("sunrise"); }
function setDay()       { setBgScheme("day"); }
function setSunset()    { setBgScheme("sunset"); }
function setGreen()     { setBgScheme("green"); }
function setNight()     { setBgScheme("night"); }
function setCoral()     { setBgScheme("coral"); }
function setAstronaut() { setBgScheme("astronaut"); }


let keyValueStoreService = null;
let sessionService = null;

function readOverride() {
  try {
    return keyValueStoreService?.getItem(COLOR_SCHEME_OVERRIDE_KEY) || null; // "light" | "dark" | null
  } catch {
    return null;
  }
}

function applyOverride(override) {
  if (sessionService?.set) {
    sessionService.set("colorSchemeOverride", override);
  }
  colorSchemeOverride(override);
}

function setOverrideLight() {
  if (!keyValueStoreService) return;
  keyValueStoreService.setItem(COLOR_SCHEME_OVERRIDE_KEY, "light");
  applyOverride("light");
}

function setOverrideDark() {
  if (!keyValueStoreService) return;
  keyValueStoreService.setItem(COLOR_SCHEME_OVERRIDE_KEY, "dark");
  applyOverride("dark");
}

function setOverrideAuto() {
  if (!keyValueStoreService) return;
  keyValueStoreService.removeItem(COLOR_SCHEME_OVERRIDE_KEY);
  applyOverride(null);
}

export default apiInitializer("1.8.0", (api) => {
  console.log("Initialiser is loaded");

  const container = api.container || api._lookupContainer?.();

  if (container?.lookup) {
    keyValueStoreService = container.lookup("service:key-value-store");
    sessionService = container.lookup("service:session");
  }


  setBgScheme(getBgScheme());
  api.onPageChange(() => setBgScheme(getBgScheme()));

  applyOverride(readOverride());

  api.headerIcons.add(
    "collectives-theme-controls",
    <template>
      <DMenu class="icon btn-flat" @icon="circle-half-stroke" @title="Theme controls">
	    <div class="scheme-icons">
			<DButton class="scheme-icon" @translatedLabel="Light" @icon="sun"  @action={{setOverrideLight}} />
			<DButton class="scheme-icon" @translatedLabel="Dark"  @icon="moon" @action={{setOverrideDark}} />
			<DButton class="scheme-icon" @translatedLabel="🟠 Sunrise" @action={{setSunrise}} />
			<DButton class="scheme-icon" @translatedLabel="🔵 Day"       @action={{setDay}} />
			<DButton class="scheme-icon" @translatedLabel="🟡 Sunset"    @action={{setSunset}} />
			<DButton class="scheme-icon" @translatedLabel="🟣 Night"     @action={{setNight}} />
			<DButton class="scheme-icon" @translatedLabel="🟢 Green"     @action={{setGreen}} />
			<DButton class="scheme-icon" @translatedLabel="⚪ Coral"     @action={{setCoral}} />
			<DButton class="scheme-icon" @translatedLabel="⚫ Astronaut" @action={{setAstronaut}} />
		</div>
      </DMenu>
    </template>,
    { before: "hamburger" }
  );
});
