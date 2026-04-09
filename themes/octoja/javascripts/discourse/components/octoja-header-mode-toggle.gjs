import Component from "@glimmer/component";
import { action } from "@ember/object";
import { service } from "@ember/service";
import DButton from "discourse/components/d-button";
import cookie from "discourse/lib/cookie";
import {
  loadColorSchemeStylesheet,
  updateColorSchemeCookie,
} from "discourse/lib/color-scheme-picker";
import { reload } from "discourse/helpers/page-reloader";
import { currentThemeId, listThemes } from "discourse/lib/theme-selector";
import { i18n } from "discourse-i18n";
import { themePrefix } from "virtual:theme";

const FORCED_COLOR_MODE_COOKIE = "forced_color_mode";
const COOKIE_EXPIRY_DAYS = 365;

export default class OctojaHeaderModeToggle extends Component {
  @service interfaceColor;
  @service site;
  @service session;

  get lightSchemeLink() {
    return document.querySelector("link.light-scheme");
  }

  get darkSchemeLink() {
    return document.querySelector("link.dark-scheme");
  }

  get currentTheme() {
    return listThemes(this.site)?.find((theme) => theme.id === currentThemeId());
  }

  get lightSchemeIdFromDom() {
    const id = parseInt(this.lightSchemeLink?.dataset?.schemeId, 10);
    return Number.isNaN(id) ? null : id;
  }

  get darkSchemeIdFromDom() {
    const id = parseInt(this.darkSchemeLink?.dataset?.schemeId, 10);
    return Number.isNaN(id) ? null : id;
  }

  get lightSchemeId() {
    return this.lightSchemeIdFromDom || this.currentTheme?.color_scheme_id;
  }

  get darkSchemeId() {
    return this.darkSchemeIdFromDom || this.currentTheme?.dark_color_scheme_id;
  }

  get hasThemeSchemePair() {
    return (
      !!this.currentTheme?.id &&
      !!this.lightSchemeId &&
      !!this.darkSchemeId &&
      this.lightSchemeId !== this.darkSchemeId
    );
  }

  get isDark() {
    if (this.darkSchemeLink) {
      return this.darkSchemeLink.media === "all";
    }

    return this.interfaceColor.colorMode === "dark";
  }

  get icon() {
    return this.isDark ? "sun" : "moon";
  }

  get title() {
    return i18n(
      themePrefix(this.isDark ? "switch_to_light" : "switch_to_dark")
    );
  }

  async ensureThemeStylesheets() {
    if (
      (this.lightSchemeLink && this.darkSchemeLink) ||
      !this.hasThemeSchemePair
    ) {
      return;
    }

    await loadColorSchemeStylesheet(this.lightSchemeId, this.currentTheme.id);
    await loadColorSchemeStylesheet(
      this.darkSchemeId,
      this.currentTheme.id,
      true
    );

    updateColorSchemeCookie(this.lightSchemeId);
    updateColorSchemeCookie(this.darkSchemeId, { dark: true });
    this.session.set("darkModeAvailable", true);
  }

  @action
  async toggleMode() {
    await this.ensureThemeStylesheets();

    const targetMode = this.isDark ? "light" : "dark";

    if (this.hasThemeSchemePair) {
      updateColorSchemeCookie(this.lightSchemeId);
      updateColorSchemeCookie(this.darkSchemeId, { dark: true });
      this.session.set("darkModeAvailable", true);
    }

    cookie(FORCED_COLOR_MODE_COOKIE, targetMode, {
      path: "/",
      expires: COOKIE_EXPIRY_DAYS,
    });

    if (targetMode === "light") {
      this.interfaceColor.forceLightMode();
    } else {
      this.interfaceColor.forceDarkMode();
    }

    reload();
  }

  <template>
    <li class="header-dropdown-toggle octoja-header-mode-toggle">
      <DButton
        @action={{this.toggleMode}}
        @icon={{this.icon}}
        @translatedTitle={{this.title}}
        @translatedAriaLabel={{this.title}}
        class="btn no-text btn-icon btn-flat icon octoja-header-mode-toggle__button"
      />
    </li>
  </template>
}
