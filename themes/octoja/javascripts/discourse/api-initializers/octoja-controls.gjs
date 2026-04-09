import { apiInitializer } from "discourse/lib/api";
import OctojaModeToggle from "../components/octoja-mode-toggle";
import OctojaSidebarCollapse from "../components/octoja-sidebar-collapse";

export default apiInitializer((api) => {
  api.renderInOutlet("sidebar-footer-actions", OctojaModeToggle);
  api.renderInOutlet("sidebar-footer-actions", OctojaSidebarCollapse);
});
