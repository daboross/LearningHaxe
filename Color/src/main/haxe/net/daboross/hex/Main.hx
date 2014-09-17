package net.daboross.hex;

import createjs.easeljs.SpriteSheet;
import createjs.easeljs.Shape;
import createjs.easeljs.Stage;
import createjs.easeljs.Sprite;
import createjs.easeljs.Ticker;
import net.daboross.hex.SpaceHandler;

class Main {

    private var space:SpaceHandler = new SpaceHandler();

    public function new() {
    }

    public static function main() {
        new Main().run();
    }

    public function run() {
        space.start();
    }
}
