import Component from "@glimmer/component";
import { getOwner } from "@ember/owner";
import { service } from "@ember/service";
import icon from "discourse/helpers/d-icon";
import { i18n } from "discourse-i18n";

export default class OctojaCollapsedRail extends Component {
  @service currentUser;
  @service router;
  @service site;
  @service siteSettings;

  get applicationController() {
    return getOwner(this).lookup("controller:application");
  }

  get shouldRender() {
    return (
      this.site.desktopView &&
      this.applicationController?.sidebarEnabled &&
      !this.applicationController?.showSidebar
    );
  }

  get logoUrl() {
    return (
      this.siteSettings.site_logo_small_url || this.siteSettings.site_logo_url
    );
  }

  get currentPath() {
    return this.router.currentURL || "/";
  }

  get currentUsername() {
    return this.currentUser?.username_lower || this.currentUser?.username;
  }

  isActive(prefixes) {
    return prefixes.some(
      (prefix) =>
        this.currentPath === prefix ||
        (prefix !== "/" && this.currentPath.startsWith(prefix))
    );
  }

  get items() {
    const items = [
      {
        key: "topics",
        icon: "layer-group",
        href: "/latest",
        prefixes: ["/", "/latest", "/new", "/unread", "/top", "/hot"],
        title: i18n("sidebar.sections.community.links.topics.title"),
      },
      {
        key: "my-posts",
        icon: "user",
        href: "/my/activity",
        prefixes: [
          "/my/activity",
          this.currentUsername && `/u/${this.currentUsername}/activity`,
        ].filter(Boolean),
        title: i18n("sidebar.sections.community.links.my_posts.title"),
        visible: !!this.currentUser,
      },
      {
        key: "my-messages",
        icon: "inbox",
        href: "/my/messages",
        prefixes: [
          "/my/messages",
          this.currentUsername && `/u/${this.currentUsername}/messages`,
        ].filter(Boolean),
        title: i18n("sidebar.sections.community.links.my_messages.title"),
        visible: !!this.currentUser?.can_send_private_messages,
      },
      {
        key: "review",
        icon: "flag",
        href: "/review",
        prefixes: ["/review"],
        title: i18n("sidebar.sections.community.links.review.title"),
        visible: !!this.currentUser?.can_review,
      },
      {
        key: "admin",
        icon: "wrench",
        href: "/admin",
        prefixes: ["/admin"],
        title: i18n("sidebar.sections.community.links.admin.content"),
        visible: !!this.currentUser?.staff,
      },
      {
        key: "invite",
        icon: "paper-plane",
        href: "/new-invite",
        prefixes: ["/new-invite", "/invites"],
        title: i18n("sidebar.sections.community.links.invite.title"),
        visible: !!this.currentUser?.can_invite_to_forum,
      },
    ];

    return items
      .filter((item) => item.visible !== false)
      .map((item) => ({ ...item, active: this.isActive(item.prefixes) }));
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
      </nav>
    {{/if}}
  </template>
}
