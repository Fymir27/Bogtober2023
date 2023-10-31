extends Node

signal restart_scene;

@export var _game_over_panel: Control;

func _ready():
	_game_over_panel.hide();

func quit():
	get_tree().quit();

func retry():
	Engine.time_scale = 1;
	restart_scene.emit();
	get_tree().reload_current_scene();


func _on_player_died():
	Engine.time_scale = 0;
	_game_over_panel.show();
