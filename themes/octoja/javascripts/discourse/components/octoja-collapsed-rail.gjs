import Component from "@glimmer/component";
import avatar from "discourse/helpers/avatar";
import InterfaceColorSelector from "discourse/components/interface-color-selector";
import { service } from "@ember/service";
import icon from "discourse/helpers/d-icon";
import {
  applicationControllerFor,
  collapsedDesktopSidebar,
  collapsedRailItems,
  sidebarLogoUrl,
  sidebarProfile,
} from "../lib/octoja-sidebar";

export default class OctojaCollapsedRail extends Component {
  @service currentUser;
  @service router;
  @service site;
  @service siteSettings;

  get applicationController() {
    return applicationControllerFor(this);
  }

  get shouldRender() {
    return collapsedDesktopSidebar(this.site, this.applicationController);
  }

  get logoUrl() {
    return sidebarLogoUrl(this.siteSettings, { collapsed: true });
  }

  get profile() {
    return sidebarProfile(this.currentUser);
  }

  get items() {
    return collapsedRailItems({
      currentPath: this.router.currentURL || "/",
      currentUser: this.currentUser,
    });
  }

  <template>
    {{#if this.shouldRender}}
      <nav class="octoja-collapsed-rail" aria-label="Collapsed sidebar">
        <a
          class="octoja-collapsed-rail__brand"
          href="/"
          title={{this.siteSettings.title}}
        >
          {{#if this.logoUrl}}
            <img
              class="octoja-collapsed-rail__logo"
              src={{this.logoUrl}}
              alt={{this.siteSettings.title}}
            />
          {{else}}
            <span class="octoja-collapsed-rail__logo-fallback">
              {{this.siteSettings.title}}
            </span>
          {{/if}}
        </a>

        <div class="octoja-collapsed-rail__links">
          {{#each this.items as |item|}}
            <a
              class={{if
                item.active
                "octoja-collapsed-rail__link is-active"
                "octoja-collapsed-rail__link"
              }}
              href={{item.href}}
              title={{item.title}}
              aria-label={{item.title}}
            >
              {{icon item.icon}}
            </a>
          {{/each}}
        </div>

        <div class="octoja-collapsed-rail__footer">
          <div class="octoja-collapsed-rail__mode">
            <InterfaceColorSelector />
          </div>

          {{#if this.currentUser}}
            <a
              class="octoja-collapsed-rail__profile"
              href={{this.profile.href}}
              data-user-card={{this.profile.username}}
              aria-label={{this.profile.primaryLabel}}
            >
              {{avatar
                this.currentUser
                avatarTemplatePath="avatar_template"
                usernamePath="username"
                namePath="name"
                imageSize="large"
              }}
            </a>
          {{/if}}
        </div>
      </nav>
    {{/if}}
  </template>
}
