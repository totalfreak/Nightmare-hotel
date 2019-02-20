extends Light2D

var result

func _ready():
	set_physics_process(true)
	pass

func _physics_process(delta):
	result = Globals.check_if_player_in_light(global_position, texture_scale)
	if result:
		Globals.player.enter_light()
	else:
		Globals.player.leave_light()
	update()