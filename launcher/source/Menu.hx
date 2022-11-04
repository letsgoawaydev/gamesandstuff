import Paths;
import TechnicFunctions;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxExtendedSprite;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.system.FlxSound;
import flixel.system.frontEnds.SoundFrontEnd;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxSave;
import lime.net.HTTPRequest;
import openfl.display.BitmapData;
import openfl.ui.Mouse;
#if html5 import js.Browser; #end

// Hello fellow developer! Thanks for stopping by.
// You can do what ever you want with this code. A credit is encouraged but optional.
class Menu extends FlxState
{
	/* GAME DATA */
	/* CHANGE THESE VALUES */
	var gameStringID:Array<String> = [
		'sm64pcport',
		'superhot',
		'subwaySurfers',
		'doomjscompressed',
		'doomjscompressed',
		'half-life',
		'mcEagler',
		'mari0'
	];
	var gameSupportsPlatforms:Array<Array<Bool>> = [
		// PC  Mobile Gamepad
		[true, false, true],
		[true, false, false],
		[true, true, false],
		[true, true, false],
		[true, true, false],
		[true, false, false],
		[true, false, false],
		[true, false, false]
	];
	var gameLinkEndTags:Array<String> = [
		'/',
		'/',
		'/',
		'/?bundleUrl=/d?anonymous=1',
		'/?bundleUrl=/d2?anonymous=1',
		'/',
		'/',
		'/'
	];
	/* */
	var gameDevImagePaths:Array<String> = [""];
	var gameID:Int = 0;
	var _save:FlxSave = new FlxSave();
	// UI
	var title:FlxSprite = new FlxSprite();
	var clicktostart:FlxSprite = new FlxSprite();
	var bg:FlxSprite = new FlxSprite();
	var gameCover:FlxSprite = new FlxSprite();
	var gameChar:FlxSprite = new FlxSprite();
	var leftArrow:FlxExtendedSprite = new FlxExtendedSprite();
	var rightArrow:FlxExtendedSprite = new FlxExtendedSprite();
	var playButton:FlxExtendedSprite = new FlxExtendedSprite();
	var platPC:FlxExtendedSprite = new FlxExtendedSprite();
	var platMobile:FlxExtendedSprite = new FlxExtendedSprite();
	var platGamepad:FlxExtendedSprite = new FlxExtendedSprite();
	var coverFadeIn:FlxTween;
	var charFadeIn:FlxTween;
	var pcIn:FlxTween;
	var mobileIn:FlxTween;
	var gamepadIn:FlxTween;
	var fader:FlxExtendedSprite = new FlxExtendedSprite();
	var faderIn:FlxTween;
	var faderOut:FlxTween;
	var text:FlxText = new FlxText();
	// Flixel
	var gamepad:FlxGamepad;
	// Booleans
	var started:Bool = false;
	var menuLoaded:Bool = false;
	var maxClickAlpha:Bool = false;
	var clicksoundstarted:Bool = false;
	var mouseDown:Bool;
	var touchingui:Bool = false;
	var gamepad_left:Bool = false;
	var gamepad_right:Bool = false;
	var startButtonFix:Bool = false;
	var inSecondaryMenu:Bool = false;
	// Float
	var titlesize:Float = 0.5;
	// Ints
	var downloadTimesClicked:Int = 0;
	// Strings
	var currentGame:String = "";
	var fontFix:String = "";
	#if html5
	var website:String = Browser.window.location.href;
	var browserwindow = Browser.window;
	#end
	// Other
	var s:FlxSound;
	var download:FlxExtendedSprite = new FlxExtendedSprite();

