package;

import ceramic.Screen;
import ceramic.Color;
import ceramic.Quad;
import ceramic.Camera;
import ceramic.Scene;

class MainScene extends Scene {
	var player:Player;

	/**
	 * The camera ajusting the display to follow the player
	 */
	var camera:Camera;

	/**
	 * Add any asset you want to load here
	 */
	override function preload() {}

	override function create() {
		initPhysics();
		initPlayer();
		initCamera();
	}

	function initPhysics() {
		app.arcade.autoUpdateWorldBounds = false;
		app.arcade.world.setBounds(x, y, width, height);

		initArcadePhysics();
	}

	function initPlayer() {
		player = new Player();
		player.depth = 10;
		player.pos(width * 0.5, height * 0.5);
		player.gravityY = 200;
	}

	function initCamera() {
		// Configure camera
		camera = new Camera();

		// We tweak some camera settings to make it work
		// better with our low-res pixel art display
		// camera.movementThreshold = 0.5;
		camera.trackSpeedX = 80;
		camera.trackCurve = 0.3;
		camera.trackSpeedY = 50;
		camera.zoom = 0.1;
		camera.clampToContentBounds = false;
		// camera.brakeNearBounds(0, 0);

		// We update the camera after everything else has been updated
		// so that we are sure it won't be based on some intermediate state
		app.onPostUpdate(this, updateCamera);

		// Update the camera once right away
		// (we use a very big delta so that it starts at a stable position)
		updateCamera(99999);
	}

	function updateCamera(delta:Float) {
		// Tell the camera what is the size of the viewport
		camera.viewportWidth = width;
		camera.viewportHeight = height;

		// Tell the camera what is the size and position of the content
		// camera.contentX = 0;
		// camera.contentY = 0;
		// camera.contentWidth = tilemap.tilemapData.width;
		// camera.contentHeight = tilemap.tilemapData.height;

		// Tell the camera what position to target (the player's position)
		camera.followTarget = true;
		camera.targetX = player.x;
		camera.targetY = player.y;

		// Then, let the camera handle these infos
		// so that it updates itself accordingly
		camera.update(delta);
	}

	override function update(delta:Float) {
		// Here, you can add code that will be executed at every frame
	}

	override function resize(width:Float, height:Float) {
		// Called everytime the scene size has changed
	}

	override function destroy() {
		// Perform any cleanup before final destroy

		super.destroy();
	}
}
