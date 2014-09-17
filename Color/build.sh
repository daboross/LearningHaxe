#!/bin/bash
rm -r target/
mkdir target/
haxe build.hxml
cp -a src/main/resources/* target/
