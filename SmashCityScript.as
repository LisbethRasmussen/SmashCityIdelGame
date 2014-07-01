package  {
	
	import flash.display.MovieClip;
	import flash.sensors.Accelerometer;
	import flash.system.fscommand;
	
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import flash.net.SharedObject;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.text.engine.Kerning;
	
	import testBox1;
	
	
	public class SmashCityScript extends MovieClip {
		
		//så spillet kan gemmes-------------
		var saveK:saveKNAP;
		var loadK:loadKNAP;
		var so:SharedObject = SharedObject.getLocal("SmashCity");
		//------------------------------------
		//Point og research points-----------
		var coins:int = 0;
		var ResearchPoints:int = 0;
		var tekstP:TextField;
		var tekstRP:TextField;
		var TF:TextFormat;
		//------------------------------------
		
		// Variables there dosn't fall into a category---
		var stageWidth:int = 600;	// The width of the stage
		
		// Testing for enemy spawning--------
		var myTestBox1:testBox1;	// Creates the object for the "enemies"
		var testArray:Array;		// Creates an array there shall contain the "enemies" there will be spawned
		var spawnTimer:int;
		
		var parachuteTest:testBox2;			// Creates the object for the "Parachute guys"
		var parachuteStartPosition:Array;	// Creates an array there shall contain the position for each "Parachute guy"
		var parachuteSpawnTimer:int;
		
		public function SmashCityScript() {
			
			//-----------------------------------------------------------------
			saveK = new saveKNAP;
			saveK.x = 100;
			saveK.y = 100;
			addChild (saveK);
			
			loadK = new loadKNAP;
			loadK.x = 100;
			loadK.y = 100;
			addChild (loadK);
			
			saveK.addEventListener(MouseEvent.MOUSE_UP, musseting);
			loadK.addEventListener(MouseEvent.MOUSE_UP, musseting);
			//------------------------------------------------------------------
			
			TF = new TextFormat;
			TF.font ="_sans";
			TF.color = 0x000099;
			TF.size = 40;
			
			tekstP=new TextField;
			tekstP.x = 100;
			tekstP.y = 100;
			tekstP.defaultTextFormat = TF;
			tekstP.text = coins+"";
			addChild (tekstP);
			
			tekstRP=new TextField;
			tekstRP.x = 100;
			tekstRP.y = 100;
			tekstRP.defaultTextFormat = TF;
			tekstRP.text = ResearchPoints+"";
			addChild (tekstRP);
			
			// Enemy spawner ----------
			testArray = new Array(15);			// Creates the spaces to the array of enemies
			for(var i=0; i<15; i++){			// Enteres every entry of the array
				if(i < 10)
					testArray[i] = new testBox1();	// Sets a new "enemy" into the array
				else if (i >= 10 && i < 15)
					testArray[i] = new testBox2();
			}									// Note that this means that we are limited for a spesific amount of enemies (I think)
			spawnTimer = 0;						// Sets the spawntimer to 0 for the enemies
			parachuteSpawnTimer = 0;			// Sets the spawntimer to 0 for the Parachute guys
			parachuteStartPosition = new Array(200, 250, 300, 350, 400);	// An array containing the positions of the parachute guys
								// Look at the update function for how the enemies are spawned
			
			//------------------------------------------------------------------
			stage.addEventListener(Event.ENTER_FRAME, update);
		}
		
		function musseting(event:MouseEvent){
			
			if (saveK == event.currentTarget){
				so.data.hi = coins;
				so.data.hi2 = ResearchPoints;
				trace (so.data.hi);
			}
			if (loadK == event.currentTarget){
				coins = so.data.hi;
				tekstP.text = coins+"";
				ResearchPoints = so.data.hi2;
				tekstRP.text = ResearchPoints+"";
				trace ("load was pressed");
			}
			
		}
		function update(evt:Event):void{
			//insæt kode der opdaterer hver frame her
			spawnTimer++;										// The spawntimer counts up every frame
			if(spawnTimer >= 72){								// When reaching 72 frames (3 seconds) then:
				var rand:int = int(Math.random()*10);			// Generate a random number
				var testSelected:MovieClip = testArray[rand];	// Pick the entry in the array with this number
				testSelected.spawn();							// Run the spawn function (see the "testBox1" class)
				addChild(testSelected);							// Adds the object to the scene
				spawnTimer = 0;									// Resets the spawn timer for the enmies
			}
			
			parachuteSpawnTimer++;								// The spawntimer for the parachute guys counts up every frame
			if(parachuteSpawnTimer >= 240){						// When reaching 240 frames (10 seconds) then:
				for(var i:int = 10; i<15; i++){					// Enter all the "Parachute guy" entries
					testArray[i].setValueX(parachuteStartPosition[i - 10]);	// Set their X position from the array mentioned before
					testArray[i].setValueY(0 - 24 * (i - 10));	// Sets their Y position which gives a delayed effect (minus 24 for each entry)
					testArray[i].spawn();						// Run the spawn function (see the "testBox2" class)
					addChild(testArray[i]);						// Adds the object to the scene
				}
				parachuteSpawnTimer = 0;						// Resets the spawn timer for the parachute guys
			}
			
			// The following code checks for all the actions of the enemies
			for(var i:int = 0; i<15; i++){				// Go through every enemy entry in the array
				if(testArray[i].isSpawned == true){		// Are they spawned on the stage? if yes then:
					testArray[i].update();				// Run their update function there makes them move
					
					if(i < 10){								// The "Enemies" entries:
						if(testArray[i].x >= stageWidth){	// Have they reached the far right of the stage? If yes then:
							removeChild(testArray[i]);		// Remove the enemy object from the stage
							testArray[i].deSpawn();			// Run the deSpawn function (see the "testBox1" class)
						}
					}
					else if(i >= 10 && i < 15){				// The "Parachute guys" entires:
						if(testArray[i].y >= 400){			// Have they reached at a certain point on the stage? If yes then:
							removeChild(testArray[i]);		// Remove the enemy object from the stage
							testArray[i].deSpawn();			// Run the deSpawn function (see the "testBox2" class)
						}
					}
				}
			}
			
		} // End of update function
	}
	
}
