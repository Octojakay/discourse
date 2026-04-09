import Component from "@glimmer/component";
import { action } from "@ember/object";
import { service } from "@ember/service";
import DButton from "discourse/components/d-button";
import {
  loadColorSchemeStylesheet,
  updateColorSchemeCookie,
} from "discourse/lib/color-scheme-picker";
import { currentThemeId, listThemes } from "discourse/lib/theme-selector";
import { i18n } from "discourse-i18n";
import { themePrefix } from "virtual:theme";

export default class OctojaHeaderModeToggle extends Component {
  @service interfaceColor;
  @service site;
  @service session;

  get currentThemeIdValue() {
    return currentThemeId();
  }

  get lightStylesheets() {
    return Array.from(
      document.querySelectorAll("link.light-scheme, link#cs-preview-light")
    );
  }

  get darkStylesheets() {
    return Array.from(
      document.querySelectorAll("link.dark-scheme, link#cs-preview-dark")
    );
  }

  get lightSchemeLink() {
    return this.lightStylesheets[0];
  }

  get darkSchemeLink() {
    return this.darkStylesheets[0];
  }

  get currentTheme() {
    return listThemes(this.site)?.find(
      (theme) => theme.id === this.currentThemeIdValue
    );
  }

  get availableColorSchemes() {
    return this.site.user_color_schemes || [];
  }

  schemeById(id) {
    return this.availableColorSchemes.find((scheme) => scheme.id === id);
  }

  get themeColorSchemes() {
    const themeId = this.currentTheme?.id ?? this.currentThemeIdValue;

    return this.availableColorSchemes.filter(
      (scheme) => scheme.theme_id === themeId
    );
  }

  get themeSchemeCandidates() {
    const candidates = [...this.themeColorSchemes];

    [this.currentTheme?.color_scheme_id, this.currentTheme?.dark_color_scheme_id]
      .map((id) => this.schemeById(id))
      .filter(Boolean)
      .forEach((scheme) => {
        if (!candidates.some((candidate) => candidate.id === scheme.id)) {
          candidates.push(scheme);
        }
      });

    return candidates;
  }

  get resolvedLightScheme() {
    return (
      this.themeSchemeCandidates.find((scheme) => scheme.is_dark === false) ||
      this.themeSchemeCandidates.find(
        (scheme) => !String(scheme.name || "").toLowerCase().includes("dark")
      )
    );
  }

  get resolvedDarkScheme() {
    return (
      this.themeSchemeCandidates.find((scheme) => scheme.is_dark === true) ||
      this.themeSchemeCandidates.find((scheme) =>
        String(scheme.name || "").toLowerCase().includes("dark")
      )
    );
  }

  get themePrimarySchemeId() {
    return this.currentTheme?.color_scheme_id ?? null;
  }

  get themeSecondarySchemeId() {
    return this.currentTheme?.dark_color_scheme_id ?? null;
  }

  get lightSchemeIdFromDom() {
    const stylesheet = this.lightStylesheets.find((link) => link.dataset?.schemeId);
    const id = parseInt(stylesheet?.dataset?.schemeId, 10);
    return Number.isNaN(id) ? null : id;
  }

  get darkSchemeIdFromDom() {
    const stylesheet = this.darkStylesheets.find((link) => link.dataset?.schemeId);
    const id = parseInt(stylesheet?.dataset?.schemeId, 10);
    return Number.isNaN(id) ? null : id;
  }

  get fallbackLightSchemeIdFromTheme() {
    if (
      this.darkSchemeIdFromDom &&
      this.themePrimarySchemeId === this.darkSchemeIdFromDom
    ) {
      return this.themeSecondarySchemeId;
    }

    if (
      this.darkSchemeIdFromDom &&
      this.themeSecondarySchemeId === this.darkSchemeIdFromDom
    ) {
      return this.themePrimarySchemeId;
    }

    if (
      this.lightSchemeIdFromDom &&
      this.themePrimarySchemeId === this.lightSchemeIdFromDom
    ) {
      return this.themePrimarySchemeId;
    }

    if (
      this.lightSchemeIdFromDom &&
      this.themeSecondarySchemeId === this.lightSchemeIdFromDom
    ) {
      return this.themeSecondarySchemeId;
    }

    const primaryScheme = this.schemeById(this.themePrimarySchemeId);
    if (primaryScheme?.is_dark === false) {
      return primaryScheme.id;
    }

    const secondaryScheme = this.schemeById(this.themeSecondarySchemeId);
    if (secondaryScheme?.is_dark === false) {
      return secondaryScheme.id;
    }

    return null;
  }

