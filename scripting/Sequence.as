package scripting {
	
	import flash.utils.getDefinitionByName;
	
	import db.dbData.DatabaseData;
	
	import scripting.actions.*;
	import scripting.conditions.*;
	import scripting.controls.*;
	
	import game.Game;
	
	public class Sequence implements DatabaseData {
		
		public var id:String;
		public var repeatable:Boolean;
		public var saveable:Boolean = true;
		public var actions:Array;
		
		/** current action index within "actions" */
		private var m_index:int = 0;
		
		private var m_completed:Boolean = false;
		
		private function compileClasses():void {
			var actionTypes:Array = new Array(ActionControls, ActionBlackout, ActionSpeech, 
											  ActionWait, ActionNarrator, ActionMusic, 
											  ActionAI, ActionUnlockCharacters, 
											  ActionAnimate, ActionDelete, ActionSound, 
											  ActionCreate, ActionItem, ActionHUD, 
											  ActionJournal, ActionNotification, ActionSkip,
											  ActionTeleport, ActionClearEnemies, ActionNext,
											  ActionMove, ActionChangeTeam, ActionSequence,
											  ActionViewport, ActionPowerup, ActionEquip);
			var condTypes:Array = new Array(ConditionSequence, ConditionNearLocation, 
											ConditionBeatEnemy, ConditionClearedArea, ConditionNPC, 
											ConditionHasItem, ConditionCheckMode,
											ConditionCheckTeam, ConditionCountTeam,
											ConditionCheckChosen,
											ConditionAnd, ConditionOr, ConditionNot);
			var controlTypes:Array = new Array(Control, ControlDecision);
		}
		
		public function parseData(obj:Object):void {
			id = obj.id;
			repeatable = obj.repeatable;
			saveable = (obj.saveable != null) ? obj.saveable : true;
			
			actions = new Array();
			for (var i:String in obj.actions) {
				var fdat:Array = obj.actions[i];
				var frame:Array = new Array();
				
				for (var j:String in fdat) {
					var adat:Object = fdat[j];
					
					var a:Action = createAction(adat.type);
					a.parseData(adat);
					frame.push(a);
				}
				
				actions.push(frame);
			}
		}
		
		public static function createAction(type:String):Action {
			var pkg:String = "";
			if (type.indexOf("Action") == 0) {
				pkg = "scripting.actions.";
			}
			else if (type.indexOf("Condition") == 0) {
				pkg = "scripting.conditions.";
			} 
			else if (type.indexOf("Control") == 0) {
				pkg = "scripting.controls.";
			}
			
			var ActionClass:Class = getDefinitionByName(pkg + type) as Class;
			
			var act:Action = new ActionClass();
			return act;
		}
		
		public function start():void {
			m_index = 0;
			m_completed = false;
			
			// test whether this sequence has been done before
			if (actions.length == 0 || (id != null && Game.playerProgress.hasCompletedSequence(id))) {
				m_completed = true;
			} 
			
			// start first frame
			if(!m_completed){
				reset();
				startFrame();
			}
		}
		
		public function reset():void {
			for(var i:String in actions) {
				var frame:Array = actions[i];
				for(var j:String in frame) {
					var action:Action = frame[j];
					action.reset();	
				}
			}
			m_completed = false;
		}
		
		protected function startFrame():void {
			var frame:Array = actions[m_index];
			
			for (var i:String in frame) {
				var action:Action = frame[i];
				action.act();	
			}
		}
		
		public function getIndex():int {
			return m_index;
		}
		
		public function updateActions():void {
			if (m_completed) {
				return;
			}
			
			var frame:Array = actions[m_index];
			
			var allCompleted:Boolean = true;
			for (var i:String in frame) {
				var act:Action = frame[i];
				
				// update all actions, and see if all are done
				allCompleted = act.update() && allCompleted;
			}
			if (allCompleted) {
				m_index++;
				
				if (m_index == actions.length) {
					complete();
				}
				else{
					startFrame();
				}
			}
		}
		
		public function complete():void {
			if (!repeatable && id != null) {
				Game.playerProgress.addCompletedSequence(id);
			}
			if (saveable && id != null) {
				//----------------AUTO-SAVE----------------					
				//Game.playerProgress.save();
			}			
			Game.world.checkNPCConditions();
			m_completed = true;
		}
		
		public function update():Boolean {
			return m_completed;
		}
	}
}