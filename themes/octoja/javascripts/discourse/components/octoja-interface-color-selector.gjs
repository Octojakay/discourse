import Component from "@glimmer/component";
import { service } from "@ember/service";
import InterfaceColorSelector from "discourse/components/interface-color-selector";

export default class OctojaInterfaceColorSelector extends Component {
  @service interfaceColor;

  get shouldRender() {
    return (
      this.interfaceColor.selectorAvailable &&
      !this.interfaceColor.selectorAvailableInSidebar &&
      !this.interfaceColor.selectorAvailableInHeader
    );
  }

  <template>
    {{#if this.shouldRender}}
      <InterfaceColorSelector />
    {{/if}}
  </template>
}
