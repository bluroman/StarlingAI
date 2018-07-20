package extensions.chromatic_aberration
{
	import starling.filters.FragmentFilter;
    import starling.rendering.FilterEffect;
 
	/**
	* Chromatic Aberration
	* USAGE:
	* var filter:CAFilter = new CAFilter();
	* filter.angle = 20; // best to put before intensity
	* filter.intensity = 20;
	* layer1.filter = filter;
	*/
    public class CAFilter extends FragmentFilter
    {
        public function CAFilter():void
        {
 
        }
 
        override protected function createEffect():FilterEffect
        {
            return new CAEffect();
        }
 
        private function get caEffect():CAEffect
        {
            return effect as CAEffect;
        }
 
		 public function get intensity():Number { return caEffect.intensity; }
		 public function set intensity(value:Number):void
        {
            caEffect.intensity = value;
            setRequiresRedraw();
        }
 
		public function get angle():Number { return caEffect.angle; }
		 public function set angle(value:Number):void
        {
			caEffect.angle = value;
            setRequiresRedraw();
        }
 
    }
}