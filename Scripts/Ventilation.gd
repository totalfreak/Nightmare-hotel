extends Area2D

var enter_pos
var exit_pos

var canToggleVentilation = false

var interact_text

func _ready():
	enter_pos = $EnterPosition
	exit_pos = $ExitPosition
	pass

func _process(delta):
	# If interact is pressed, and is standing on a vent
	if Input.is_action_just_pressed("ui_down") and canToggleVentilation:
		$AudioStreamPlayer2D.play()
		# Checking if player is inside or outside vent
		Globals.enter_ventilation(enter_pos.global_position)
		get_parent().get_parent().get_parent().get_node("Ventilation/Vent Collider").set_collision_layer_bit(3, true)
		get_parent().get_parent().get_parent().get_node("Ventilation/Vent Collider").set_collision_mask_bit(3, true)
		get_parent().get_parent().get_node("TileMap").z_index = -4
		if interact_text:
				Globals.remove_interact_text(self)
		if not interact_text:
				if not Globals.player.inside_vent:
					Globals.apply_interact_text(self, "ui_down")
				else:
					Globals.apply_interact_text(self, "ui_up")
	
	if Input.is_action_just_pressed("ui_up") and canToggleVentilation:
		if Globals.player.inside_vent:
			$AudioStreamPlayer2D.play()
			Globals.exit_ventilation(exit_pos.global_position)
			get_parent().get_parent().get_parent().get_node("Ventilation/Vent Collider").set_collision_layer_bit(3, false)
			get_parent().get_parent().get_parent().get_node("Ventilation/Vent Collider").set_collision_mask_bit(3, false)
			get_parent().get_parent().get_node("TileMap").z_index = -10
			if interact_text:
				Globals.remove_interact_text(self)
			if not interact_text:
				if not Globals.player.inside_vent:
					Globals.apply_interact_text(self, "ui_down")
				else:
					Globals.apply_interact_text(self, "ui_up")

# Vent area2D entered
func _on_Vent_Area2D_body_entered(body):
	if body == Globals.player and not canToggleVentilation:
		Globals.apply_outline(self.get_parent())
		if not interact_text:
				if not Globals.player.inside_vent:
					Globals.apply_interact_text(self, "ui_down")
				else:
					Globals.apply_interact_text(self, "ui_up")
		canToggleVentilation = true

# Vent area2D exitted
func _on_Vent_Area2D_body_exited(body):
	if body == Globals.player and canToggleVentilation:
		Globals.remove_outline(self.get_parent())
		canToggleVentilation = false
		if interact_text:
			Globals.remove_interact_text(self)
