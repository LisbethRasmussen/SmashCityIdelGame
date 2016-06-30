package  {
	
	import flash.display.MovieClip;
	
	import SmashCityScript;
	
	public class DaTankv2 extends MovieClip {
		
		private var _isSpawned:Boolean = false;		// The Thanks haven't been spawn when they are created, so this checks if they are on the stage or not
		private var _moveSpeed:int = 5;				// The move speed for the Tanks
		private var _shootTimer:int = 0;			// The timer for when the Tanks shall shoot
		private var _isShooting:Boolean = false;	// The bool there dertimines if a Tank have shot a Grenade or not
		private var _myTestBox3:testBox3;			// Creates the Shoot effect on the tank (Composition)
		private var _goRight = false;				// Determines if the tank shall go right
		private var _rightSpawnX;
		
		public function DaTankv2(goRight:Boolean) {
			_myTestBox3 = new testBox3;			// Creates a new Shoot effect on the stage
			_goRight = goRight;
			
			if (_goRight){
				this.scaleX *= -1;				// Flips the object so it faces the 'right' way
			}
		}
		
		function spawn(){				// The function there makes the object spawn into the stage
			this._isSpawned = true;		// Spawn will be true, which will affect the update function in "SmaschCityScript"
			if (_goRight)
				this.x = SmashCityScript.leftSpawnX;
			else
				this.x = SmashCityScript.rightSpawnX;
		}
		
		function deSpawn(){				// The function there despawns the object from the stage
			this._isSpawned = false;	// Spawn will be false, which will affact the update function in "SmashCityCript"
		}
		
		function update(){				// The update function which will update every frame
			if (_goRight){
				this.x += _moveSpeed;		// Moves the object to the right
			}
			else {
				this.x -= _moveSpeed;		// Moves the object to the left
			}
			
			_shootTimer++;				// The counter for the shot will count up each frame
			if(_shootTimer == 48){		// After 2 seconds will the tank shoot!
				addChild(_myTestBox3);	// Add the shoot effect
				_isShooting = true;		// Telling the program that it is shooting (which affects the main script)
			}
			else if(_shootTimer == 52){		// After aditional 4 frames:
				removeChild(_myTestBox3);	// Remove the shooting effect
				_shootTimer = 0;			// Reset the shoot timer
			}
		}
		
//---Getters and Setters----------------------------------
		public function get isSpawned():Boolean{	// A getter to check if the Tank is spawned or not
			return _isSpawned;
		}
		
		public function get valueX():int{	// A getter to optain the Tank's X value
			return this.x;
		}
		
		public function get valueY():int{	// A getter to optain the Tank's Y value
			return this.y;
		}
		
		public function get isShooting():Boolean{	// A getter to check if the Tank is shooting or not
			return _isShooting;
		}
		
		public function setisShooting(Q:Boolean){	// A setter to set when the Tank have made a shot
			_isShooting = Q;
		}
	}
	
}
