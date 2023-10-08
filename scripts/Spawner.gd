extends Node2D

signal enemy_died(enemy: Enemy);

@export var _player: Node2D;
@export var _spawn_delay: float;
@export var _easy_enemy: PackedScene;
@export var _hard_enemy: PackedScene;
@export var _boss_enemy: PackedScene;

var _secondsUntilNextSpawn: float;
var enemies: Array[Enemy] = [];	

func _ready():
	set_process(false);

func _process(delta):

	_secondsUntilNextSpawn -= delta;

	if (_secondsUntilNextSpawn > 0):
		return;

	var enemy_template = pick_enemy_to_spawn();
	var enemy_count = pick_enemy_count();

	print("Spawning enemies: " + str(enemy_count) + " x " + enemy_template.resource_path);

	var spawned_enemies: Array[Enemy] = [];
	for i in enemy_count:
		var enemy = spawn_enemy(enemy_template);		
		spawned_enemies.append(enemy);

	enemies.append_array(spawned_enemies);

	_secondsUntilNextSpawn = _spawn_delay;


func kill_all_enemies():
	for enemy in enemies:
		enemy.get_parent().remove_child(enemy);
		enemy.free();
	enemies.clear();	

func randf_between(min_val, max_val):
	return min_val + randf() * (max_val - min_val);
	
func pick_enemy_to_spawn() -> PackedScene:
	# TODO
	return _easy_enemy;

func pick_enemy_count() -> int:
	# TODO
	return 1;

func spawn_enemy(enemy_template: PackedScene) -> Enemy:
	var enemy = enemy_template.instantiate() as Enemy;
	if (!enemy):
		print("Invalid enemy: " + enemy_template.name)
		return null;

	get_tree().get_root().add_child(enemy);

	enemy.tree_exited.connect(func(): enemy_died.emit(enemy));

	enemy._target = _player;
	enemy.global_position = global_position;
	enemy.global_position.x += randf_between(-200, 200);
	enemy.global_position.y += randf_between(-2000, 200);
	return enemy;

func _on_body_entered(body):
	if (body.collision_layer != 1):
		return;
	set_process(true);


func _on_body_exited(body):
	if (body.collision_layer != 1):
		return;
	set_process(false);	
