import Component from "@glimmer/component";
import { action } from "@ember/object";
import { getOwner } from "@ember/owner";
import { service } from "@ember/service";
import DButton from "discourse/components/d-button";
import { i18n } from "discourse-i18n";
import { themePrefix } from "virtual:theme";

export default class OctojaSidebarCollapse extends Component {
  @service site;

  get applicationController() {
    return getOwner(this).lookup("controller:application");
  }

  get shouldRender() {
    return this.site.desktopView && this.applicationController?.showSidebar;
  }

  get sidebarCollapsed() {
    return !this.applicationController?.showSidebar;
  }

  get icon() {
    return this.sidebarCollapsed ? "chevron-right" : "chevron-left";
  }

  get title() {
    return i18n(
      themePrefix(
        this.sidebarCollapsed ? "expand_sidebar" : "collapse_sidebar"
      )
    );
  }

  @action
  toggleSidebar() {
    this.applicationController?.toggleSidebar();
  }

  <template>
    {{#if this.shouldRender}}
      <DButton
        @action={{this.toggleSidebar}}
        @icon={{this.icon}}
        @translatedTitle={{this.title}}
        @translatedAriaLabel={{this.title}}
        @ariaExpanded={{if this.sidebarCollapsed false true}}
        @ariaControls="d-sidebar"
        class="btn-flat sidebar-footer-actions-button sidebar-collapse-trigger octoja-sidebar-collapse"
      />
    {{/if}}
  </template>
}
