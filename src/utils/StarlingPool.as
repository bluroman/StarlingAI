/**
 * Created by bluroman on 2015-02-11.
 */
package utils {
import starling.display.DisplayObject;

public class StarlingPool
{
    public var pool:Array;
    private var counter:int;
    private var classRef:Class;

    // public get to know what's left in the pool
    public function get availableObjects():int
    {
        return counter;
    }

    public function StarlingPool(type:Class, len:int)
    {
        classRef = type;
        pool = [];
        counter = len;

        var i:int = len;
        while (--i > -1)
            pool[i] = new classRef();
    }

    public function getSprite():DisplayObject
    {
        if (counter > 0)
            return pool[--counter];
        else
        {
            increasePool(5);
            return pool[--counter];
        }
            //throw new Error("PoolExhausted");
    }

    public function returnSprite(s:DisplayObject):void
    {
        pool[counter++] = s;
    }

    public function increasePool(amount:int):void
    {
        counter += amount;

        while (--amount > -1)
            pool.push(new classRef());
    }

    public function decreasePool(amount:int):void
    {
        if (counter >= amount)
        {
            counter -= amount;
            pool.splice(counter - amount,amount);
        }
        else
        {
            throw new Error("PoolDecreaseFail");
        }
    }
    public function destroy():void
    {
        pool = null;
    }
}
}
