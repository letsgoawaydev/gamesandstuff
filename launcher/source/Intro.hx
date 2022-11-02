package;

import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.system.FlxSound;
import flixel.util.FlxColor;
import openfl.display.Sprite;

class Intro extends FlxState
{
	var sprite = new FlxSprite();
	var htmlclick = new FlxSprite();
	var alpha:Float = 0;
	var startintro:Bool = false;
	var introstarted:Bool = false;
	var introended:Bool = false;
	var maxAlpha:Bool = false;
	var intro = FlxG.sound;
	var timer:Float = 0;

	override public function create()
	{
		#if !mobile
		FlxG.mouse.visible = false;
		#end
		FlxG.autoPause = false;
		bgColor = 0;
		super.create();
		sprite.alpha = 0;
		sprite.loadGraphic('assets/images/text.png');
		sprite.scale.set(1, 1);
		sprite.screenCenter();
		add(sprite);
		#if html5
		htmlclick.loadGraphic("assets/images/htmlclick.png");
		htmlclick.scale.set(0.5, 0.5);
		htmlclick.screenCenter();
		add(htmlclick);
		#end
	}

	function sound(i)
	{
		#if html5
		intro.play(i + ".mp3");
		#else
		intro.play(i + ".ogg");
		#end
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		#if html5
		if (FlxG.mouse.pressed)
		{
			startintro = true;
			htmlclick.alpha = 0;
		}
		#else
		startintro = true;
		#end
		if (startintro)
		{
			if (!introstarted)
			{
				super.update(elapsed);
				if (!introended)
				{
					introstarted = true;
					sound("assets/sounds/intro");
				}
			}
		}
		if (startintro)
		{
			if (FlxG.keys.justReleased.ENTER || FlxG.keys.justReleased.ESCAPE || FlxG.keys.justReleased.SPACE)
			{
				if (!introended)
				{
					introended = true;
					intro.pause();
					FlxG.switchState(new Menu());
				}
			}
			timer += 1;
			if (!maxAlpha)
			{
				if (!(sprite.alpha == 1))
				{
					alpha += 0.05;
				}
				else
				{
					maxAlpha = true;
				}
			}
			else
			{
				if (timer > 220)
				{
					alpha = alpha - 0.05;
					if (sprite.alpha == 0)
					{
						if (!introended)
						{
							introended = true;
							FlxG.switchState(new Menu());
						}
					}
				}
			}
			sprite.alpha = alpha;
		}
	}
}
