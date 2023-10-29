package entities;

import arcade.Body;
import ceramic.Group;
import ceramic.Tilemap;
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

	/**
	 * A smaller physics body
	 * 
	 * Taken from pixel platformer sample, no clue why there are 2
	 */
	public var dotBodyBottom(default, null) = new Body(0, 0, 2, 2);

	/**
	 * A smaller physics body
	 * 
	 * Taken from pixel platformer sample, no clue why there are 2
	 */
	public var dotBodyTop(default, null) = new Body(0, 0, 2, 2);

	public function new() {
		super();

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

		// Default animation
		// animation = 'idle';

		// Default direction
		// scaleX = -1;

		// Actual size used by physics
		size(5, 6);

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
		var desiredRotation = 0;
		var velX = 0;
		var velY = 0;
		var velChange = 500;
		if (inputMap.pressed(RIGHT)) {
			velX = velChange;
			scaleX = -1;
			desiredRotation = 90;
		}
		if (inputMap.pressed(LEFT)) {
			velX = -velChange;
			scaleX = 1;
			desiredRotation = 270;
		}
		if (inputMap.pressed(UP)) {
			velY = -velChange;
			scaleY = 1;
			desiredRotation = 0;
		}
		if (inputMap.pressed(DOWN)) {
			velY = velChange;
			scaleY = -1;
			desiredRotation = 180;
		}

		if (rotation < desiredRotation) {
			angularVelocity = 500;
		} else if (rotation > desiredRotation) {
			angularVelocity = -500;
		}else{
			angularVelocity = 0;
		}

		// if (velX != 0) {
		//	velocityX = velX;
		// }
		// if (velY != 0) {
		//	velocityY = velY;
		// }
		acceleration(velX, velY);
	}

	public function updatePhysics(delta:Float, world:ArcadeWorld, tilemap:Tilemap /*, boxes:Group<Box>*/) {
		// Update dot body
		updateDotBodies();

		// Collide player with boxes
		// world.collide(this, boxes);

		// Collide player with tilemap at each frame
		world.collide(this, tilemap);
	}

	function updateDotBodies() {
		dotBodyBottom.x = x - dotBodyBottom.width * 0.5;
		dotBodyBottom.y = y - dotBodyBottom.height;

		dotBodyTop.x = x - dotBodyTop.width * 0.5;
		dotBodyTop.y = y - height;
	}
}
