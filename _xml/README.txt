Maps.xml:
Map Code: width:height:code(tele-point 1,dstMap,dstPoint)(tele-point 2,dstMap,dstPoint)
[enemyspawn,type][enemyspawn,type]


-------------------------------------------
<Ability>
	<Name>Kendo Strike</Name>
	<Description>Some short description.</Description>
	<Type>Target/Point/Skillshot</Type>
	
	<Damage Value="50" />
	<MovementSpeed Value="500" />
	
	<BuffOnDamage>							// buffs set when damage is dealt
		<Self>
			<Heal>50</Heal>
			<HealRatio>.2</HealRatio>			// heal 20%
			<SpeedModifier Value="1.2" Duration="20" />	// 20% haste
		</Self>
		<Targets>
			<SpeedModifier Value=".9" Duration="20" />	// 10% slow
			<Stun Duration="20" />				// in frames
		</Targets>
	</BuffOnDamage>
	
	<Skillshot Width="50" Range="500" Penetrate="1">		// penetrate = number of enemies it'll go through
		<Projectile Speed="800" Sprite="projectile" />		// sprite = swf name
	</Skillshot>
	<Point Range="700" AOE="20">
		<Attack Sprite="splash" />
	</Point>
</Ability>
