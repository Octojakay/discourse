import { apiInitializer } from "discourse/lib/api";
import OctojaInterfaceColorSelector from "../components/octoja-interface-color-selector";
import OctojaSidebarCollapse from "../components/octoja-sidebar-collapse";

export default apiInitializer((api) => {
  api.renderInOutlet("sidebar-footer-actions", OctojaInterfaceColorSelector);
  api.renderInOutlet("sidebar-footer-actions", OctojaSidebarCollapse);
});
