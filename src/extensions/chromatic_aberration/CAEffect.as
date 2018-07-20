package extensions.chromatic_aberration
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	 
	import starling.rendering.FilterEffect;
	import starling.rendering.Program;
	 
	internal class CAEffect extends FilterEffect
	{
	 
		private var _constants:Vector.<Number>;
		private var _intensity:Number;
		private var _angle:Number;
	 
		public function CAEffect()
		{
			 _constants = new Vector.<Number>(4, true);
			 _intensity = 0;
			 _angle = 0;
		}
	 
		override protected function createProgram():Program
		{
			var vertexShader:String = STD_VERTEX_SHADER;
			var fragmentShader:String = [
				"tex ft0, v0, fs0 <2d, clamp, linear, mipnone>",
				"add ft3.xyzw, fc0.xyzw, v0.xyxy",
				"tex ft1, ft3.xy, fs0 <2d, clamp, linear, mipnone>",
				"tex ft2, ft3.zw, fs0 <2d, clamp, linear, mipnone>",
				"mov ft0.x, ft1.x",
				"mov ft0.z, ft2.z",
				"mov oc, ft0"
			].join("\n");
	 
			return Program.fromSource(vertexShader, fragmentShader);
		}
	 
		override protected function beforeDraw(context:Context3D):void
		{
			context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, _constants, int(_constants.length / 4));
			super.beforeDraw(context);
		}
	 
		private function doMagic():void
		{
			var x:Number = _intensity * Math.cos(_angle);
			var y:Number = _intensity * Math.sin(_angle);
	 
				_constants[0] = x;
				_constants[1] = y;
				_constants[2] = -x;
				_constants[3] = -y;
		}
	 
		public function get intensity():Number { return _intensity * 1000; }
	 
		public function set intensity(value:Number):void
		{
			_intensity = value / 1000;
			doMagic();
		}
	 
		public function get angle():Number { return _angle; }
	 
		public function set angle(value:Number):void
		{
			_angle = value;
			doMagic();
		}
	 
	}

}
