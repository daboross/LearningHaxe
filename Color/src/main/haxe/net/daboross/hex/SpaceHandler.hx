package net.daboross.hex;

import js.html.Image;

import createjs.easeljs.Stage;
import createjs.easeljs.Ticker;
import createjs.easeljs.SpriteSheet;
import createjs.easeljs.Sprite;
import createjs.easeljs.Container;
import createjs.easeljs.Event;
import createjs.preloadjs.LoadQueue;

import net.daboross.hex.util.Keyboard;
import net.daboross.hex.Character;
import net.daboross.hex.EnemyHandler;
import net.daboross.hex.ProjectileHandler;
import net.daboross.hex.ScrollingBackground;

class SpaceHandler {

    public var stage:Stage = new Stage("hex-canvas");
    public var spaceContainer:Container = new Container();
    public var background:ScrollingBackground;
    public var stageCenterX:Int;
    public var stageCenterY:Int;
    public var keyboard:Keyboard = new Keyboard();
    public var character:Character;
    public var enemies:EnemyHandler;
    public var projectileHandler:ProjectileHandler;
    public var loadQueue:LoadQueue;

    public function new() {
        loadQueue = new LoadQueue(false, "");
        loadQueue.addEventListener("complete", addBackground);
        loadQueue.loadManifest([{src: "background.png", id: "background-image"}]);

        // Initial stage setup
        onResize();

        stage.addChildAt(spaceContainer, 0);

        // Character setup
        this.character = new Character(this, keyboard, createSheet("Green.png", 64, 64), 0);
        character.x = stageCenterX;
        character.y = stageCenterY;
        stage.addChildAt(character, 0);
        stage.addChildAt(character.statusText, 0);

        this.enemies = new EnemyHandler(this, createSheet("enemies.png", 64, 64));
        this.projectileHandler = new ProjectileHandler(this, createSheet("projectiles.png", 16, 16));
    }

    public function addBackground() {
        var backgroundImage:Image = loadQueue.getResult("background-image");
        background = new ScrollingBackground(backgroundImage, 5);
        onResize();
        stage.addChildAt(background.container, 0);
    }

    public function onResize(?e:Dynamic) {
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
        if (background != null) {
            background.updateStageSize(width, height);
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
        if (background != null) {
            background.update(spaceContainer.x, spaceContainer.y);
        }
        enemies.tick();
        projectileHandler.tick();
        stage.update();
    }

    public function onFocus(e:Dynamic) {
        onResize();
        Ticker.setPaused(false);
    }

    public function onBlur(e:Dynamic) {
        keyboard.onBlur(e);
        Ticker.setPaused(true);
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
