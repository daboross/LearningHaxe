package net.daboross.hex;

import createjs.easeljs.Stage;
import createjs.easeljs.Ticker;
import createjs.easeljs.SpriteSheet;
import createjs.easeljs.Sprite;
import createjs.easeljs.Container;
import createjs.easeljs.Event;
import js.html.KeyboardEvent;

import net.daboross.hex.Character;

class SpaceHandler {

    public var stage:Stage = new Stage("hex-canvas");
    public var stageCenterX:Int;
    public var stageCenterY:Int;
    private var character:Character;
    private var spaceContainer:Container;

    public function new() {
        this.stageCenterX = cast(stage.canvas.width / 2, Int);
        this.stageCenterY = cast(stage.canvas.height / 2, Int);

        this.spaceContainer = new Container();
        stage.addChild(spaceContainer);

        var characterSprite:Sprite = new Sprite(createSheet("Green.png", 64, 64), 0);
        spaceContainer.addChild(characterSprite);

        this.character = new Character(this, characterSprite);
    }

    public function start() {
        Ticker.setFPS(60);
        Ticker.addEventListener("tick", tick);
        Ticker.addEventListener("keydown", character.handleKeyPress);
        js.Browser.document.onkeydown = fireKeyDown;
    }

    public function tick(event:Event) {
        character.tick();
        spaceContainer.x = stageCenterX - character.spaceX;
        spaceContainer.y = stageCenterY - character.spaceY;

        stage.update();
    }

    public function fireKeyDown(e:KeyboardEvent) {
        Ticker.dispatchEvent(e);
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
