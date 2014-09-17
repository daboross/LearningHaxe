package net.daboross.hex;

import createjs.easeljs.Sprite;
import js.html.KeyboardEvent;

import net.daboross.hex.SpaceHandler;
import net.daboross.hex.util.KeyCodes;

class Character {

    public var space:SpaceHandler;
    public var sprite:Sprite;
    public var spaceX:Float;
    public var spaceY:Float;
    public var rotation:Float;

    public function new(space:SpaceHandler, sprite:Sprite) {
        this.space = space;
        this.sprite = sprite;
        this.spaceX = 0;
        this.spaceY = 0;
        this.rotation = 0;
    }


    public function handleKeyPress(e:KeyboardEvent) {
        if (e.ctrlKey) {
            return;
        }
        // Ensure that e.preventDefault isn't ever called when e.ctrlKey, so that things like page reloading work.
        // We still want to call it for other keys though, so up/down arrows don't make the page scroll.
           e.preventDefault();

           switch e.keyCode {
            case KeyCodes.UP:
                spaceY -= 1;
            case KeyCodes.DOWN:
                spaceY += 1;
            case KeyCodes.LEFT:
                rotation -= 1;
            case KeyCodes.RIGHT:
                rotation += 1;
           }
        js.Browser.window.console.log(e.keyCode + " - "+ rotation);
    }

    public function tick() {
        sprite.x = spaceX;
        sprite.y = spaceY;
        sprite.rotation = rotation;
    }
}