	override public function create()
	{
		Mouse.cursor = "arrow";
		_save.bind("SaveData");
		if (!(_save.data.lastgameid == null))
		{
			gameID = _save.data.lastgameid;
		}
		else
		{
			gameID = 0;
		}
		_save.data.lastgameid = gameID;
		#if !mobile
		FlxG.mouse.useSystemCursor = true;
		FlxG.mouse.visible = true;
		#end
		FlxG.autoPause = false;
		bgColor = 0;
		FlxMouseEventManager.add(bg);
		super.create();
		title.alpha = 1;
		title.loadGraphic('assets/images/gamesandstuff.png');
		title.scale.set(0.5, 0.5);
		title.screenCenter();
		title.antialiasing = true;
		add(title);
		clicktostart.alpha = 1;
		clicktostart.loadGraphic('assets/images/clicktostart.png');
		clicktostart.scale.set(0.25, 0.25);
		clicktostart.screenCenter();
		clicktostart.y += 85;
		add(clicktostart);
		TechnicFunctions.spritesheet(gameCover, Paths.Images('gameCovers'));
		var i:Int = 0;
		for (gameName in gameStringID)
		{
			TechnicFunctions.staticSpritesheetAnimAdd(gameCover, "gameCovers", i + "game");
			i++;
		}
		gameCover.x = -283;
		gameCover.y = -146;
		gameCover.scale.set(0.25, 0.25);
		TechnicFunctions.spritesheet(gameChar, Paths.Images('characters'));
		var i:Int = 0;
		for (gameName in gameStringID)
		{
			TechnicFunctions.staticSpritesheetAnimAdd(gameChar, "characters", i + "game");
			i++;
		}
		gameChar.x = 57;
		gameChar.y = -100;
		gameChar.scale.set(0.4, 0.4);
		leftArrow.loadGraphic('assets/images/triangle.png'); // sprite image
		leftArrow.alpha = 1; // opacity
		leftArrow.angle = -135; // rotation of sprite
		leftArrow.screenCenter(Y); // center on the Y axis
		leftArrow.x = 75;
		leftArrow.height += 55;
		leftArrow.centerOffsets(true);
		leftArrow.offset.x -= 35;
		leftArrow.antialiasing = true;
		FlxMouseEventManager.add(leftArrow);
		FlxMouseEventManager.setMouseClickCallback(leftArrow, leftArrowClick);
		rightArrow.loadGraphic('assets/images/triangle.png');
		rightArrow.alpha = 1;
		rightArrow.angle = 45;
		rightArrow.screenCenter(Y);
		rightArrow.x = 1110;
		rightArrow.height += 55;
		rightArrow.centerOffsets(true);
		rightArrow.offset.x -= -45;
		rightArrow.antialiasing = true;
		FlxMouseEventManager.add(rightArrow);
		FlxMouseEventManager.setMouseClickCallback(rightArrow, rightArrowClick);
		playButton.alpha = 1;
		playButton.loadGraphic('assets/images/play.png');
		playButton.scale.set(0.5069420, 0.5069420); // funni moment AMO-*vine boom* x1 x2 x1000000
		playButton.updateHitbox();
		playButton.screenCenter(X);
		playButton.y = 522.292;
		FlxMouseEventManager.add(playButton);
		FlxMouseEventManager.setMouseClickCallback(playButton, playButtonClick); // basically "when playButton clicked -> run playButtonClick function"
		#if html5
		fontFix = "assets/fonts/FuturaWeb.woff";
		#else
		fontFix = "assets/fonts/Futura.ttf";
		#end
		TechnicFunctions.spritesheet(platPC, Paths.Images('platforms'));
		TechnicFunctions.staticSpritesheetAnimAdd(platPC, "platforms", "pc");
		platPC.x = 207;
		platPC.y = 407;
		FlxG.watch.add(this.platPC, "x", "platPC.x");
		FlxG.watch.add(this.platPC, "y", "platPC.y");
		TechnicFunctions.spritesheet(platMobile, Paths.Images('platforms'));
		TechnicFunctions.staticSpritesheetAnimAdd(platMobile, "platforms", "mobile");
		platMobile.x = 307;
		platMobile.y = 407;
		platMobile.scale.set(0.83, 0.83);
		FlxG.watch.add(this.platMobile, "x", "platMobile.x");
		FlxG.watch.add(this.platMobile, "y", "platMobile.y");
		TechnicFunctions.spritesheet(platGamepad, Paths.Images('platforms'));
		TechnicFunctions.staticSpritesheetAnimAdd(platGamepad, "platforms", "gamepad");
		platGamepad.x = 407;
		platGamepad.y = 398;
		FlxG.watch.add(this.platGamepad, "x", "platGamepad.x");
		FlxG.watch.add(this.platGamepad, "y", "platGamepad.y");
		FlxG.watch.add(this.playButton, "x");
		FlxG.watch.add(this.playButton, "y");
		FlxG.watch.add(this.gameCover, "x", "gameCover.x");
		FlxG.watch.add(this.gameCover, "y", "gameCover.y");
		FlxG.watch.add(this.gameChar, "x", "gameChar.x");
		FlxG.watch.add(this.gameChar, "y", "gameChar.y");
		FlxG.watch.add(this, "gameID", "gameID");
		FlxG.watch.add(this, "currentGame");
		FlxG.watch.add(this.title, "x", "title.x");
		FlxG.watch.add(this.title, "y", "title.y");
		FlxG.watch.add(this.gameStringID, "length", "amount of games");
		FlxG.watch.add(this.download, "x", "download.x");
		FlxG.watch.add(this.download, "y", "download.y");
		download.loadGraphic(Paths.Images('download.png'));
		download.screenCenter();
		download.x = 1124;
		download.y = 557;
		download.alpha = 0;
		add(download);
		FlxMouseEventManager.add(download);
		FlxMouseEventManager.setMouseClickCallback(download, downloadClicked); // basically "when playButton clicked -> run playButtonClick function"
		add(gameCover);
		gameCover.alpha = 0;
		add(gameChar);
		gameChar.alpha = 0;
		add(leftArrow);
		leftArrow.alpha = 0;
		add(rightArrow);
		rightArrow.alpha = 0;
		add(playButton);
		playButton.alpha = 0;
		add(platPC);
		platPC.animation.play("pc");
		add(platMobile);
		platMobile.animation.play("mobile");
		add(platGamepad);
		platGamepad.animation.play("gamepad");
		// text.text = "Hello, World!";
		// text.font = "Monsterrat";
		// text.color = FlxColor.WHITE;
		// text.size = 32;
		// text.screenCenter();
		// add(text);
		fader.makeGraphic(1280, 720, FlxColor.BLACK);
		fader.screenCenter();
		fader.alpha = 0;
		add(fader);
	}

