package;

import ceramic.TilemapLayerData;
import ceramic.TilemapData;
import ceramic.Tilemap;
import ceramic.Tileset;
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

	var tilemap:Tilemap;

	/**
	 * Add any asset you want to load here
	 */
	override function preload() {
		assets.add(Images.IMAGES__TILE);
	}

	override function create() {
		initMap();
		initPhysics();
		initPlayer();
		initCamera();
	}

	function initMap() {
		// Create our very simple one-tile tileset
        var tileset = new Tileset();
        // 0 = no tile
        // 1 = our single tile
        tileset.firstGid = 1;
        tileset.tileSize(8, 8);
        tileset.texture = assets.texture(Images.IMAGES__TILE);
        tileset.columns = 1;

        // Create our tile layer
        var layerData = new TilemapLayerData();
        layerData.name = 'main';
        layerData.grid(10, 10);
        layerData.tileSize(8, 8);
        layerData.tiles = [
            1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
            1, 0, 0, 0, 0, 0, 0, 0, 0, 1,
            1, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            1, 0, 1, 1, 1, 0, 0, 1, 1, 1,
            1, 0, 0, 0, 0, 0, 0, 1, 0, 1,
            1, 0, 0, 0, 0, 0, 0, 0, 0, 1,
            1, 0, 0, 1, 1, 1, 0, 0, 0, 1,
            1, 1, 1, 1, 0, 1, 1, 0, 0, 1,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
            1, 1, 1, 1, 1, 1, 1, 1, 1, 1
        ];

        // Create the tilemap data holding our tile layer
        var tilemapData = new TilemapData();
        tilemapData.size(
            layerData.columns * tileset.tileWidth,
            layerData.rows * tileset.tileHeight
        );
        tilemapData.tilesets = [tileset];
        tilemapData.layers = [layerData];

        // Then create the actual tilemap visual and assign it tilemap data
        tilemap = new Tilemap();
        tilemap.tilemapData = tilemapData;
        tilemap.pos(8, 8);

        add(tilemap);
	}
	
	function initPhysics() {
		app.arcade.autoUpdateWorldBounds = false;
		app.arcade.world.setBounds(x, y, width * 2, height * 2);

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
		camera.contentX = 0;
		camera.contentY = 0;
		camera.contentWidth = width / 2;
		camera.contentHeight = height / 2;

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
