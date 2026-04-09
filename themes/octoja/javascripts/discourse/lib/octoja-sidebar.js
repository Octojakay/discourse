import { getOwner } from "@ember/owner";
import { i18n } from "discourse-i18n";

export function applicationControllerFor(component) {
  return getOwner(component).lookup("controller:application");
}

export function desktopSidebarEnabled(site, applicationController) {
  return site.desktopView && applicationController?.sidebarEnabled;
}

export function expandedDesktopSidebar(site, applicationController) {
  return (
    desktopSidebarEnabled(site, applicationController) &&
    applicationController?.showSidebar
  );
}

export function collapsedDesktopSidebar(site, applicationController) {
  return (
    desktopSidebarEnabled(site, applicationController) &&
    !applicationController?.showSidebar
  );
}

export function sidebarLogoUrl(siteSettings, { collapsed = false } = {}) {
  return collapsed
    ? siteSettings.site_logo_small_url || siteSettings.site_logo_url
    : siteSettings.site_logo_url || siteSettings.site_logo_small_url;
}

export function sidebarProfile(currentUser) {
  return {
    href: currentUser?.path || "/my/preferences/account",
    primaryLabel: currentUser?.name || currentUser?.username,
    secondaryLabel: currentUser?.email || `@${currentUser?.username || ""}`,
    username: currentUser?.username,
  };
}

export function currentUsername(currentUser) {
  return currentUser?.username_lower || currentUser?.username;
}

export function currentPathMatches(currentPath, prefixes = []) {
  return prefixes.some(
    (prefix) =>
      currentPath === prefix ||
      (prefix !== "/" && currentPath.startsWith(prefix))
  );
}

export function collapsedRailItems({ currentPath, currentUser }) {
  const username = currentUsername(currentUser);

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
      prefixes: ["/my/activity", username && `/u/${username}/activity`].filter(
        Boolean
      ),
      title: i18n("sidebar.sections.community.links.my_posts.title"),
      visible: !!currentUser,
    },
    {
      key: "my-messages",
      icon: "inbox",
      href: "/my/messages",
      prefixes: ["/my/messages", username && `/u/${username}/messages`].filter(
        Boolean
      ),
      title: i18n("sidebar.sections.community.links.my_messages.title"),
      visible: !!currentUser?.can_send_private_messages,
    },
    {
      key: "review",
      icon: "flag",
      href: "/review",
      prefixes: ["/review"],
      title: i18n("sidebar.sections.community.links.review.title"),
      visible: !!currentUser?.can_review,
    },
    {
      key: "admin",
      icon: "wrench",
      href: "/admin",
      prefixes: ["/admin"],
      title: i18n("sidebar.sections.community.links.admin.content"),
      visible: !!currentUser?.staff,
    },
    {
      key: "invite",
      icon: "paper-plane",
      href: "/new-invite",
      prefixes: ["/new-invite", "/invites"],
      title: i18n("sidebar.sections.community.links.invite.title"),
      visible: !!currentUser?.can_invite_to_forum,
    },
  ];

  return items
    .filter((item) => item.visible !== false)
    .map((item) => ({
      ...item,
      active: currentPathMatches(currentPath, item.prefixes),
    }));
}
