package net.daboross.hex;

import createjs.easeljs.Stage;
import createjs.easeljs.Ticker;
import createjs.easeljs.SpriteSheet;
import createjs.easeljs.Sprite;
import createjs.easeljs.Event;

class SpaceHandler {

    public var stage:Stage = new Stage("hex-canvas");

	public function new() {
	}

	public function start() {
        var sprite = new Sprite(createSheet("Green.png", 64, 64), 0);
        sprite.x = 100;
        sprite.y = 100;
        stage.addChild(sprite);
        Ticker.setFPS(60);
        Ticker.addEventListener("tick", tick);
	}

	public function tick(event:Event) {
		stage.update();
	}

    private function createSheet(file:String, width:Int, height:Int) {
        var sheet:SpriteSheet = new SpriteSheet({
            "images": [file],
            "frames": {
                "width": width,
                "height": height,
                "regX": cast((width / 2), Int),
                "regY": cast((height / 2), Int)
            }
        });
        return sheet;
    }
}
