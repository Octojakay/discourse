import { apiInitializer } from "discourse/lib/api";
import OctojaHeaderModeToggle from "../components/octoja-header-mode-toggle";
import OctojaSidebarEdgeToggle from "../components/octoja-sidebar-edge-toggle";

export default apiInitializer((api) => {
  api.headerIcons.add("octoja-dark-mode", OctojaHeaderModeToggle, {
    before: "user-menu",
  });
  api.renderInOutlet("before-main-outlet", OctojaSidebarEdgeToggle);
});
