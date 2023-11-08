extends Button


func _ready():
	pressed.connect(func(): get_tree().change_scene_to_file("main.tscn"))
