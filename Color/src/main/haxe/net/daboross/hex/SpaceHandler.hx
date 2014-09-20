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
import net.daboross.hex.EnemyHandler;

class SpaceHandler {

    public var stage:Stage = new Stage("hex-canvas");
    public var spaceContainer:Container = new Container();
    public var stageCenterX:Int;
    public var stageCenterY:Int;
    public var keyboard:Keyboard = new Keyboard();
    public var character:Character;
    public var populator:EnemyHandler;

    public function new() {
        onResize(null);

        stage.addChild(spaceContainer);

        this.character = new Character(this, keyboard, createSheet("Green.png", 64, 64), 0);
        character.x = stageCenterX;
        character.y = stageCenterY;
        stage.addChildAt(character, 0);
        stage.addChildAt(character.statusText, 0);

        this.populator = new EnemyHandler(this, createSheet("enemies.png", 64, 64));
    }

    public function onResize(e:Dynamic) {
        var width:Int = js.Browser.window.innerWidth;
        var height:Int = js.Browser.window.innerHeight;
        stage.canvas.width = width;
        stage.canvas.height = height;
        stageCenterX = Std.int(width / 2);
        stageCenterY = Std.int(height / 2);
        if (character != null) {
            character.x = stageCenterX;
            character.y = stageCenterY;
        }
    }

    public function start() {
        Ticker.setFPS(60);
        Ticker.addEventListener("tick", tick);
        js.Browser.window.onresize = onResize;
        js.Browser.window.onfocus = onFocus;
        js.Browser.window.onblur = onBlur;
        keyboard.register();
    }

    public function tick(event:Event) {
        if (Ticker.getPaused()) {
            return; // Don't animate when paused
        }
        character.tick();
        spaceContainer.x = stageCenterX - character.spaceX;
        spaceContainer.y = stageCenterY - character.spaceY;
        populator.tick();
        stage.update();
    }

    public function onFocus(e:Dynamic) {
        onResize(e);
        Ticker.setPaused(false);
    }

    public function onBlur(e:Dynamic) {
        Ticker.setPaused(true);
        keyboard.onBlur(e);
    }

    private function createSheet(file:String, width:Int, height:Int) : SpriteSheet {
        return new SpriteSheet({
            "images": [file],
            "frames": {
                "width": width,
                "height": height,
                "regX": Std.int(width / 2),
                "regY": Std.int(height / 2)
            }
        });
    }
}
