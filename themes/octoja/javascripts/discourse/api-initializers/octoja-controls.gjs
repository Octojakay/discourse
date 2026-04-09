import { apiInitializer } from "discourse/lib/api";
import OctojaCollapsedRail from "../components/octoja-collapsed-rail";
import OctojaSidebarBrand from "../components/octoja-sidebar-brand";
import OctojaSidebarFooter from "../components/octoja-sidebar-footer";
import OctojaSidebarEdgeToggle from "../components/octoja-sidebar-edge-toggle";

export default apiInitializer((api) => {
  api.renderInOutlet("above-main-container", OctojaCollapsedRail);
  api.renderInOutlet("above-main-container", OctojaSidebarEdgeToggle);
  api.renderInOutlet("before-sidebar-sections", OctojaSidebarBrand);
  api.renderInOutlet("after-sidebar-sections", OctojaSidebarFooter);
});
