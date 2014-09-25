package net.daboross.hex;

import js.html.Image;

import createjs.easeljs.Container;
import createjs.easeljs.SpriteSheet;
import createjs.easeljs.Bitmap;
import createjs.easeljs.Sprite;

class ScrollingBackground {

    public var container:Container;
    private var image:Image;
    private var scale:Float;
    private var imageHeight:Float;
    private var imageWidth:Float;
    private var width:Int;
    private var height:Int;
    private var sprites:Array<Array<Bitmap>> = new Array();

    public function new(image:Image, scale:Float) {
        this.image = image;
        this.scale = scale;
        this.imageHeight = image.height * scale;
        this.imageWidth = image.width * scale;
        container = new Container();
    }

    public function updateStageSize(width:Int, height:Int) {
        this.width = width;
        this.height = height;
        var numX:Int = Math.ceil(width / imageWidth) + 1;
        var numY:Int = Math.ceil(height / imageHeight) + 1;
        if (numX == sprites.length) {
            if (numY == sprites[0].length) {
                return; // We're all good
            }
        }
        container.removeAllChildren();
        sprites = new Array();
        for (x in 0...numX) {
            var listY:Array<Bitmap> = new Array();
            for (y in 0...numY) {
                var sprite:Bitmap = new Bitmap(image);
                sprite.scaleX = scale;
                sprite.scaleY = scale;
                container.addChild(sprite);
                listY.push(sprite);
            }
            sprites.push(listY);
        }
    }

    public function update(scrollX:Float, scrollY:Float) {
        scrollX = scrollX % imageWidth;
        scrollY = scrollY % imageHeight;
        if (scrollX > 0) {
            scrollX -= imageWidth;
        }
        if (scrollY > 0) {
            scrollY -= imageHeight;
        }
        for (x in 0...sprites.length) {
            var listY = sprites[x];
            for (y in 0...listY.length) {
                var sprite:Bitmap = listY[y];
                sprite.x = x * imageWidth + scrollX;
                sprite.y = y * imageHeight + scrollY;
            }
        }
    }
}
