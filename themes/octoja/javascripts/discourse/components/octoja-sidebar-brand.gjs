import Component from "@glimmer/component";
import { getOwner } from "@ember/owner";
import { service } from "@ember/service";

export default class OctojaSidebarBrand extends Component {
  @service site;
  @service siteSettings;

  get applicationController() {
    return getOwner(this).lookup("controller:application");
  }

  get shouldRender() {
    return (
      this.site.desktopView &&
      this.applicationController?.sidebarEnabled &&
      this.applicationController?.showSidebar
    );
  }

  get logoUrl() {
    return this.siteSettings.site_logo_url || this.siteSettings.site_logo_small_url;
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
