
import flash.display.MovieClip;

faceIcon1.gotoAndStop(1);
faceIcon2.gotoAndStop(1);			

entries = new Array();
var chosenTeam = 0;

showEntries();
scrollPane.source = playerList;

var glowBegin = new GlowFilter(0x666666, 100, 30, 30, 3, 10, true, false);
beginButton.buttonText.text = "Start!";
beginButton.addEventListener(MouseEvent.MOUSE_OVER, overHandler);
beginButton.addEventListener(MouseEvent.MOUSE_OUT, outHandler);
beginButton.addEventListener(MouseEvent.CLICK, startLevel);

unitName1.text = "";
unitName2.text = "";
playerDisplay1.visible = false;
playerDisplay2.visible = false;

for (a = 1; a <= 4; a++) {
	playerDisplay1["button" + a].addEventListener(MouseEvent.CLICK, pageHandler);
	playerDisplay2["button" + a].addEventListener(MouseEvent.CLICK, pageHandler);
}

// show available teams in middle
showEntries();
chooseTeam(0);

function chooseTeam(team) {
	chosenTeam = team;
	// activate entry in middle
	entries[(chosenTeam >> 1)].gotoAndStop(2);
	
	unitName1.text = ActorDatabase.getName(chosenTeam);
	unitName2.text = ActorDatabase.getName(chosenTeam + 1);
	
	faceIcon1.gotoAndStop(chosenTeam + 1);
	faceIcon2.gotoAndStop(chosenTeam + 2);
}
function showEntries() {
	var names	= ActorDatabase.names;
	
	// Must only show available Units, not all Units!
	for (var i = 0; i < names.length; i += 2) {
		var entry = new Entry();
		entry.playerName1.text = names[i];
		entry.playerName2.text = names[i + 1];
		entry.id = i;
		entry.gotoAndStop(1);
		
		// GOTTA ADD LISTENERS TO ENTRIES AND GOTTA FIX THEM
		entry.addEventListener(MouseEvent.MOUSE_OVER, entryOverHandler);
		entry.addEventListener(MouseEvent.MOUSE_OUT, entryOutHandler);
		entry.addEventListener(MouseEvent.CLICK, clickHandler);

		// GOTTA ADD
		playerList.addChild(entry);
		entry.mouseChildren = false;
		entry.x = 0;
		entry.y = 16 * i;
		entries.push(entry);
	}
}


function update(display:MovieClip, page:Number, index:Number) {
	gotoAndStop(page);
	
	// show correct page
	display.portrait.visible = page == 1;
	display.page2.visible = page == 2;
	display.page3.visible = page == 3;
	display.page4.visible = page == 4;
	
	// update data inside page
	switch (currentFrame) {
		case 1 :
			display.portrait.gotoAndStop(index + 1);
			break;
		case 2 :
			// show stats
			display.page2.HPCount.text = ActorDatabase.getHP(index) + "";
			display.page2.APCount.text = ActorDatabase.getDmg(index) + "";
			display.page2.SPCount.text = ActorDatabase.getSpeed(index) + "";
			display.page2.weaponName.text = ActorDatabase.getWeapon(index);

			display.page2.wIcon.gotoAndStop(index + 1);
			break;
		case 3 :
			// show abilities
			// edit this later
			var basicAbilities = AbilityDatabase.getBasicAbilities(ActorDatabase.getName(index));

			for (var i = 0; i < icons.length; i++) {
				if (i < basicAbilities.length) {
					icons[i].useCount.visible = false;
					icons[i].visible = true;
					names[i].visible = true;
					descriptions[i].visible = true;
					icons[i].gotoAndStop(basicAbilities[i].index);
					names[i].text = basicAbilities[i].Name;
					descriptions[i].text = basicAbilities[i].getSpecInfo();
					icons[i].gotoAndStop(basicAbilities[i].index);
				} else {
					break;
				}
			}

			// hide advanced abilities
			for (i; i < icons.length; i++) {
				icons[i].gotoAndStop(1);
				icons[i].useCount.visible = false;
				icons[i].visible = false;
				names[i].visible = false;
				descriptions[i].visible = false;
			}
			break;
		case 4 :
			/*page4.ffName.text=ActorDatabase.getFFName(index);
			page4.ffDescription.text=ActorDatabase.getFFDescription(index);
			page4.ffBonus.text=ActorDatabase.getFFBonus(index);

			page4.ffIcon.gotoAndStop(Math.ceil((index+1)/2));*/
			page4.ffIcon.gotoAndStop(1);
			break;
	}

}