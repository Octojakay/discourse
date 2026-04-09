import Component from "@glimmer/component";
import { getOwner } from "@ember/owner";
import avatar from "discourse/helpers/avatar";
import InterfaceColorSelector from "discourse/components/interface-color-selector";
import { service } from "@ember/service";

export default class OctojaSidebarFooter extends Component {
  @service currentUser;
  @service interfaceColor;
  @service site;

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

  get profileHref() {
    return this.currentUser?.path || "/my/preferences/account";
  }

  get primaryLabel() {
    return this.currentUser?.name || this.currentUser?.username;
  }

  get secondaryLabel() {
    return this.currentUser?.email || `@${this.currentUser?.username || ""}`;
  }

  <template>
    {{#if this.shouldRender}}
      <div class="octoja-sidebar-meta">
        <div class="octoja-sidebar-meta__footer">
          {{#if this.currentUser}}
            <a
              class="octoja-sidebar-profile"
              href={{this.profileHref}}
              data-user-card={{this.currentUser.username}}
              aria-label={{this.primaryLabel}}
            >
              <span class="octoja-sidebar-profile__avatar">
                {{avatar
                  this.currentUser
                  avatarTemplatePath="avatar_template"
                  usernamePath="username"
                  namePath="name"
                  imageSize="large"
                }}
              </span>
              <span class="octoja-sidebar-profile__text">
                <span class="octoja-sidebar-profile__name">{{this.primaryLabel}}</span>
                <span class="octoja-sidebar-profile__meta">{{this.secondaryLabel}}</span>
              </span>
            </a>
          {{/if}}

          <div class="octoja-sidebar-meta__mode">
            <InterfaceColorSelector />
          </div>
        </div>
      </div>
    {{/if}}
  </template>
}
