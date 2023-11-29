extends Node

signal restart_scene
signal game_over

@export var ui: UI
@export var player: Player
@export var biomes: Array[Spawner]

var _active_biome: Spawner


func _process(_delta):
	if _active_biome:
		ui.boss_progress.value = _active_biome.time_active


func quit():
	get_tree().quit()


func retry():
	restart_scene.emit()
	get_tree().reload_current_scene()


func pause():
	player.set_process(false)
	player.set_physics_process(false)
	ui.game_time.set_process(false)
	for biome in biomes:
		biome.disable_all_enemies()


func resume():
	player.set_process(true)
	player.set_physics_process(true)
	ui.game_time.set_process(true)
	for biome in biomes:
		biome.enable_all_enemies()


func _on_player_died():
	pause()
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
