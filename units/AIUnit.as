package units {
	import flash.utils.getDefinitionByName;
	import flash.net.URLRequest;
	import flash.events.Event;
	
	import db.EnemyDatabase;
	import db.dbData.EnemyData;
	
	import aiunits.*;
	
	import flash.geom.Point;
	
	import game.Game;
	
	public class AIUnit extends StatUnit {
		private var chaserange:Number;
		
		public static var m_enabled:Boolean = true;
		
		private var deleteFunction:Function = null;
		
		public function AIUnit(edat:EnemyData) {
			super(edat);
			
			setSpeed(unitData.speed);
			
			// load swf
			loadSwf();
		}
		
		private static function compileClasses():void {
			var aiClasses:Array = new Array(BasicAIUnit, 
											WarbearAI, 
											BossIraAI, 
											BurgerUnit, 
											JosSpawnPoint, 
											BossSocordiaAI, 
											InvulnerableUnit, 
											WristonSpawnPoint, 
											RattySpawnPoint,
											VendorAI,
											BossGulaAI);
		}
		
		public static function set enabled(val:Boolean):void {
			m_enabled = val;
		}
		
		public function getDeleteFunction():Function {
			return deleteFunction;
		}
		
		public function setDeleteFunction(deleteFunction:Function):void {
			this.deleteFunction = deleteFunction;
		}
		
		// prevent any possible conflict that results it in being standing-only
		override function completeLoad(e):void {
			super.completeLoad(e);
			
			addEventListener(Event.ENTER_FRAME, runnerAI);
		}
		public static function createAIUnit(id:String):AIUnit {
			var edat:EnemyData = Game.dbEnemy.getEnemyData(id);
			
			var AIClass:Class = getDefinitionByName("aiunits." + edat.ai) as Class;
			return new AIClass(edat);
		}
		
		override protected function deleteSelf():void {
			super.deleteSelf();
			removeEventListener(Event.ENTER_FRAME, runnerAI);
			
			if (deleteFunction != null) {
				deleteFunction(this);
			}
			
		}
		
		// just moves to player if player is in range
		protected function runnerAI(e:Event) {
			if (!m_enabled) {
				return;
			}
			
			if (progressData.health < 0) {
				Game.world.clearEnemy(this);
			}
			
			chaserange = 250;
			chasePlayer(chaserange);
		}
		protected function getCloserPlayer():StatUnit {
			var min:StatUnit;
			var minDist:Number = Number.MAX_VALUE;
			
			for (var i in Game.team) { //change targets to Game.team 
				var un:StatUnit = Game.team[i];
				
				// if not detector, ignore invisible units
				if (un.frameBuff.vanish && !frameBuff.detect) {
					continue;
				}
				
				var dx = un.x - x;
				var dy = un.y - y;
				var d = dx * dx + dy * dy;
				
				if (d < minDist) {
					min = un;
					minDist = d;
				}
			}
			
			return min;
		}
		protected function getDistance(g:GameUnit) {
			var dx = g.x - x;
			var dy = g.y - y;
			return Math.sqrt(dx * dx + dy * dy);
		}
		protected function chasePlayer(chaserange:int) {
			// if close to player
			var target:GameUnit = getCloserPlayer();
			chaseTarget(target, chaserange);
		}
		protected function chaseTarget(target:GameUnit, chaserange:int) {
			var dist:Number = getDistance(target);
			
			if (dist < chaserange) {
				moveTo(target.x, target.y);
			}
		}
		
		override public function prepareCastPoint():Point{
			var target:StatUnit = getCloserPlayer();
			var tp:Point = new Point(target.x, target.y);
			return tp;
		}
		
		override public function takeDamage(dmg:int):void {
			if (!m_enabled) {
				return;
			}
			
			super.takeDamage(dmg);
		}
	}
}