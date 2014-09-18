package net.daboross.hex.util;

import createjs.easeljs.Ticker;
import js.html.KeyboardEvent;
import js.Browser;

class Keyboard {

    private var keys:Map<Int, Bool> = new Map<Int, Bool>();

    public function new() {
    }

    public function register() {
        Browser.document.onkeydown = onKeyDown;
        Browser.document.onkeyup = onKeyUp;
    }

    public function onKeyDown(e:KeyboardEvent) {
        if (e.ctrlKey) {
            return;
        }
        // Ensure that e.preventDefault isn't ever called when e.ctrlKey, so that things like page reloading work.
        // We still want to call it for other keys though, so up/down arrows don't make the page scroll.
        e.preventDefault();

        keys[e.keyCode] = true;
    }

    public function onKeyUp(e:KeyboardEvent) {
        if (e.ctrlKey) {
            return;
        }
        // Ensure that e.preventDefault isn't ever called when e.ctrlKey, so that things like page reloading work.
        // We still want to call it for other keys though, so up/down arrows don't make the page scroll.
        e.preventDefault();

        keys[e.keyCode] = false;
    }

    public function isPressed(key:Int) {
        return keys[key];
    }
}