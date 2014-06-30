package  {
	
	import flash.display.MovieClip;
	
	
	public class testBox1 extends MovieClip {
		
		private var _isSpawned:Boolean = false;	// The objects haven't been spawn when they are created, so this checks if they are on the stage or not
		private var _moveSpeed:Number = 5;		// The move speed for the objects
		
		public function testBox1() {
			x = 0;						// When created will the object be placed at 0 on the x axies
			y = (Math.random()*500)+50;	// And in a random location on the y axies (from 50 to 550)
		}
		
		function spawn(){				// The function there makes the object spawn into the stage
			this._isSpawned = true;		// Spawn will be true, which will affect the update function in "SmaschCityScript"00
		}
		
		function deSpawn(){				// The function there despawns the object from the stage
			this._isSpawned = false;	// Spawn will be false, which will affact the update function in "SmashCityCript"
		}
		
		function update(){				// The update function which will update every frame
			this.x += _moveSpeed;		// Moves the object to the right
		}
		
//---Getters and Setters----------------------------------
		public function get isSpawned():Boolean{	// A getter to check if the object is spawned or not
			return _isSpawned;
		}
	}
	
}
