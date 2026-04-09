import Component from "@glimmer/component";
import avatar from "discourse/helpers/avatar";
import InterfaceColorSelector from "discourse/components/interface-color-selector";
import { service } from "@ember/service";
import {
  applicationControllerFor,
  expandedDesktopSidebar,
  sidebarProfile,
} from "../lib/octoja-sidebar";

export default class OctojaSidebarFooter extends Component {
  @service currentUser;
  @service site;

  get applicationController() {
    return applicationControllerFor(this);
  }

  get shouldRender() {
    return expandedDesktopSidebar(this.site, this.applicationController);
  }

  get profile() {
    return sidebarProfile(this.currentUser);
  }

  <template>
    {{#if this.shouldRender}}
      <div class="octoja-sidebar-meta">
        <div class="octoja-sidebar-meta__footer">
          {{#if this.currentUser}}
            <a
              class="octoja-sidebar-profile"
              href={{this.profile.href}}
              data-user-card={{this.profile.username}}
              aria-label={{this.profile.primaryLabel}}
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
                <span class="octoja-sidebar-profile__name">{{this.profile.primaryLabel}}</span>
                <span class="octoja-sidebar-profile__meta">{{this.profile.secondaryLabel}}</span>
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