	function uiFaderIn(alphaVal:Float):Void
	{
		faderIn = FlxTween.tween(fader, {
			alpha: alphaVal
		}, 0.15, {
			type: FlxTweenType.ONESHOT
		});
		inSecondaryMenu = true;
	}

	function uiFaderOut():Void
	{
		faderOut = FlxTween.tween(fader, {
			alpha: 0,
		}, 0.15, {
			type: FlxTweenType.ONESHOT
		});
		inSecondaryMenu = false;
	}

	function downloadClicked(download:FlxExtendedSprite):Void
	{
		if (!inSecondaryMenu)
		{
			downloadTimesClicked++;
			if (downloadTimesClicked == 1)
			{
				alert("This will download the latest version of the games and stuff launcher. It is only availible for Windows and does not work on iPad. \nFor iPad users, click the share button and click on Add to Home Screen. \nClick the download button again to download the launcher for windows. Drag the file to your desktop for easy access and double click to run.\nIf a menu shows up saying \"Do you want to run?\", turn off Always Ask before opening this file and click run. \nDownload menu coming soon.");
			}
			else
			{
				redirect("https://gamesandstuffdl--letsgoaway.repl.co");
			}
		}
	}

	function currentGameSupportsPC():Bool
	{
		return gameSupportsPlatforms[gameID][0];
	}

	function currentGameSupportsMobile():Bool
	{
		return gameSupportsPlatforms[gameID][1];
	}

