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
	
	import DaTankv2RH0jre;
	import DaTankv2;
	import testBox2;
	
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
		
		// General vaules--------------------
		var i:int;
		var rand:int;
		
		// Testing for enemy spawning--------
		var tankRight:DaTankv2RH0jre;	// Creates the object for the Tanks (Right)
		var tankLeft:DaTankv2;			// Creates the object for the Tanks (Left)
		var enemyArray:Array;			// Creates an array there shall contain the Tanks there will be spawned
		var tankSpawnTimer:int = 0;		// Creates an int there shall work as a timer for the Tanks
		var grenade:testBox4;			// Creates the object for the Grenades
		var ammoArray:Array;			// Creates an array there shall contain the Grenades there will be spawned
		var grenadeSpeed:int = 10;		// Creates an int there hold the speed of the Grenades
		
		var parachuteTest:testBox2;			// Creates the object for the Parachute guys
		var parachuteStartPosition:Array;	// Creates an array there shall contain the position for each Parachute guy
		var parachuteSpawnTimer:int = 0;	// Creates an int there shall work as a timer for the Parachute guys
		
		var peopleTest:testBox1;		// Creates the test object for the running people
		var peopleArray:Array;			// Creates an array there shall contain all the people
		var peopleSpawnArray:Array;		// Creates an array there shall contain if a person have spawned or not
		var peopleSpawnTimer:int = 0;	// Creates an int there shall work as a timer for the people
		var peopleMoveSpeed:int = 5;	// Creates an int there shall work as the people's move speed
		
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
			enemyArray = new Array(15);				// Creates the spaces to the array of Enemies
			ammoArray = new Array(10);				// Creates the spaces to the array of ammo the Tanks have
			for(i = 0; i < enemyArray.length; i++){	// Enteres every entry of the array of Enemies
				if(i < 5)							// The first 5 entries:
					enemyArray[i] = new DaTankv2RH0jre();	// Sets a new Tank (Right) into the array of Enemies
				else if (i >= 5 && i < 10){			// The next 5 entries:
					enemyArray[i] = new DaTankv2();	// Sets a new Tank (Left) into the array of Enemies
					enemyArray[i].x = 800;			// To solve a bug will te Left Tanks set thier x value here.
				}
				else if (i >= 10 && i < 15)			// Next 5 entries:
					enemyArray[i] = new testBox2();	// Sets a new Parachute guy into the array of Enemies
					
				if (i < ammoArray.length)
					ammoArray[i] = new testBox4();	// Sets a new grenade into the array of Ammo
			}
			parachuteStartPosition = new Array(200, 250, 300, 350, 400);	// An array containing the positions of the Parachute guys
							// ----- Look at the update function for how the Eneimes are spawned -----
			// People ------------------
			peopleArray = new Array(100);					// Creates the spaces to the array of people
			peopleSpawnArray = new Array(peopleArray.length);	// Creates the spaces to the people spawn array
			for(i = 0; i < peopleArray.length; i++){		// Enteres every entry of the array of people
				peopleArray[i] = new testBox1;				// Sets a new testBox1 into the array of people
				peopleSpawnArray[i] = new Boolean;			// Sets a new Boolean into the people spawn array
				peopleSpawnArray[i] = false;				// Sets all the entries to be flase in the people spawn array
			}
			
			
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
			tankSpawnTimer++;									// The spawn timer for the Tanks counts up every frame
			if(tankSpawnTimer >= 72){							// When reaching 72 frames (3 seconds) then:
				rand = int(Math.random()*10);					// Generate a random number from 0 to 9, the number will then be the entry in the array
				enemyArray[rand].y = (Math.random()*50)+450;	// When created will the Tank be placed in a random location on the y axies (from 450 to 500)
				enemyArray[rand].spawn();						// Run the spawn function
				addChild(enemyArray[rand]);						// Adds the Tank to the scene
				tankSpawnTimer = 0;								// Resets the spawn timer for the Tanks
			}
			
			parachuteSpawnTimer++;								// The spawn timer for the Parachute guys counts up every frame
			if(parachuteSpawnTimer >= 240){						// When reaching 240 frames (10 seconds) then:
				for(i = 10; i < 15; i++){						// Enter all the Parachute guy entries in the Enemies array
					enemyArray[i].setValueX(parachuteStartPosition[i - 10]);	// Set their X position from the position array mentioned before
					enemyArray[i].setValueY(0 - 24 * (i - 10));	// Sets their Y position which gives a delayed effect (minus 24 for each entry)
					enemyArray[i].spawn();						// Run the spawn function (see the "testBox2" class)
					addChild(enemyArray[i]);					// Adds the object to the scene
				}
				parachuteSpawnTimer = 0;						// Resets the spawn timer for the Parachute guys
			}
			
			peopleSpawnTimer++;									// The spawn timer for the people counts up every frame
			if(peopleSpawnTimer >= 24){							// When reaching 24 frames (1 second) then:
				rand = int(Math.random()*100);					// Generate a random number from 0 to 99, the number will then be the entry in the array
				peopleArray[rand].y = (Math.random()*50)+450;	// When created will the person be placed in a random location on the y axies (from 450 to 500)
				if(rand < 50)									// If the random number is one of the first 50 entries (Those there walk right) then:
					peopleArray[rand].x = 0;					// Set their x value to 0 (left side of the screen)
				else											// Else if the random number is one of the last 50 entries (those there walk left) then:
					peopleArray[rand].x = 800;					// Set their x value to 800 (right side of the screen)
				peopleSpawnArray[rand] = true;					// Sets the entries spawn value to true in the spawn people array
				addChild(peopleArray[rand]);					// Adds the Tank to the scene
				peopleSpawnTimer = 0;							// Resets the spawn timer for the Tanks
			}
			
			// The following code checks for all the actions of the Enemies
			for(i = 0; i < 15; i++){					// Go through every enemy entry in the enemy array
				if(enemyArray[i].isSpawned == true){	// Are the current enemy spawned on the stage? if yes then:
					enemyArray[i].update();				// Run the current enemy update function there makes it move
					
					if(i < 10){									// The Tank entries:
						if(i < 5){								// The Right Tank entries:
							if(enemyArray[i].x >= 800){			// Have the current Tank reached the far right of the stage? If yes then:
								removeChild(enemyArray[i]);		// Remove the current Tank from the stage
								enemyArray[i].deSpawn();		// Run the deSpawn function
								enemyArray[i].x = 0;			// Resets the Tanks spawning point
							}
						}
						else if(i >= 5 && i < 10){				// The Left Tank entries:
							if(enemyArray[i].x <= 0){			// Have the current Tank reached the far left of the stage? If yes then:
								removeChild(enemyArray[i]);		// Remove the current Tank from the stage
								enemyArray[i].deSpawn();		// Run the deSpawn function
								enemyArray[i].x = 800;			// Resets the Tanks spawning point
							}
						}
						if(enemyArray[i].isShooting == true){		// Is the Tank currently shooting a Grenade? If yes then:0
							ammoArray[i].x = enemyArray[i].valueX;	// Set the Grenades's X value as the same as the Tank's X value
							ammoArray[i].y = enemyArray[i].valueY;	// Set the Grenades's Y value as the same as the Tank's Y value
							addChild(ammoArray[i]);					// Add the Grenade to the stage
							enemyArray[i].setisShooting(false);		// A Grenade have been shot! So no more shall be spawned! Better set it to false
						}
						// The following code makes the current Grenade in the array move towards the center of the stage (300,300)
						if(ammoArray[i].x > 400){
							ammoArray[i].x -= grenadeSpeed;
						}
						else if(ammoArray[i].x < 400){
							ammoArray[i].x += grenadeSpeed;
						}
						if(ammoArray[i].y > 300){
							ammoArray[i].y -= grenadeSpeed;
						}
						else if(ammoArray[i].y < 300){
							ammoArray[i].y += grenadeSpeed;
						}
					}
					else if(i >= 10 && i < 15){				// The Parachute guys entires:
						if(enemyArray[i].y >= 400){			// Have the current Parachute guy reached at a certain point on the stage? If yes then:
							removeChild(enemyArray[i]);		// Remove the current Parachute guy from the stage
							enemyArray[i].deSpawn();		// Run the deSpawn function (see the "testBox2" class)
						}
					}
				}
			}
			
			// The following code checks for all the actions of the People
			for(i = 0; i < peopleArray.length; i++){		// Go through every people entry in the people array
				if(peopleSpawnArray[i] == true){			// If the current person have been spawned to the stage then:
					if(i < 50){								// The right running people entries:
						peopleArray[i].x += peopleMoveSpeed;// Moves the person to the right when it have been spawned
						if(peopleArray[i].x >= 800){		// Have the current person reached the far right of the stage? If yes then:
							removeChild(peopleArray[i]);	// Remove the current person from the stage
							peopleSpawnArray[i] = false;	// Sets the current person's spawn to false
							peopleArray[i].x = 0;			// Resets the person's spawning point
						}
					}
					else if(i >= 50 && i < 100){			// The left running people entries:
						peopleArray[i].x -= peopleMoveSpeed;// Moves the person to the left when it have been spawned
						if(peopleArray[i].x <= 0){			// Have the current person reached the far left of the stage? If yes then:
							removeChild(peopleArray[i]);	// Remove the current person from the stage
							peopleSpawnArray[i] = false;	// Sets the current person's spawn to flase
							peopleArray[i].x = 800;			// Resets the Person's spawning point
						}
					}
				}
			}
			
		} // End of update function
	}
	
}