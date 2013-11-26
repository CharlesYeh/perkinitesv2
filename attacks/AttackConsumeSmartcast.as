package attacks {
	import db.dbData.AttackData;
	import units.StatUnit;
	import flash.geom.Point;
	
	import aiunits.BossGulaAI;
	import aiunits.RattySpawnPoint;
	import game.Game;
	import game.SoundManager;
	import units.AIUnit;
	
	/**
	 * An attack which is cast on a circular shaped space.
	 */
	public class AttackConsumeSmartcast extends AttackSmartcast {
		
		
		override public function dealDamage():void {
			var targets:Array = targets();
			var i:String;
			var e:StatUnit;
			for (i in targets) {
				
				e = targets[i];
				
				if (StatUnit.distance(m_caster, e) < range) {
					e.takeDamage(damage());
					BossGulaAI.HUNGER -= (100 + Math.floor(Math.random() * 100));
				}
			}
			
			targets = Game.world.getEnemies();
			for (i in targets) {
				
				e = targets[i];
				
				if (StatUnit.distance(m_caster, e) < range && e != m_caster && !(e is RattySpawnPoint)) {
					e.takeDamage(damage() * 4);
					BossGulaAI.HUNGER -= (100 + Math.floor(Math.random() * 100));
				}
			}			
		}
	}
}