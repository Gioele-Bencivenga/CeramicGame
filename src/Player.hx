import ceramic.ArcadeWorld;
import ceramic.Quad;
import ceramic.SpriteSheet;
import ceramic.Assets;
import ceramic.StateMachine;
import ceramic.InputMap;

/**
 * The different states the player can have.
 */
enum abstract PlayerState(Int) {
	/**
	 * Player's idle state: standing still
	 */
	var IDLING;

	/**
	 * Player is using thrusters to move
	 */
	var THRUSTING;
}

/**
 * The input keys that will make player interaction
 */
enum abstract PlayerInput(Int) {
	var RIGHT;
	var LEFT;
	var DOWN;
	var UP;
	var FIRE;
}

class Player extends Quad {
	/**
	 * A state machine plugged as a `Component` to `Player` using `PlayerState`
	 * as an enum that provides the different possible states.
	 *
	 * Because this state machine is here, `{STATE}_enter()/update()/exit()` are
	 * automatically called if they exist in the `Player` class and the corresponding
	 * state is the current machine's state.
	 */
	@component var machine = new StateMachine<PlayerState>();

	/**
	 * To handle input from multiple input devices (keyboard, gamepad...)
	 */
	var inputMap = new InputMap<PlayerInput>();

	public function new() {
		super();

		// We'll set size ourselves
		// autoComputeSize = false;

		initArcadePhysics();

		// Make this body collide with world bounds
		body.collideWorldBounds = true;

		// Create sprite sheet needed for this player
		// sheet = new SpriteSheet();
		// sheet.texture = assets.texture(Images.IMAGES__CHARACTERS__SHIP__ALIEN);
		// sheet.grid(176, 26);
		// sheet.addGridAnimation('idle', [0], 0);
		// sheet.addGridAnimation('straight', [1, 2], 0.1);
		// sheet.addGridAnimation('slight_right', [3, 4], 0.1);
		// sheet.addGridAnimation('slight_left', [5, 6], 0.1);
		// sheet.addGridAnimation('full_right', [7, 8], 0.1);
		// sheet.addGridAnimation('full_left', [9, 10], 0.1);

		// Correct anchor
		anchor(0.5, 0.5);

		// Ensure the final/visible position will always be rounded
		// quad.roundTranslation = 1;

		// Default animation
		// animation = 'idle';

		// Default direction
		scaleX = -1;

		// Actual size used by physics
		size(18, 22);
		// frameOffset(-3, -2);

		// Init input
		bindInput();

		// Default state
		machine.state = IDLING;
	}

	// override function update(delta:Float) {
	//	// Update sprite
	//	super.update(delta);
	// }

	function bindInput() {
		// Bind keyboard
		inputMap.bindKeyCode(RIGHT, RIGHT);
		inputMap.bindKeyCode(LEFT, LEFT);
		inputMap.bindKeyCode(DOWN, DOWN);
		inputMap.bindKeyCode(UP, UP);
		inputMap.bindKeyCode(FIRE, SPACE);
		// We use scan code for these so that it
		// will work with non-qwerty layouts as well
		inputMap.bindScanCode(RIGHT, KEY_D);
		inputMap.bindScanCode(LEFT, KEY_A);
		inputMap.bindScanCode(DOWN, KEY_S);
		inputMap.bindScanCode(UP, KEY_W);
		// Bind gamepad
		inputMap.bindGamepadAxisToButton(RIGHT, LEFT_X, 0.25);
		inputMap.bindGamepadAxisToButton(LEFT, LEFT_X, -0.25);
		inputMap.bindGamepadAxisToButton(DOWN, LEFT_Y, 0.25);
		inputMap.bindGamepadAxisToButton(UP, LEFT_Y, -0.25);
		inputMap.bindGamepadButton(RIGHT, DPAD_RIGHT);
		inputMap.bindGamepadButton(LEFT, DPAD_LEFT);
		inputMap.bindGamepadButton(DOWN, DPAD_DOWN);
		inputMap.bindGamepadButton(UP, DPAD_UP);
		inputMap.bindGamepadButton(FIRE, A);
	}

	function IDLING_update(delta) {
		updateMovement(delta);
	}

	function updateMovement(delta:Float) {
		if (inputMap.pressed(RIGHT)) {
			velocityX = 100;
			scaleX = -1;
		}
		else if(inputMap.pressed(LEFT)){
			velocityX = -100;
			scaleX = 1;
		}
		else if(inputMap.pressed(UP)){
			velocityY = -300;
			scaleY = 1;
		}
		else if(inputMap.pressed(DOWN)){
			velocityY = 100;
			scaleY = -1;
		}else {
			velocityX = 0;
			velocityY = 0;
		}
	}
}
