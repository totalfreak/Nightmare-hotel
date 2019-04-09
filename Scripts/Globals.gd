extends Node2D


const GRAVITY = 20

#warning-ignore:unused_class_variable
var ray

var result

var ray_draw_list = []

var global_mouse

var player
var enemy

var hasKey = false

var current_scene
var old_scene

var interact_help = preload("res://Scenes/VFX/Interact Help.tscn")

func _ready():
	pass


#warning-ignore:unused_argument
func _physics_process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		_Change_Scene("res://Scenes/UI/StartMenu.tscn")
	global_mouse = get_global_mouse_position()


func check_if_player_in_light(position, length):
	var space_state = get_world_2d().direct_space_state
	
	#print((player.global_position - global_position).normalized())
	# Fire ray from the light position towards player position, at the player physics layer
	if player:
		result = space_state.intersect_ray(position, player.global_position, [], 1)
	
	#print(result)
	if result:
		if result.collider == player and position.distance_to(player.global_position)  / 30 < length:
			ray_draw_list.append([result.position, position])
			#update()
			#print(result.position.distance_to(position))
			return result


func _draw():
	var i = 0
	for ray in ray_draw_list:
		
		draw_line(ray[0], ray[1], Color(1, 0, 0))
		ray_draw_list.remove(i)
		i += 1
		

func enter_ventilation(enter_pos):
	# Disabling the normal collision and mask to only be physics with vent
	player.set_collision_layer_bit(0, false)
	player.set_collision_mask_bit(0, false)
	player.set_collision_layer_bit(3, true)
	player.set_collision_mask_bit(3, true)
	player.get_node("Camera2D").current = true
	player.global_position = enter_pos
	player.inside_vent = true
	player.get_node("Ventilation Light2D").visible = true
	#player.gravity_scale = 0

func exit_ventilation(exit_pos):
	# Applying the normal collision layer and mask
	player.set_collision_layer_bit(0, true)
	player.set_collision_mask_bit(0, true)
	player.set_collision_layer_bit(3, false)
	player.set_collision_mask_bit(3, false)
	player.global_position = exit_pos
	player.inside_vent = false
	player.get_node("Ventilation Light2D").visible = false
	#player.gravity_scale = 2.5


func door_entered(exitPos):
	player.global_position = exitPos


func _Change_Scene(var newScene):
	# Save the prior scene
	old_scene = get_tree().current_scene.get_filename()
	current_scene = newScene
#warning-ignore:return_value_discarded
	get_tree().change_scene(newScene)
	pass


func player_death():
	_Change_Scene("res://Scenes/UI/DeathScreen.tscn")

func win():
	_Change_Scene("res://Scenes/UI/StartMenu.tscn")

func apply_outline(var sprite):
	sprite.get_material().set_shader_param("shouldOutline", true)

func remove_outline(var sprite):
	sprite.get_material().set_shader_param("shouldOutline", false)

# Show help text
func apply_interact_text(node):
	#remove_interact_text(node)
	node.interact_text = interact_help.instance()
	node.interact_text.get_node("Container/Interact Text").text = InputMap.get_action_list("interact")[0].as_text()
	print(InputMap.get_action_list("interact")[0].as_text())
	get_tree().root.get_node("Main").add_child(node.interact_text)
	node.interact_text.set_owner(get_tree().root.get_node("Main"))
	node.interact_text.global_position = node.global_position + Vector2(0, -55)
	pass


func remove_interact_text(node):
	if node.interact_text:
		node.interact_text.queue_free()
		node.interact_text = null
	pass


func get_all_enemies(start_node):
	var result : Array
	for N in start_node.get_children():
		if N.get_child_count() > 0:
			if N.is_in_group("Enemy"):
				result.append(N)
			get_all_enemies(N)
		else:
			# Do something
			if N.is_in_group("Enemy"):
				result.append(N)
	return result
	
func did_move(pos_array, position, upper_limit = 3, change_thresh = 2):
	pos_array.push_front(position)
	if pos_array.size() > upper_limit:
		pos_array.pop_back()
		var temp_mean_x = 0
		var temp_mean_y = 0
		for pos in pos_array:
			temp_mean_x += abs(int(round(pos.x)))
			temp_mean_y += abs(int(round(pos.y)))
		var x = (temp_mean_x/upper_limit)
		var y = (temp_mean_y/upper_limit)
		if abs(int(round(x-position.x))) <= change_thresh && abs(int(round(y-position.y))) <= change_thresh:
			return false
		else:
			return true