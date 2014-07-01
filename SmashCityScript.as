package  {
	
	import flash.display.MovieClip;
	import flash.sensors.Accelerometer;
	import flash.system.fscommand;
	
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import flash.net.SharedObject; //needed to save the game progress on the computer
	
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
		var so:SharedObject = SharedObject.getLocal("SmashCity"); //the variable "so" will make sure that the game can be saved under the defined name: "SmashCity"
		//------------------------------------
		//Point og research points-----------
		var Coins:int = 0;				//to count the coins the giant has collected
		var ResearchPoints:int = 0;		//to count the research points the player can use for upgrades
		var tekstC:TextField;			//text field for the coins
		var tekstRP:TextField;			//text field for the research points
		var TF:TextFormat;				//a variable to hold the font of the text and size and color.
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
			saveK = new saveKNAP; //the graphical "button" this code actually needs to be the last thing spawned, or else it will be placed under the other objects.
			saveK.x = 400;
			saveK.y = 0;
			addChild (saveK);
			
			loadK = new loadKNAP; //same as the other.
			loadK.x = 500;
			loadK.y = 0;
			addChild (loadK);
			
			saveK.addEventListener(MouseEvent.MOUSE_UP, musseting); //they function by clicking with the mouse, ergo they must be activated under the function musseting (mousethings)
			loadK.addEventListener(MouseEvent.MOUSE_UP, musseting);
			//------------------------------------------------------------------
			
			TF = new TextFormat;
			TF.font ="_sans"; //comic sans
			TF.color = 0x000099; //blue, hexadecimal or something
			TF.size = 40;
			
			tekstC=new TextField; //coin counter
			tekstC.x = 20;
			tekstC.y = -8;
			tekstC.defaultTextFormat = TF;
			tekstC.text = Coins+"";
			addChild (tekstC);
			
			tekstRP=new TextField; //researche counter
			tekstRP.x = 20;
			tekstRP.y = 25;
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
			//-----------------------------------The save and load game code-------
			if (saveK == event.currentTarget){ 	//when this button is clicked
				so.data.hi = Coins;				//the so variable will create a "storer", which i have called "hi". It sets the "hi" storer to the value of the coins counter current number
				so.data.hi2 = ResearchPoints;	//and here is hi2 for saving the research points!
				trace (so.data.hi); //to check that it works
			}
			if (loadK == event.currentTarget){ 	//here the data is loaded, and the values in the textfields are set to the last saved values.
				Coins = so.data.hi; 			//load the number
				tekstC.text = Coins+"";			//set the number in the text field
				ResearchPoints = so.data.hi2;
				tekstRP.text = ResearchPoints+"";
				trace ("load was pressed");
			}
			//-----------------------------------End of the game save and load code--
			
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
