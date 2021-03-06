import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.display.StageQuality;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.geom.ColorTransform;
import flash.geom.Point;
import flash.Lib;
import flash.text.TextField;
import flash.text.TextFormat;
import haxe.ds.Vector;
import motion.Actuate;
import motion.easing.Expo;


class ActuateBench extends Sprite {
    static inline var LENGTH     = 250000;
    static inline var WIDTH      = 465;
    static inline var HEIGHT     = 465;
    static inline var COLOR      = 0xFFFFFFFF;
    static inline var TIME_LIMIT = 30000;
    static var colorTransform     = new ColorTransform(0.9, 0.7, 0.8);

    public static function main() {
        Lib.current.stage.addChild(new ActuateBench());
    }

    var seconds:Float = 0;
    var count:Int = -3;
    var oldTime:Float = 0;
    var fpsField:TextField;
    var points:Vector<Point>;
    var bitmapData:BitmapData;
    var startTime:Float = 0;
    var result:Null<Float> = null;

    public function new() {
        super();
        Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
        Lib.current.stage.quality = StageQuality.LOW;

        points = new Vector<Point>(LENGTH);
        for(i in 0...LENGTH){
            var p = points[i] = new Point(i % WIDTH, HEIGHT);

            var t = Actuate.tween(p, 0.2 + 10 * Math.random(),{"y":0})
                .ease(Expo.easeIn)
                .repeat(-1);

        }

        addChild(new Bitmap(bitmapData = new BitmapData(WIDTH, HEIGHT, false, 0)));
        addChild(fpsField = new TextField());
        fpsField.defaultTextFormat = new TextFormat("_sans", 15, 0xFFFFFF);
        fpsField.text = "fps:--";
        fpsField.width = WIDTH;

        addEventListener(Event.EXIT_FRAME, onFrame);
        startTime = Date.now().getTime();
    }

    public function onFrame(e) {
        var b = bitmapData;
        b.lock();
        b.colorTransform(b.rect, colorTransform);
        for (i in 0...LENGTH) {
            var p = points[i];
            b.setPixel(Std.int(p.x), Std.int(p.y), COLOR);
        }
        b.unlock();

        var time = Date.now().getTime();
        if (count++ > 0) {
            seconds *= (count - 1) / count;
            seconds += (time - oldTime) / count;
            fpsField.text = untyped "Actuate fps:" + (1000 / seconds).toFixed(2);
            if (time - startTime >= TIME_LIMIT) {
                if (result == null) result = (1000 / seconds);
                fpsField.text += untyped " result:" + result.toFixed(2);
            }
        }
        oldTime = time;
    }
}
