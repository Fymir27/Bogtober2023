extends Node2D

signal boss_defeated();

@export var _player: Player;
@export var _game_time: GameTime;
@export var _spawn_delay: float;
@export var _easy_enemy: PackedScene;
@export var _hard_enemy: PackedScene;
@export var _boss_enemy: PackedScene;

var _secondsUntilNextSpawn: float;
var enemies: Array[Enemy] = [];
var time_active: float = 0;
var boss_spawned: bool = false;

var running_id = 0;

func _ready():
	set_process(false);

func _process(delta):

	time_active += delta;
	_secondsUntilNextSpawn -= delta;

	if (_secondsUntilNextSpawn > 0):
		return;

	var enemy_template = pick_enemy_to_spawn();
	var enemy_count = pick_enemy_count(enemy_template);

	print("Spawning enemies: " + str(enemy_count) + " x " + enemy_template.resource_path);

	var spawned_enemies: Array[Enemy] = [];
	for i in enemy_count:
		var enemy = spawn_enemy(enemy_template);		
		spawned_enemies.append(enemy);

	enemies.append_array(spawned_enemies);

	_secondsUntilNextSpawn = _spawn_delay;

func disable_all_enemies():
	set_process(false);
	for enemy in enemies:
		if (enemy == null):
			continue;
		enemy.constant_force = Vector2();
		enemy.set_process(false);
		enemy.set_physics_process(false);		

func kill_all_enemies():
	for enemy in enemies:
		if (enemy == null):
			continue;
		enemy.get_parent().remove_child(enemy);
		enemy.free();
	enemies.clear();	

func randf_between(min_val, max_val):
	return min_val + randf() * (max_val - min_val);
	
func pick_enemy_to_spawn() -> PackedScene:
	
	if (time_active > 59 && !boss_spawned):
		boss_spawned = true;
		return _boss_enemy;

	var chance_for_hard = min(0.95, _game_time.total_seconds_elapsed / 120);
	if (randf() < chance_for_hard):
		return _hard_enemy

	return _easy_enemy;

func pick_enemy_count(template: PackedScene) -> int:	
	var unmod_count = _game_time.total_seconds_elapsed / 15;
	if (template == _boss_enemy):
		return 1;
	if (template == _hard_enemy):
		return ceili(unmod_count / 3);
	return ceili(unmod_count);


func spawn_enemy(enemy_template: PackedScene) -> Enemy:
	var enemy = enemy_template.instantiate() as Enemy;
	if (!enemy):
		print("Invalid enemy: " + enemy_template.name)
		return null;

	enemy.name = enemy.name + str(running_id)
	running_id += 1;

	add_child(enemy);
	enemies.append(enemy);

	if (enemy_template == _boss_enemy):
		enemy.tree_exited.connect(func(): boss_defeated.emit());

	enemy._target = _player;
	var random_angle = randf_between(0, 2 * PI);	

	var view = get_viewport();
	var camera = view.get_camera_2d();		
	var visible_size_world = view.get_visible_rect().size / camera.zoom;
	var diagonal_length = (visible_size_world / 2).length();
	var spawn_offset = Vector2.from_angle(random_angle) * (diagonal_length + 100)	
	enemy.global_position = camera.get_screen_center_position() + spawn_offset;
	return enemy;

func _on_body_entered(body):
	if (body.collision_layer != 1):
		return;
	set_process(true);


func _on_body_exited(body):
	if (body.collision_layer != 1):
		return;
	set_process(false);	
