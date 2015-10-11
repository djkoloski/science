package;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxColor;
import flixel.util.FlxAngle;
import flixel.group.FlxGroup;
import flixel.util.FlxTimer;

enum DialogueManagerState
{
	DialogueManagerState_Opening;
	DialogueManagerState_Open;
	DialogueManagerState_Paused;
	DialogueManagerState_Closing;
	DialogueManagerState_Closed;
}

class DialogueManager extends FlxGroup
{
	public static var OPENING_TIME:Float = 0.5;
	public static var NEXT_CHAR_TIME:Float = 0.02;
	public static var PAUSE_TIME:Float = 1.0;
	public static var CLOSING_TIME:Float = 0.5;
	public static var LINE_LENGTH:Int = 50;
	public static var LINES_PER_DIALOG:Int = 4;
	
	public var state:PlayState;
	
	public var currentState:DialogueManagerState;
	
	public var dialogue:Dialogue;
	public var currentFrame:Int;
	public var currentIndex:Int;
	public var timer:Float;
	public var callback:Void->Void;
	
	public var foreground:FlxSprite;
	public var background:FlxSprite;
	public var text:FlxText;
	
	public function new(state:PlayState)
	{
		super();
		
		this.state = state;
		
		this.currentState = DialogueManagerState_Closed;
		
		this.dialogue = null;
		this.currentFrame = 0;
		this.currentIndex = 0;
		this.timer = 0.0;
		this.callback = null;
		
		foreground = new FlxSprite();
		foreground.makeGraphic(Math.round(FlxG.width / 3), Math.round(FlxG.height / 4), FlxColor.BLACK);
		foreground.scrollFactor.x = foreground.scrollFactor.y = 0;
		background = new FlxSprite();
		background.makeGraphic(Math.round(FlxG.width / 3), Math.round(FlxG.height / 4), FlxColor.WHITE);
		background.scrollFactor.x = background.scrollFactor.y = 0;
		text = new FlxText();
		text.scrollFactor.x = text.scrollFactor.y = 0;
		
		add(background);
		add(foreground);
		add(text);
		
		setYOffset(0);
	}
	
	public function transitionState(newState:DialogueManagerState)
	{
		currentState = newState;
		switch (currentState)
		{
			case DialogueManagerState_Opening:
				setText("");
				timer = OPENING_TIME;
				setYOffset(0);
			case DialogueManagerState_Open:
				setText("");
				timer = 0.0;
				currentIndex = 0;
				setYOffset(-1);
			case DialogueManagerState_Paused:
				timer = PAUSE_TIME;
			case DialogueManagerState_Closing:
				timer = CLOSING_TIME;
			case DialogueManagerState_Closed:
				setText("");
				timer = 0.0;
				setYOffset(0);
				if (callback != null)
					callback();
			default:
				throw "Invalid transition state";
		}
	}
	
	public function startDialogue(id:String, ?callback:Void->Void):Void
	{
		this.dialogue = state.dialogue.get(id);
		this.callback = callback;
		this.currentFrame = 0;
		this.currentIndex = 0;
		this.transitionState(DialogueManagerState_Opening);
	}
	
	public function closeDialogue():Void
	{
		this.transitionState(DialogueManagerState_Closing);
	}
	
	public function getCurrentFrame():DialogueFrame
	{
		return dialogue.frames[currentFrame];
	}
	
	public function setText(newText:String):Void
	{
		this.text.text = newText;
	}
	
	public function setYOffset(offset:Float):Void
	{
		var newX = (FlxG.width - this.foreground.width) / 2;
		var newY = FlxG.height + offset * this.foreground.height;
		
		this.foreground.x = newX;
		this.foreground.y = newY;
		this.background.x = newX;
		this.background.y = newY;
		this.text.x = newX;
		this.text.y = newY;
	}
	
	public override function update()
	{
		timer -= FlxG.elapsed;
		
		if (timer < 0)
		{
			switch (currentState)
			{
				case DialogueManagerState_Opening:
					transitionState(DialogueManagerState_Open);
				case DialogueManagerState_Open:
					if (currentIndex >= getCurrentFrame().message.length)
					{
						transitionState(DialogueManagerState_Paused);
					}
					else
					{
						++currentIndex;
						setText(getCurrentFrame().message.substr(0, currentIndex));
						timer = NEXT_CHAR_TIME;
					}
				case DialogueManagerState_Paused:
					if (currentFrame >= dialogue.frames.length)
					{
						transitionState(DialogueManagerState_Closing);
					}
					else
					{
						if (currentFrame < dialogue.frames.length - 1)
						{
							++currentFrame;
							currentIndex = 0;
							transitionState(DialogueManagerState_Open);
						}
						else
						{
							transitionState(DialogueManagerState_Closing);
						}
					}
				case DialogueManagerState_Closing:
					transitionState(DialogueManagerState_Closed);
				case DialogueManagerState_Closed:
				default:
					throw "Invalid state";
			}
		}
		else
		{
			switch (currentState)
			{
				case DialogueManagerState_Opening:
					var t:Float = (OPENING_TIME - timer) / OPENING_TIME;
					setYOffset(-t);
				case DialogueManagerState_Closing:
					var t:Float = (CLOSING_TIME - timer) / CLOSING_TIME;
					setYOffset(t - 1.0);
				default:
			}
		}
	}
}