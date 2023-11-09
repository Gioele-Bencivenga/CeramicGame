package worldgen;

import Random;

class Generator {
	/**
	 * Tilemap's height
	 */
	public var mapHeight:Int;

	/**
	 * Tilemap's width
	 */
	public var mapWidth:Int;

	/**
	 * The 2-d array that will give the tilemap its structure.
	 */
	public var map:Array<Array<Int>>;

	public function new() {}

	public function initMap(height = 200, width = 150, value = 1) {
		mapHeight = height;
		mapWidth = width;
		var newMap = [for (y in 0...mapHeight) [for (x in 0...mapWidth) value]];

		return newMap;
	}

	/**
	 * Carves a cave-like structure out of a map.
	 * @param length how long the cave should be (in tiles)
	 * @param roughness how much the cave can vary in width
	 * @param windiness how much the cave's path swerves
	 */
	public function generateCave(map:Array<Array<Int>>, length:Int, roughness:Int, windiness:Int) {
		var minCaveWidth = 16;
		var maxCaveWidth = minCaveWidth * 3;
		var startWidth = minCaveWidth * 2;
		var startHeight = 5;
		var startX = Std.int(mapWidth / 2 - startWidth / 2);
		var startY = mapHeight - startHeight - 1;

		// create first empty space at the bottom
		map = fillRect(map, startX, startY, startWidth, startHeight, 0);

		var currX = startX;
		var currY = startY;
		var currWidth = startWidth;
		var currLength = startHeight;

		// iterative part
		while (currLength < length - startHeight - 1) {
			currY--; // move up 1 tile
			currLength++;

			var shouldChangeWidth = Random.int(0, 100);
			if (shouldChangeWidth < roughness) {
				// maybe parametrize so this also can be changed like roughness?
				var amount = Random.fromArray([-4, -2, 2, 4]);
				currX += Std.int(-amount / 2);
				currWidth += amount;
				if (currWidth < minCaveWidth) {
					currWidth = minCaveWidth;
				} else if (currWidth > maxCaveWidth) {
					currWidth = maxCaveWidth;
				}
			}
			var shouldSwerve = Random.int(0, 100);
			if (shouldSwerve < windiness) {
				// maybe parametrize so this also can be changed like windiness?
				var amount = Random.fromArray([-2, -1, 1, 2]);
				currX += amount;
				if (currX < 1) {
					currX = 1;
				} else if (currX + currWidth > mapWidth - 1) {
					currX = mapWidth - currWidth - 1;
				}
			}

			map = fillRect(map, currX, currY, currWidth, 1, 0);
		}

		// final section
		var finishHeight = startHeight;
		var finishWidth = currWidth;
		currY = currY - finishHeight;
		map = fillRect(map, currX, currY, finishWidth, finishHeight, 0);
		
		return map;
	}

	function fillRect(map:Array<Array<Int>>, x:Int, y:Int, width:Int, height:Int, value:Int) {
		for (indexY in 0...height) {
			for (indexX in 0...width) {
				map[y + indexY][x + indexX] = value;
			}
		}
		return map;
	}

	public function testFillRect() {
		map = initMap(4, 4);

		trace('created map:
		\n${map[0]}
		\n${map[1]}
		\n${map[2]}
		\n${map[3]}
		');

		fillRect(map, 1, 1, 4, 2, 0);

		trace('modified map:
		\n${map[0]}
		\n${map[1]}
		\n${map[2]}
		\n${map[3]}
		');
	}
}
