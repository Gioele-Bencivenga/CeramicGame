package;

import worldgen.Generator;
import ceramic.Text;
import entities.Player;
import ceramic.Visual;
import ceramic.TilemapLayerData;
import ceramic.TilemapData;
import ceramic.Tilemap;
import ceramic.Tileset;
import ceramic.Camera;
import ceramic.Scene;
import ceramic.StateMachine;
import elements.Im;

using Lambda;

enum GameState {
	TITLE_SCREEN;
	PLAYING;
	GAME_OVER;
}

class MainScene extends Scene {
	@component var machine = new StateMachine<GameState>();

	/**
	 * The camera ajusting the display to follow the player.
	 */
	var camera:Camera;

	/**
	 * The layer displaying player, world, ecc.
	 * 
	 * We'll translate this layer's content using the camera, while hud layer will remain static.
	 */
	var gameLayer:Visual;

	/**
	 * The loaded tilemap in ceramic format.
	 */
	var tilemap:Tilemap;

	var player:Player;

	var text:Text;

	/**
	 * Add any asset you want to load here
	 */
	override function preload() {
		assets.add(Images.IMAGES__TILE);

		assets.add(Fonts.FONTS__PIXELLARI);
	}

	override function create() {
		gameLayer = new Visual();
		gameLayer.size(width, height);
		add(gameLayer);

		initTileMap();
		initPlayer();
		initPhysics();
		initCamera();

		// Force "nearest neighbor" rendering on the pixellari font,
		// because that's a "pixel" font
		for (page in assets.font(Fonts.FONTS__PIXELLARI).pages) {
			page.filter = NEAREST;
		}

		// Called when scene has finished preloading
		text = new Text();
		text.content = 'target rotation: ${player.targetRotation}\nplayer rotation: ${player.rotation}';
		text.pointSize = 16;
		text.pos(20, 20);
		text.fitWidth = 400;
		text.depth = 11;
		text.font = assets.font(Fonts.FONTS__PIXELLARI);
		add(text);
	}

	function initTileMap() {
		// Create our very simple one-tile tileset
		var tileset = new Tileset();
		// 0 = no tile
		// 1 = our single tile
		tileset.firstGid = 1;
		tileset.tileSize(8, 8);
		tileset.texture = assets.texture(Images.IMAGES__TILE);
		tileset.columns = 1;

		// create the map generator (automatically generates a map)
		var gen = new Generator();
		gen.map = gen.initMap();
		gen.map = gen.generateCave(gen.map, gen.mapHeight, 100, 100);

		// Create our tile layer
		var layerData = new TilemapLayerData();
		layerData.name = 'walls';
		layerData.grid(gen.map[0].length, gen.map.length);
		layerData.tileSize(8, 8);
		layerData.tiles = gen.map.flatten();

		// Create the tilemap data holding our tile layer
		var tilemapData = new TilemapData();
		tilemapData.size(layerData.columns * tileset.tileWidth, layerData.rows * tileset.tileHeight);
		tilemapData.tilesets = [tileset];
		tilemapData.layers = [layerData];

		// Then create the actual tilemap visual and assign it tilemap data
		tilemap = new Tilemap();
		tilemap.tilemapData = tilemapData;
		tilemap.pos(0, 0);

		gameLayer.add(tilemap);
	}

	function initPhysics() {
		app.arcade.autoUpdateWorldBounds = false;
		app.arcade.world.setBounds(x, y, tilemap.tilemapData.width, tilemap.tilemapData.height);

		tilemap.initArcadePhysics();
		tilemap.collidableLayers = ['walls'];
		tilemap.layer('walls').checkCollision(true, true, true, true);

		app.arcade.onUpdate(this, updatePhysics);
	}

	function updatePhysics(delta:Float) {
		player.updatePhysics(delta, app.arcade.world, tilemap);
	}

	function initPlayer() {
		player = new Player();
		player.depth = 10;
		player.pos(tilemap.tilemapData.width / 2, tilemap.tilemapData.height - 20);
		player.gravityY = 150;
		player.drag(120, 120);
		player.maxVelocity(100, 100);
		player.mass = 0.1;
		gameLayer.add(player);
	}

	function initCamera() {
		camera = new Camera();

		// camera.trackSpeedX = 80;
		// camera.trackCurve = 0.3;
		// camera.trackSpeedY = 50;
		camera.zoom = 1.0;
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
		camera.target(player.x, player.y);

		// Then, let the camera handle these infos
		// so that it updates itself accordingly
		camera.update(delta);

		// Now that the camera has updated,
		// set the content position from the computed data
		gameLayer.x = camera.contentTranslateX;
		gameLayer.y = camera.contentTranslateY;
		gameLayer.scale(camera.zoom, camera.zoom);

		// Update tile clipping
		// (disables tiles that are outside viewport)
		tilemap.clipTiles(Math.floor(camera.x - camera.viewportWidth * 0.5), Math.floor(camera.y - camera.viewportHeight * 0.5),
			Math.ceil(camera.viewportWidth) + tilemap.tilemapData.maxTileWidth, Math.ceil(camera.viewportHeight) + tilemap.tilemapData.maxTileHeight);
	}

	override function update(delta:Float) {
		// Here, you can add code that will be executed at every frame

		text.content = 'target rotation: ${player.targetRotation}\nplayer rotation: ${player.rotation}';

		Im.begin('Options', 300);
		Im.expanded();
		Im.slideFloat('zoom', Im.float(camera.zoom), 0.01, 5);
		Im.end();
	}

	override function resize(width:Float, height:Float) {
		// Called everytime the scene size has changed
	}

	override function destroy() {
		// Perform any cleanup before final destroy

		super.destroy();
	}
}
