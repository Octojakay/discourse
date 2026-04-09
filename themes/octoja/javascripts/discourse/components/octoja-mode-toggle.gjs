import Component from "@glimmer/component";
import { action } from "@ember/object";
import { service } from "@ember/service";
import DButton from "discourse/components/d-button";
import { i18n } from "discourse-i18n";
import { themePrefix } from "virtual:theme";

export default class OctojaModeToggle extends Component {
  @service interfaceColor;

  get lightSchemeLink() {
    return document.querySelector("link.light-scheme");
  }

  get darkSchemeLink() {
    return document.querySelector("link.dark-scheme");
  }

  get shouldRender() {
    return !!this.lightSchemeLink && !!this.darkSchemeLink;
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

  @action
  toggleMode() {
    if (this.isDark) {
      this.interfaceColor.forceLightMode();
    } else {
      this.interfaceColor.forceDarkMode();
    }
  }

  <template>
    {{#if this.shouldRender}}
      <DButton
        @action={{this.toggleMode}}
        @icon={{this.icon}}
        @translatedTitle={{this.title}}
        @translatedAriaLabel={{this.title}}
        class="btn-flat sidebar-footer-actions-button octoja-mode-toggle"
      />
    {{/if}}
  </template>
}
