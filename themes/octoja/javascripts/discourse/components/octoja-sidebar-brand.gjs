import Component from "@glimmer/component";
import { service } from "@ember/service";
import {
  applicationControllerFor,
  expandedDesktopSidebar,
  sidebarLogoUrl,
} from "../lib/octoja-sidebar";

export default class OctojaSidebarBrand extends Component {
  @service site;
  @service siteSettings;

  get applicationController() {
    return applicationControllerFor(this);
  }

  get shouldRender() {
    return expandedDesktopSidebar(this.site, this.applicationController);
  }

  get logoUrl() {
    return sidebarLogoUrl(this.siteSettings);
  }

  <template>
    {{#if this.shouldRender}}
      <a
        class="octoja-sidebar-brand"
        href="/"
        title={{this.siteSettings.title}}
        aria-label={{this.siteSettings.title}}
      >
        {{#if this.logoUrl}}
          <img
            class="octoja-sidebar-brand__logo"
            src={{this.logoUrl}}
            alt={{this.siteSettings.title}}
          />
        {{else}}
          <span class="octoja-sidebar-brand__fallback">
            {{this.siteSettings.title}}
          </span>
        {{/if}}
      </a>
    {{/if}}
  </template>
}
