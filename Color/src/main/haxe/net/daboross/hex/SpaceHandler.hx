package net.daboross.hex;

import createjs.easeljs.Stage;
import createjs.easeljs.Ticker;
import createjs.easeljs.SpriteSheet;
import createjs.easeljs.Sprite;
import createjs.easeljs.Container;
import createjs.easeljs.Event;
import js.html.KeyboardEvent;

import net.daboross.hex.util.Keyboard;
import net.daboross.hex.Character;
import net.daboross.hex.Populator;

class SpaceHandler {

    public var stage:Stage = new Stage("hex-canvas");
    public var spaceContainer:Container = new Container();
    public var stageCenterX:Int;
    public var stageCenterY:Int;
    public var keyboard:Keyboard = new Keyboard();
    public var character:Character;
    public var populator:Populator;

    public function new() {
        stageCenterX = cast(stage.canvas.width / 2, Int);
        stageCenterY = cast(stage.canvas.height / 2, Int);

        stage.addChild(spaceContainer);

        this.character = new Character(this, keyboard, createSheet("Green.png", 64, 64), 0);
        character.x = stageCenterX;
        character.y = stageCenterY;
        stage.addChildAt(character, 0);
        stage.addChildAt(character.statusText, 0);

        this.populator = new Populator(this, createSheet("Blue.png", 64, 64));
    }

    public function start() {
        Ticker.setFPS(60);
        Ticker.addEventListener("tick", tick);
        keyboard.register();
    }

    public function tick(event:Event) {
        character.tick();
        spaceContainer.x = stageCenterX - character.spaceX;
        spaceContainer.y = stageCenterY - character.spaceY;
        populator.tick();
        stage.update();
    }

    private function createSheet(file:String, width:Int, height:Int) : SpriteSheet {
        return new SpriteSheet({
            "images": [file],
            "frames": {
                "width": width,
                "height": height,
                "regX": cast((width / 2), Int),
                "regY": cast((height / 2), Int)
            }
        });
    }
}
