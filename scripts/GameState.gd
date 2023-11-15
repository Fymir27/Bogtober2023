extends Node

signal restart_scene

@export var _game_over_panel: Control
@export var _game_time: GameTime
@export var _boss_progress: Range

var _active_biome: Spawner


func _ready():
	_game_over_panel.hide()


func _process(_delta):
	_boss_progress.value = _active_biome.time_active


func quit():
	get_tree().quit()


func retry():
	restart_scene.emit()
	get_tree().reload_current_scene()


func _on_player_died():
	_game_time.set_process(false)
	_game_over_panel.show()


func player_entered_biome(biome: Spawner):
	print("Active biome: " + biome.name)

	if _active_biome != null:
		_active_biome.set_process(false)

	if biome.is_boss_defeated:
		_boss_progress.hide()
	else:
		_boss_progress.max_value = biome.boss_spawns_after_seconds
		_boss_progress.show()

	_active_biome = biome
	_active_biome.set_process(true)


func boss_defeated():
	if _active_biome.is_boss_defeated:
		_boss_progress.hide()
