/**
 * Created by bluroman on 2017-07-15.
 */
package extensions
{
import starling.filters.FragmentFilter;
import starling.rendering.FilterEffect;


public class ShineFilter extends FragmentFilter
{
    public function ShineFilter() { }

    override protected function createEffect():FilterEffect
    {
        return new ShineFilterEffect();
    }

    public function set position(value:Number):void
    {
        (effect as ShineFilterEffect).vOffset[1] = value;
        setRequiresRedraw();
    }


    public function get position():Number
    {
        return (effect as ShineFilterEffect).vOffset[1];
    }


    public function get intensity():Number
    {
        return (effect as ShineFilterEffect).vOffset[0];
    }

    public function set intensity(value:Number):void
    {
        (effect as ShineFilterEffect).vOffset[0] = value;
        setRequiresRedraw();
    }


    public function set rgbTint(rgbVals:Vector.<Number>):void
    {
        (effect as ShineFilterEffect).vColor[0] = rgbVals[0];
        (effect as ShineFilterEffect).vColor[1] = rgbVals[1];
        (effect as ShineFilterEffect).vColor[2] = rgbVals[2];

        setRequiresRedraw();
    }


    public function get rgbTint():Vector.<Number>
    {
        return (effect as ShineFilterEffect).vColor.slice(0,3);
    }
}

}
import flash.display3D.Context3D;
import flash.display3D.Context3DProgramType;
import starling.rendering.FilterEffect;
import starling.rendering.Program;


class ShineFilterEffect extends FilterEffect
{
    private var _vOffset:Vector.<Number> = new <Number>[1, 0, -.005, 0];
    private var _vColor:Vector.<Number>  = new <Number>[1, 1, 1, 0];

    public function ShineFilterEffect():void { }

    override protected function createProgram():Program
    {
        var vertexShader:String = FilterEffect.STD_VERTEX_SHADER;

        var fragmentShader:String = [
            "tex ft0, v0, fs0 <2d, clamp, linear, mipnone>",
            "add ft1.x, v0.x, v0.y",
            "add ft1.x, ft1.x, fc0.y",
            "mul ft1.x, ft1.x, ft1.x",
            "div ft1.x, ft1.x, fc0.z",
            "exp ft1.x, ft1.x",
            "mul ft1.x, ft1.x, fc0.x",
            "mul ft2.xyz, ft1.xxx, ft0.xyz",
            "mul ft2.xyz, ft2.xyz, fc1.xyz",
            "add ft0.xyz, ft0.xyz, ft2.xyz",
            "mul ft0.xyz, ft0.xyz, ft0.www",
            "mov oc, ft0"
        ].join("\n");

        return Program.fromSource(vertexShader, fragmentShader);
    }

    override protected function beforeDraw(context:Context3D):void
    {
        super.beforeDraw(context);

        context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, _vOffset, 1);
        context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, _vColor, 1);
    }


    public function get vOffset():Vector.<Number> { return _vOffset; }
    public function set vOffset(value:Vector.<Number>):void { _vOffset = value; }

    public function get vColor():Vector.<Number> { return _vColor; }
    public function set vColor(value:Vector.<Number>):void { _vColor = value; }


}

