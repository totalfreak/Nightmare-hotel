extends Control

export(String, FILE, "*.tscn") var StartScene

func _on_StartGame_pressed():
	get_tree().change_scene(StartScene)


func _on_ExitGame_pressed():
	get_tree().quit()
