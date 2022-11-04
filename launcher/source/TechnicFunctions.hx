package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxExtendedSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.system.FlxSound;
import flixel.system.frontEnds.SoundFrontEnd;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import haxe.Log;
import lime.net.HTTPRequest;
import lime.ui.Window;
import lime.ui.WindowAttributes;
import openfl.Lib;
import openfl.display.BitmapData;
import openfl.system.Capabilities;
#if html5 import js.Browser; #end

var gamepad:FlxGamepad;
var sfx:SoundFrontEnd = FlxG.sound;
var musicAudio:SoundFrontEnd = FlxG.sound;
var inputType:String = "Keyboard";
var music:FlxSound;
var t:Int;
var quote = "";

/**
 * sfx shorthand
 */
// function sound(s):Void
// {
// #if html5
// sfx.play(s + ".mp3");
// #else
// sfx.play(s + ".ogg");
// #end
// }

/**
 * Play a song ONLY IF THERE IS NONE CURRENTLY PLAYING.
 */
function loopedMusic(m:String):Void
{
	musicAudio = FlxG.sound;
	if (FlxG.sound.music == null) // don't restart the music if it's already playing
	{
		#if html5
		musicAudio.playMusic(m + '.mp3', 1, true);
		#else
		musicAudio.playMusic(m + '.wav', 1, true);
		#end
	}
}

/**
 * Switch to a different song ONLY IF THERE IS ONE CURRENTLY PLAYING.
 */
function loopedMusicSwitchTo(musicLocation:String, ?fadeAmount:Float):Void
{
	FlxG.sound.music.persist = false;
	FlxG.sound.music.destroy();
	FlxG.sound.music = null;
	TechnicFunctions.loopedMusic(musicLocation);
	if (!(fadeAmount == null))
	{
		FlxG.sound.music.fadeIn(fadeAmount);
	}
}

/**
 * Spritesheet stuff, as long as an image has a xml to go with it this will work
 * `sprite` - Sprite to Apply image data and animations data to.
 * `img` - The image and xml to apply to `sprite`.
 */
function spritesheet(sprite:FlxSprite, img:String)
{
	sprite.frames = FlxAtlasFrames.fromSparrow(img + ".png", img + ".xml");
}

/**
 * Returns the FlxColor rgb 0, 0, 22
 */
function spaceColor():FlxColor
{
	return FlxColor.fromRGB(0, 0, 22);
}

/**
 * idfk its broken rn
 */
function updateInput(gamepad:FlxGamepad):Void
{
	if (FlxG.keys.justPressed.ANY)
	{
		inputType = "Keyboard";
	}
	if (inputType == "Keyboard")
	{
		if (FlxG.keys.justReleased.R)
		{
			FlxG.switchState(new Menu());
		}
	}
}

/**
 * Desktop Only: Checks if F11 is Currently pressed and if so toggles fullscreen
 */
function checkForFullScreenToggle():Void
{
	#if !html5
	if (FlxG.keys.justPressed.F11)
	{
		toggleFullscreen();
	}
	#end
}

/**
 * If in fullscreen, exits and centers screen
 */
function toggleFullscreen():Void
{
	#if desktop
	FlxG.resizeWindow(1280, 720);
	// (screen.width - window.width) / 2
	Lib.application.window.x = Math.round((Capabilities.screenResolutionX - 1280) / 2);
	Lib.application.window.y = Math.round((Capabilities.screenResolutionY - 720) / 2);
	FlxG.fullscreen = !FlxG.fullscreen;
	#end
}

function spriteFadeIn(sprite:FlxExtendedSprite, duration:Float):Void
{
	if (sprite.alpha != 1)
	{
		FlxTween.tween(sprite, {
			alpha: 1
		}, duration, {
			type: FlxTweenType.ONESHOT
		});
	}
}

function valToString(val:Any):String
{
	return val + "";
}

/**
 * Loads an image from a url and loads it to sprite.
 */
function loadImageFromUrltoSprite(sprite:FlxSprite, imgUrl:String):Void
{
	sprite.alpha = 0;
	var req = new HTTPRequest<BitmapData>();
	req.load(imgUrl).onComplete(function(image)
	{
		sprite.loadGraphic(image);
		sprite.alpha = 1;
	});
}

function staticSpritesheetAnimAdd(sprite:FlxSprite, name:String, animName:String):Void
{
	sprite.animation.addByPrefix(animName, name + " " + animName, 60, false);
}

function spriteFadeOut(sprite:FlxExtendedSprite, duration:Float):Void
{
	if (sprite.alpha != 0)
	{
		FlxTween.tween(sprite, {
			alpha: 0
		}, duration, {
			type: FlxTweenType.ONESHOT
		});
	}
}

function alert(message:Null<String>, ?title:Null<String>):Void
{
	if (title == null)
	{
		title = "";
	}
	#if !html5
	Lib.application.window.alert(message, title);
	#else
	if (!(title == ""))
	{
		Browser.alert(title + "\n-------------\n" + message);
	}
	else
	{
		Browser.alert(message);
	}
	#end
}

function winAlert(message:Null<String>, ?title:Null<String>, ?type:Null<String>)
{
	#if windows
	if (type == null)
	{
		t = 64;
	}
	if (title == null)
	{
		title = "";
	}
	else
	{
		type = type.toLowerCase();
		if (type == "error")
		{
			t = 16;
		}
		else if (type == "question")
		{
			t = 32;
		}
		else if (type == "warning")
		{
			t = 48;
		}
		else if (type == "info")
		{
			t = 64;
		}
	}
	var array:Array<String> = [
		"vbscript:msgbox(" + quote + message + quote + "," + t + "," + quote + title + quote + ")\\close()"
	];
	Sys.command("mshta", array);
	#end
}
