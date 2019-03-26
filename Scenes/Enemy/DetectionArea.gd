extends Area2D

func _physics_process(delta):
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body == Globals.player and Globals.player.entered_light and not Globals.player.inside_vent:
			get_parent().chasing = true