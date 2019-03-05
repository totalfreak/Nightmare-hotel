extends Area2D

var enter_pos
var exit_pos

var canToggleVentilation = false

func _ready():
	enter_pos = $EnterPosition
	exit_pos = $ExitPosition
	pass

func _process(delta):
	# If interact is pressed, and is standing on a vent
	if Input.is_action_just_pressed("interact") and canToggleVentilation:
		# Checking if player is inside or outside vent
		if Globals.player.inside_vent:
			Globals.exit_ventilation(exit_pos.global_position)
		else:
			Globals.enter_ventilation(enter_pos.global_position)

# Vent area2D entered
func _on_Vent_Area2D_body_entered(body):
	if body == Globals.player and not canToggleVentilation:
		canToggleVentilation = true

# Vent area2D exitted
func _on_Vent_Area2D_body_exited(body):
	if body == Globals.player and canToggleVentilation:
		canToggleVentilation = false
