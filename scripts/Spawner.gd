extends Node2D

@export var _player: Node2D;
@export var _timer: ProgressBar;
@export var _timerText: Label;
@export var _minRadius: float;
@export var _maxRadius: float;
@export var _waves: Array[Wave];
@export var _nextWaveIndex: int;
@export var _secondsUntilNextSpawn: float;

func randf_between(min_val, max_val):
	return min_val + randf() * (max_val - min_val);

func _process(delta):
	_secondsUntilNextSpawn -= delta;
	update_timer();

	if (_secondsUntilNextSpawn > 0):
		return;

	var wave = _waves[_nextWaveIndex];
	var enemies = wave.spawn();

	var wave_root = Node2D.new();
	wave_root.set_name("Wave " + str(_nextWaveIndex));
	get_tree().root.add_child(wave_root);

	for enemy in enemies:
		wave_root.add_child(enemy);
		enemy._target = _player;

	distribute_enemies(enemies);

	_nextWaveIndex = (_nextWaveIndex + 1) % _waves.size();
	_secondsUntilNextSpawn = _waves[_nextWaveIndex].spawn_time;

	
func distribute_enemies(enemies: Array[Enemy]):	
	var angle_offset = (2 * PI) / enemies.size();
	var i = 0;
	for enemy in enemies:
		var angle = angle_offset * i;
		i += 1;
		var distance_from_player = randf_between(_minRadius, _maxRadius);
		var position_from_player = Vector2(cos(angle), sin(angle)).normalized() * distance_from_player;		
		var final_position = _player.global_position + position_from_player;
		enemy.global_position = final_position;

func update_timer():
	_timer.max_value =  _waves[_nextWaveIndex].spawn_time;
	_timer.value = _secondsUntilNextSpawn;
	_timerText.text = str(ceil(_secondsUntilNextSpawn)) + "s"