	function currentGameSupportsGamepad():Bool
	{
		return gameSupportsPlatforms[gameID][2];
	}

	function triggerPlatforms():Void
	{
		if (currentGameSupportsPC())
		{
			if (platPC.alpha == 1)
			{
				mobileInAnim();
			}
			else
			{
				platPC.alpha = 0;
				platPC.x = 107;
				platPC.y = 407;
				pcIn = FlxTween.tween(platPC, {
					alpha: 1,
					x: 207
				}, 0.20, {
					type: FlxTweenType.ONESHOT,
					onComplete: mobileInAnim
				});
				pcIn.start();
			}
		}
		else
		{
			platPC.x = 0;
			platPC.y = 0;
		}
	}

	function mobileInAnim(?_:FlxTween):Void
	{
		if (currentGameSupportsMobile())
		{
			if (platMobile.alpha == 1)
			{
				gamepadInAnim();
			}
			else
			{
				if (currentGameSupportsPC())
				{
					platMobile.x = 207;
					platMobile.y = 407;
					platMobile.alpha = 0;

					mobileIn = FlxTween.tween(platMobile, {
						alpha: 1,
						x: 307
					}, 0.20, {
						type: FlxTweenType.ONESHOT,
						onComplete: gamepadInAnim
					});
					mobileIn.start();
				}
				else
				{
					gamepadInAnim();
				}
			}
		}
		else
		{
			platMobile.x = 0;
			platMobile.y = 0;
			platMobile.alpha = 0;
			gamepadInAnim();
		}
	}

	function gamepadInAnim(?_:FlxTween):Void
	{
		if (currentGameSupportsGamepad())
		{
			if (platGamepad.alpha == 1) {}
			else
			{
				if (currentGameSupportsPC())
				{
					if (currentGameSupportsMobile())
					{
						platGamepad.x = 307;
						platGamepad.x = 398;
						platGamepad.alpha = 0;
						gamepadIn = FlxTween.tween(platGamepad, {
							alpha: 1,
							x: 407
						}, 0.20, {
							type: FlxTweenType.ONESHOT
						});
						gamepadIn.start();
					}
					else
					{
						platGamepad.x = 207;
						platGamepad.alpha = 0;
						gamepadIn = FlxTween.tween(platGamepad, {
							alpha: 1,
							x: 307
						}, 0.20, {
							type: FlxTweenType.ONESHOT
						});
						gamepadIn.start();
					}
				}
			}
		}
		else
		{
			platGamepad.x = 0;
			platGamepad.y = 0;
			platGamepad.alpha = 0;
		}
	}

	function sound(i:String, ?wav:Bool):Void
	{
		if (!wav || wav == null)
		{
			if (s != null)
			{
				s.stop();
			}
			#if html5
			s = FlxG.sound.load(i + ".mp3"); // ogg files dont play on ios for some reason. at least for me they dont.
			s.play();
			#else
			#if flash
			s = FlxG.sound.load(i + "-flash.mp3"); // flash is wack and needs a specific sample rate
			s.play();
			#else
			s = FlxG.sound.load(i + ".ogg");
			s.play();
			#end
			#end
		}
		else
		{
			s = FlxG.sound.load(i + ".wav");
			s.play();
		}
	}

	function buttonClickFixFunc(tween:FlxTween):Void
	{
		startButtonFix = true;
	}

	function redirect(url:String):Void
	{
		#if html5
		Browser.window.location.href = url;
		#else
		FlxG.openURL(url);
		#end
	}

	// Mouse Related Scripts
	// Click
	function leftArrowClick(?leftArrow:FlxExtendedSprite):Void
	{
		if (!inSecondaryMenu)
		{
			if (gameID == 0)
			{
				gameID = gameStringID.length - 1;
			}
			else
			{
				gameID--;
			}
			gameID = gameID % gameStringID.length;
			togglePositions();
			sound("assets/sounds/left");
		}
	}

