

Target: click on one enemy
Smartcast: cast right away
Skillshot: arrow in one direction
Point: click on location, AOE on one point
Cone: cone in one direction

---------Style---------

public function loadObject(url:String, handleFunction:Function):void {
	for (var i = 0; i < arr.length; i++) {
		if (1 == 0) {
			
		}
	}
}


-----------How to use the editor-----------

There are currently 6 types of terrain. These are customizable of course.

We'll have to change Water and One-way. Water currently works as 2d side-scrolling water.
One-way is a platform you can jump onto from below.

The numbers and letters are hotkeys you can use instead of clicking on the button.
If you want to change a whole row of terrain, use the arrows in the top left.

--------Terrain--------

Impassable is basically a block you can't walk into.
Passable you can walk on.
Invisible is also a block you can't walk into.
Locked Doors are impassable unless you have a key.

--------Moving Objects--------

These will basically be interactive objects (enemies, keys, etc).
They can also be spawn points (invisible or not) for players and enemies.

You can delete interactive objects with the last option.