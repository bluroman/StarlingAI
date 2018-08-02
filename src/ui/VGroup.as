package ui {
	
	import feathers.controls.ScrollContainer;

import ui.factory.LayoutFactory;


/**
	 * A ScrollContainer with a VerticalLayout.
	 */
	public class VGroup extends ScrollContainer {
		
		// CONSTRUCTOR :
		public function VGroup() {
			super();
			layout = LayoutFactory.getVLayout();
		}
	}
}