	function rightArrowClick(?rightArrow:FlxExtendedSprite):Void
	{
		if (!inSecondaryMenu)
		{
			sound("assets/sounds/right");
			gameID++;
			gameID = gameID % gameStringID.length;
			togglePositions();
		}
	}

	function playButtonClick(playButton:FlxExtendedSprite):Void
	{
		if (!inSecondaryMenu)
		{
			if (startButtonFix)
			{
				sound("assets/sounds/play");
				redirect("https://" + gameStringID[gameID] + ".letsgoaway.repl.co" + gameLinkEndTags[gameID]);
			}
		}
	}

	function fadeChar(?_:FlxTween):Void
	{
		charFadeIn = FlxTween.tween(gameChar, {
			alpha: 1
		}, 0.25, {
			type: FlxTweenType.ONESHOT,
			onComplete: fadeCover
		});
		charFadeIn.start();
	}

	function fadeCover(?_:FlxTween):Void
	{
		coverFadeIn = FlxTween.tween(gameCover, {
			alpha: 1
		}, 0.25, {
			type: FlxTweenType.ONESHOT
		});
		coverFadeIn.start();
	}

	function togglePositions(?dontDoFades:Bool):Void
	{
		gameCover.alpha = 0;
		gameChar.alpha = 0;

		if (!dontDoFades || dontDoFades == null)
		{
			fadeChar();
		}
		else // EXTREMELY LARGE PERFORMANCE BOOST for when you click to start. I dont know why, i dont know why half of this stuff works but it just does.
			// Thats just the laws of programming i guess
		{
			gameChar.alpha = 1;
			gameCover.alpha = 1;
		}
		if (!(gamepadIn == null))
		{
			gamepadIn.cancel();
		}
		if (!(mobileIn == null))
		{
			mobileIn.cancel();
		}
		if (!(pcIn == null))
		{
			pcIn.cancel();
		}
		triggerPlatforms();
		gameCover.animation.play(gameID + "game");
		gameChar.animation.play(gameID + "game");
		if (gameID == 0) // sm64
		{
			gameCover.x = -243;
			gameCover.y = -118;
			gameChar.x = 57;
			gameChar.y = -100;
		}
		else if (gameID == 1)
		{
			gameCover.x = -170;
			gameCover.y = -92;
			gameChar.x = 29;
			gameChar.y = -100;
		}
		else if (gameID == 2)
		{
			gameCover.x = -244;
			gameCover.y = -86;
			gameChar.x = 121;
			gameChar.y = -94;
		}
		else if (gameID == 3)
		{
			gameCover.x = -243;
			gameCover.y = -114;
			gameChar.x = 178;
			gameChar.y = -114;
		}
		else if (gameID == 4) // doom 2
		{
			gameCover.screenCenter(X);
			gameCover.y = -114;
		}
		else if (gameID == 5)
		{
			gameCover.x = -465;
			gameCover.y = -101;
			gameChar.x = 543;
			gameChar.y = -143;
		}
		else if (gameID == 6) // mc
		{
			gameCover.x = -232;
			gameCover.y = -116;
			gameChar.x = 11;
			gameChar.y = -99;
		}
		else if (gameID == 7)
		{
			gameCover.x = -176;
			gameCover.y = -113;
			gameChar.x = 40;
			gameChar.y = -110;
		}
		else
		{
			gameCover.x = -243;
			gameCover.y = -114;
			gameChar.x = 178;
			gameChar.y = -114;
		}
	}

