import { apiInitializer } from "discourse/lib/api";
import OctojaSidebarEdgeToggle from "../components/octoja-sidebar-edge-toggle";

export default apiInitializer((api) => {
  api.renderInOutlet("above-main-container", OctojaSidebarEdgeToggle);
});
