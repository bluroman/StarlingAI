package ui {
	
	import feathers.controls.ScrollContainer;
	
	import starling.display.DisplayObject;

import ui.factory.LayoutFactory;


/**
	 * A ScrollContainer with an HorizontalLayout.
	 */
	public class HGroup extends ScrollContainer {
		
		// CONSTRUCTOR :
		public function HGroup() {
			super();
			layout = LayoutFactory.getHLayout();
		}
	}
}