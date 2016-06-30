package  {
	
	import flash.display.MovieClip;
	
	
	public class ParashuteTooper extends MovieClip {
		
		private var _isSpawned:Boolean = false;	// The Parachute guys haven't been spawn when they are created, so this checks if they are on the stage or not
		private var _moveSpeed:int = 5;		// The move speed for the Parachute guys
		
		public function ParashuteTooper() {
			// constructor code
		}
		
		function spawn(){				// The function there makes the Parachute guys spawn into the stage
			this._isSpawned = true;		// Spawn will be true, which will affect the update function in "SmaschCityScript"
		}
		
		function deSpawn(){				// The function there despawns the Parachute guys from the stage
			this._isSpawned = false;	// Spawn will be false, which will affact the update function in "SmashCityCript"
		}
		
		function update(){				// The update function which will update every frame
			this.y += _moveSpeed;		// Moves the Parachute guys down
		}
		
//---Getters and Setters----------------------------------
		public function get isSpawned():Boolean{	// A getter to check if the Parachute guy is spawned or not
			return _isSpawned;
		}
		
		public function setValueX(newX:int){	// A setter to set the X position of the Parachute guys
			this.x = newX;
		}
		
		public function setValueY(newY:int){	// A setter to set the Y position of the Parachute guys
			this.y = newY;
		}
	}
	
}