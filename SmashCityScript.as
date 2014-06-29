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
		
		
		public function SmashCity() {
			
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
		}
	}
	
}
