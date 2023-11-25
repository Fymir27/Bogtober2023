extends Node

signal restart_scene
signal game_over

@export var ui: UI

var _active_biome: Spawner


func _process(_delta):
	if _active_biome:
		ui.boss_progress.value = _active_biome.time_active


func quit():
	get_tree().quit()


func retry():
	restart_scene.emit()
	get_tree().reload_current_scene()


func _on_player_died():
	ui.game_time.set_process(false)
	game_over.emit()


func player_entered_biome(biome: Spawner):
	print("Active biome: " + biome.name)

	if _active_biome != null:
		_active_biome.set_process(false)

	if biome.is_boss_defeated:
		ui.boss_progress.hide()
	else:
		ui.boss_progress.max_value = biome.boss_spawns_after_seconds
		ui.boss_progress.show()

	_active_biome = biome
	_active_biome.set_process(true)


func boss_defeated():
	if _active_biome.is_boss_defeated:
		ui.boss_progress.hide()
