import { LightningElement, api } from "lwc";

export default class ConCapBlockButton extends LightningElement {
  // Data
  @api item;
  @api selectedItem;

  // View
  @api showName;
  @api showDescription;
  @api align;
  @api minHeight;
  @api minWidth;

  // Set the style of the block based on the state of the button
  get selectedStyle() {
    let selectedStyle =
      "border: 1px solid #1589ee; box-shadow: inset 0 0 0 1px #1589ee; min-height:" +
      this.minHeight +
      "; min-width:" +
      this.minWidth +
      ";";
    let notSelectedStyle =
      "min-height:" + this.minHeight + "; min-width:" + this.minWidth + ";";

    return this.selectedItem === this.item.Name
      ? selectedStyle
      : notSelectedStyle;
  }

  // When the tile is clicked - bubble up to the parent and set the currently selected item
  selectItem() {
    if (this.selectedItem !== this.item.Name) {
      const selectEvent = new CustomEvent("buttonclick", {
        bubbles: true,
        detail: this.item
      });
      this.dispatchEvent(selectEvent);
    }
  }

  // Read the variable from the parent
  get getShowName() {
    return this.showName === "true" ? true : false;
  }

  // Read the variable from the parent
  get getShowDescription() {
    return this.showDescription === "true" ? true : false;
  }

  // Read the variable from the parent
  get textAlignment() {
    if (this.align === "center") {
      return "text-align:center;";
    }
    if (this.align === "left") {
      return "text-align:left;";
    }
    if (this.align === "right") {
      return "text-align:right;";
    }
  }
}
