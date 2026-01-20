import { apiInitializer } from "discourse/lib/api";
import DMenu from "float-kit/components/d-menu";
import DButton from "discourse/components/d-button";

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

export default apiInitializer("1.8.0", (api) => {
  console.log("Initialiser is loaded");

  setScheme(getScheme());
  api.onPageChange(() => setScheme(getScheme()));

  api.headerIcons.add(
    "collectives-bg-scheme",
    <template>
      <DMenu class="icon btn-flat" @icon="address-book" @title="Background scheme">
        <DButton @translatedLabel="Sunrise"   @action={{setSunrise}} />
        <DButton @translatedLabel="Day"       @action={{setDay}} />
        <DButton @translatedLabel="Sunset"    @action={{setSunset}} />
        <DButton @translatedLabel="Green"     @action={{setGreen}} />
        <DButton @translatedLabel="Night"     @action={{setNight}} />
        <DButton @translatedLabel="Coral"     @action={{setCoral}} />
        <DButton @translatedLabel="Astronaut" @action={{setAstronaut}} />
      </DMenu>
    </template>,
    { before: "search" }
  );
});