  get fallbackDarkSchemeIdFromTheme() {
    if (
      this.lightSchemeIdFromDom &&
      this.themePrimarySchemeId === this.lightSchemeIdFromDom
    ) {
      return this.themeSecondarySchemeId;
    }

    if (
      this.lightSchemeIdFromDom &&
      this.themeSecondarySchemeId === this.lightSchemeIdFromDom
    ) {
      return this.themePrimarySchemeId;
    }

    if (
      this.darkSchemeIdFromDom &&
      this.themePrimarySchemeId === this.darkSchemeIdFromDom
    ) {
      return this.themePrimarySchemeId;
    }

    if (
      this.darkSchemeIdFromDom &&
      this.themeSecondarySchemeId === this.darkSchemeIdFromDom
    ) {
      return this.themeSecondarySchemeId;
    }

    const primaryScheme = this.schemeById(this.themePrimarySchemeId);
    if (primaryScheme?.is_dark === true) {
      return primaryScheme.id;
    }

    const secondaryScheme = this.schemeById(this.themeSecondarySchemeId);
    if (secondaryScheme?.is_dark === true) {
      return secondaryScheme.id;
    }

    return null;
  }

  get lightSchemeId() {
    return (
      this.lightSchemeIdFromDom ||
      this.resolvedLightScheme?.id ||
      this.fallbackLightSchemeIdFromTheme
    );
  }

  get darkSchemeId() {
    return (
      this.darkSchemeIdFromDom ||
      this.resolvedDarkScheme?.id ||
      this.fallbackDarkSchemeIdFromTheme
    );
  }

  get hasThemeSchemePair() {
    return (
      !!this.lightSchemeId &&
      !!this.darkSchemeId &&
      this.lightSchemeId !== this.darkSchemeId
    );
  }

  get isDark() {
    const schemeType =
      getComputedStyle(document.documentElement).getPropertyValue("--scheme-type") ||
      getComputedStyle(document.body).getPropertyValue("--scheme-type");

    if (schemeType.trim()) {
      return schemeType.trim() === "dark";
    }

    if (this.darkStylesheets.some((link) => link.media === "all")) {
      return true;
    }

    if (this.lightStylesheets.some((link) => link.media === "all")) {
      return false;
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

  tagPreviewStylesheet(id, schemeId, className) {
    const stylesheet = document.querySelector(`link#${id}`);

    if (stylesheet) {
      stylesheet.dataset.schemeId = String(schemeId);
      stylesheet.classList.add(className);
    }
  }

  async ensureThemeStylesheets() {
    if (!this.hasThemeSchemePair) {
      return false;
    }

    if (!this.lightStylesheets.length) {
      await loadColorSchemeStylesheet(this.lightSchemeId, this.currentThemeIdValue);
      this.tagPreviewStylesheet(
        "cs-preview-light",
        this.lightSchemeId,
        "light-scheme"
      );
    }

    if (!this.darkStylesheets.length) {
      await loadColorSchemeStylesheet(
        this.darkSchemeId,
        this.currentThemeIdValue,
        true
      );
      this.tagPreviewStylesheet("cs-preview-dark", this.darkSchemeId, "dark-scheme");
    }

    this.session.set("darkModeAvailable", true);

    return true;
  }

  applyMode(targetMode) {
    this.lightStylesheets.forEach((stylesheet) => {
      stylesheet.media = targetMode === "light" ? "all" : "none";
    });

    this.darkStylesheets.forEach((stylesheet) => {
      stylesheet.media = targetMode === "dark" ? "all" : "none";
    });

    if (targetMode === "light") {
      this.interfaceColor.forceLightMode({ flipStylesheets: false });
    } else {
      this.interfaceColor.forceDarkMode({ flipStylesheets: false });
    }
  }

  @action
  async toggleMode() {
    const stylesheetsReady = await this.ensureThemeStylesheets();

    if (!stylesheetsReady) {
      return;
    }

    updateColorSchemeCookie(this.lightSchemeId);
    updateColorSchemeCookie(this.darkSchemeId, { dark: true });

    this.applyMode(this.isDark ? "light" : "dark");
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
