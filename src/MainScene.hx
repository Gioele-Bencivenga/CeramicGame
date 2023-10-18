package;

import ceramic.TilemapLayerData;
import ceramic.TilemapData;
import ceramic.Tilemap;
import ceramic.Tileset;
import ceramic.Camera;
import ceramic.Scene;
import ceramic.StateMachine;

enum GameState {
	TITLE_SCREEN;
	PLAYING;
	GAME_OVER;
}

class MainScene extends Scene {
	@component var machine = new StateMachine<GameState>();

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
		layerData.grid(26, 21);
		layerData.tileSize(8, 8);
		layerData.tiles = [
			1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
			1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			1, 0, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
			1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			1, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			1, 1, 1, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
		];

		// Create the tilemap data holding our tile layer
		var tilemapData = new TilemapData();
		tilemapData.size(layerData.columns * tileset.tileWidth, layerData.rows * tileset.tileHeight);
		tilemapData.tilesets = [tileset];
		tilemapData.layers = [layerData];

		// Then create the actual tilemap visual and assign it tilemap data
		tilemap = new Tilemap();
		tilemap.tilemapData = tilemapData;
		tilemap.pos(0, 0);

		add(tilemap);
	}

	function initPhysics() {
		app.arcade.autoUpdateWorldBounds = false;
		app.arcade.world.setBounds(x, y, tilemap.tilemapData.width, tilemap.tilemapData.height);

		initArcadePhysics();
	}

	function initPlayer() {
		player = new Player();
		player.depth = 10;
		player.pos(tilemap.tilemapData.width - 10, tilemap.tilemapData.height - 10);
		player.gravityY = 10;
	}

	function initCamera() {
		// Configure camera
		camera = new Camera();

		// camera.trackSpeedX = 80;
		// camera.trackCurve = 0.3;
		// camera.trackSpeedY = 50;
		camera.zoom = 1;
		camera.clampToContentBounds = false;

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
		camera.contentWidth = tilemap.tilemapData.width;
		camera.contentHeight = tilemap.tilemapData.height;

		// Tell the camera what position to target (the player's position)
		camera.followTarget = true;
		camera.targetX = player.x;
		camera.targetY = player.y;

		// Then, let the camera handle these infos
		// so that it updates itself accordingly
		camera.update(delta);

		// Now that the camera has updated,
		// set the content position from the computed data
		tilemap.x = camera.contentTranslateX;
		tilemap.y = camera.contentTranslateY;

		// Update tile clipping
		// (disables tiles that are outside viewport)
		tilemap.clipTiles(Math.floor(camera.x - camera.viewportWidth * 0.5), Math.floor(camera.y - camera.viewportHeight * 0.5),
			Math.ceil(camera.viewportWidth) + tilemap.tilemapData.maxTileWidth, Math.ceil(camera.viewportHeight) + tilemap.tilemapData.maxTileHeight);
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
