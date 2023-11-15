extends Node2D

signal boss_defeated

@export var _player: Player
@export var _game_time: GameTime
@export var _spawn_delay: float
@export var _boss_spawns_after_seconds: float
@export var _boss_progress: ProgressBar
@export var _easy_enemy: PackedScene
@export var _hard_enemy: PackedScene
@export var _boss_enemy: PackedScene

var settings: SpawnSettings = preload("res://global/spawn_settings.tres")

var _secondsUntilNextSpawn: float
var enemies: Array[Enemy] = []
var time_active: float = 0
var boss_spawned: bool = false
var running_id = 0


func _ready():
	set_process(false)
	_boss_progress.max_value = _boss_spawns_after_seconds


func _process(delta):
	time_active += delta
	_secondsUntilNextSpawn -= delta

	_boss_progress.value = time_active

	if _secondsUntilNextSpawn > 0:
		return

	_secondsUntilNextSpawn = _spawn_delay

	clear_dead_enemies()

	var enemy_template = pick_enemy_to_spawn()
	var spawn_count = pick_enemy_count(enemy_template)

	var current_enemy_count = enemies.size()
	var new_count = current_enemy_count + spawn_count
	var is_boss = enemy_template == _boss_enemy
	if !is_boss && new_count > settings.max_enemies_per_biome:
		print(name + " is already full! (" + str(current_enemy_count) + ")")
		return

	var difficulty_sample_pos = _player.seconds_alive / settings.max_scaling_at_seconds
	var difficulty = settings.sample_difficulty(difficulty_sample_pos)

	print(
		"Spawning %d x %s @ difficulty %f" % [spawn_count, enemy_template.resource_name, difficulty]
	)

	for i in spawn_count:
		spawn_enemy(enemy_template, difficulty)


func disable_all_enemies():
	set_process(false)
	for enemy in enemies:
		if enemy == null:
			continue
		enemy.constant_force = Vector2()
		enemy.set_process(false)
		enemy.set_physics_process(false)


func kill_all_enemies():
	for enemy in enemies:
		if enemy == null:
			continue
		enemy.get_parent().remove_child(enemy)
		enemy.free()
	enemies.clear()


func randf_between(min_val, max_val):
	return min_val + randf() * (max_val - min_val)


func pick_enemy_to_spawn() -> PackedScene:
	if time_active >= _boss_spawns_after_seconds && !boss_spawned:
		boss_spawned = true
		return _boss_enemy

	var chance_for_hard = min(0.95, _game_time.total_seconds_elapsed / 120)
	if randf() < chance_for_hard:
		return _hard_enemy

	return _easy_enemy


func pick_enemy_count(template: PackedScene) -> int:
	var unmod_count = min(settings.max_enemies_per_tick, _game_time.total_seconds_elapsed / 15)
	if template == _boss_enemy:
		return 1
	if template == _hard_enemy:
		return ceili(unmod_count / 3)
	return ceili(unmod_count)


func spawn_enemy(enemy_template: PackedScene, difficulty: float) -> Enemy:
	var enemy = enemy_template.instantiate() as Enemy
	if !enemy:
		print("Invalid enemy: " + enemy_template.name)
		return null

	enemy.name = enemy.name + str(running_id)
	running_id += 1

	add_child(enemy)
	enemies.append(enemy)

	if enemy_template == _boss_enemy:
		enemy.tree_exited.connect(_on_boss_death)

	enemy._target = _player
	enemy.scale(difficulty)

	var spawn_position = Vector2()

	while spawn_position_invalid(spawn_position):
		spawn_position = get_random_spawn_position()

	enemy.global_position = spawn_position
	return enemy


func spawn_position_invalid(pos: Vector2) -> bool:
	return pos.x == 0 || abs(pos.x) > 4300 || pos.y == 0 || abs(pos.y) > 4300


func get_random_spawn_position() -> Vector2:
	var random_angle = randf_between(0, 2 * PI)
	var view = get_viewport()
	var camera = view.get_camera_2d()
	var visible_size_world = view.get_visible_rect().size / camera.zoom
	var diagonal_length = (visible_size_world / 2).length()
	var spawn_offset = Vector2.from_angle(random_angle) * (diagonal_length + 100)
	return camera.get_screen_center_position() + spawn_offset


func clear_dead_enemies():
	var alive: Array[Enemy] = []
	for enemy in enemies:
		if enemy != null:
			alive.append(enemy)
	enemies = alive


func _on_body_entered(body):
	if body.collision_layer != 1:
		return
	set_process(true)


func _on_body_exited(body):
	if body.collision_layer != 1:
		return
	#tes
	_boss_progress.value = 0
	set_process(false)


func _on_boss_death():
	_boss_progress.hide()
	boss_defeated.emit()
