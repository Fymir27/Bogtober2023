extends Camera2D

@export var ui: Control;

func _process(_delta):
    ui.global_position = get_screen_center_position();
