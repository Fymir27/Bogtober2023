extends Node

signal restart_scene;

@export var _game_over_panel: Control;
@export var _game_time: GameTime;

func _ready():
	_game_over_panel.hide();

func quit():
	get_tree().quit();

func retry():
	restart_scene.emit();
	get_tree().reload_current_scene();


func _on_player_died():	
	_game_time.set_process(false);
	_game_over_panel.show();