	// Hover

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		currentGame = gameStringID[gameID];
		gamepad = FlxG.gamepads.lastActive;
		if (gamepad != null)
		{
			if (gamepad.justReleased.DPAD_LEFT)
			{
				leftArrowClick(leftArrow);
			}
			if (gamepad.pressed.DPAD_LEFT)
			{
				gamepad_left = true;
			}
			else
			{
				gamepad_left = false;
			}
			if (gamepad.justReleased.DPAD_RIGHT)
			{
				rightArrowClick(rightArrow);
			}
			if (gamepad.pressed.DPAD_RIGHT)
			{
				gamepad_right = true;
			}
			else
			{
				gamepad_right = false;
			}
			if (gamepad.justReleased.A)
			{
				if (started)
				{
					playButtonClick(playButton);
					_save.flush();
				}
				else
				{
					mouseDown = true;
					started = true;
				}
			}
		}
		else
		{
			gamepad_left = false;
			gamepad_right = false;
		}
		if (FlxG.mouse.pressed)
		{
			mouseDown = true;
			started = true;
		}
		else
		{
			mouseDown = false;
		}
		if (FlxG.keys.justReleased.LEFT)
		{
			if (started)
			{
				leftArrowClick();
			}
		}
		if (FlxG.keys.justReleased.F)
		{
			uiFaderOut();
		}
		if (FlxG.keys.justReleased.D)
		{
			uiFaderIn(0.5);
		}
		if (FlxG.keys.justReleased.RIGHT)
		{
			if (started)
			{
				rightArrowClick();
			}
		}
		if (FlxG.keys.justReleased.ENTER || FlxG.keys.justReleased.SPACE)
		{
			if (started)
			{
				playButtonClick(playButton);
				_save.flush();
			}
		}
		/*
		 * nice feedback thingy just test it trust me
		 */
		function uiGrowThingy(sprite:FlxExtendedSprite, maxGrow:Float, bool:Bool)
		{
			if (bool)
			{
				if (((sprite.scale.x + sprite.scale.y) / 2) < maxGrow)
				{
					sprite.scale.x += (elapsed * (0.11 * 60));
					sprite.scale.y += (elapsed * (0.11 * 60));
				}
			}
			else
			{
				if (((sprite.scale.x + sprite.scale.y) / 2) > 1)
				{
					sprite.scale.x -= (elapsed * (0.11 * 60));
					sprite.scale.y -= (elapsed * (0.11 * 60));
				}
				else
				{
					sprite.scale.x = 1;
					sprite.scale.y = 1;
				}
			}
		}
		_save.data.lastgameid = gameID;
		if (started)
		{
			if (!inSecondaryMenu)
			{
				uiGrowThingy(leftArrow, 1.15, FlxG.keys.pressed.LEFT || gamepad_left || leftArrow.mouseOver);
				uiGrowThingy(rightArrow, 1.15, FlxG.keys.pressed.RIGHT || gamepad_right || rightArrow.mouseOver);

				if (leftArrow.mouseOver || rightArrow.mouseOver || playButton.mouseOver || download.mouseOver)
				{
					Mouse.cursor = "button";
				}
				else
				{
					Mouse.cursor = "arrow";
				}
			}
			if (!menuLoaded)
			{
				menuLoaded = true;
			}
			if (!clicksoundstarted)
			{
				sound("assets/sounds/click");
				togglePositions(true);
				FlxTween.tween(title, {y: 0, "scale.x": 0.3, "scale.y": 0.3}, 0.5, {type: FlxTweenType.PERSIST, onComplete: buttonClickFixFunc});
				clicksoundstarted = true;
				leftArrow.alpha = 1;
				rightArrow.alpha = 1;
				playButton.alpha = 1;
				download.alpha = 1;
			}
			// else
			// {
			// if (titlesize > 0.3)
			// {
			// titlesize = titlesize - 0.01;
			// title.scale.set(titlesize, titlesize);
			// }
			// }
			TechnicFunctions.checkForFullScreenToggle();
			if (!maxClickAlpha) // fade out animation for the "click to start" text. smexy ui = smooth experience. (hopefully)
			{
				if (!(clicktostart.alpha == 0))
				{
					clicktostart.alpha -= 0.05;
				}
				else
				{
					maxClickAlpha = true;
					remove(clicktostart); // cleans up memory by juuust a little but performance is cool
				}
			}
		}
		else
		{
			platPC.alpha = 0;
			platMobile.alpha = 0;
			platGamepad.alpha = 0;
		}
	}
}
