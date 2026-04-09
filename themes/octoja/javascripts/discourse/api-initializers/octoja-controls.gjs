import { apiInitializer } from "discourse/lib/api";
import OctojaCollapsedRail from "../components/octoja-collapsed-rail";
import OctojaSidebarEdgeToggle from "../components/octoja-sidebar-edge-toggle";

export default apiInitializer((api) => {
  api.renderInOutlet("above-main-container", OctojaCollapsedRail);
  api.renderInOutlet("above-main-container", OctojaSidebarEdgeToggle);
});
