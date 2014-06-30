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
		
		// Testing for enemy spawning--------
		var myTestBox1:testBox1;	// Creates the object for the "enemies"
		var testArray:Array;		// Creates an array there shall contain the "enemies" there will be spawned
		var spawnTimer:int;
		
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
			testArray = new Array(10);			// Creates the spaces to the area
			for(var i=0; i<10; i++){			// Enteres every entry of the array
				testArray[i] = new testBox1();	// Sets a new "enemy" into the array
			}									// Note that this means that we are limited for a spesific amount of enemies (I think)
			spawnTimer = 0;
			
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
			spawnTimer++;
			if(spawnTimer >= 72){
				var rand:int = int(Math.random()*10);
				var testSelected:MovieClip = testArray[rand];
				//testSelected.spawn();
				addChild(testSelected);
				spawnTimer = 0;
			}
		}
	}
	
}
