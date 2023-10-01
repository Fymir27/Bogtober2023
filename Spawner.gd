extends Node2D

@export var _player: Node2D;
@export var _spawnPoints: Array[Node2D];
@export var _waves: Array[PackedScene];
@export var _nextWaveIndex: int;
@export var _minSpawnDelay: int;
@export var _maxSpawnDelay: int;
@export var _secondsUntilNextSpawn: float;

func randf_between(min, max):
	return min + randf() * (max - min);

func _process(delta):
	_secondsUntilNextSpawn -= delta;
	if (_secondsUntilNextSpawn <= 0):
		spawn_next_wave()
		_secondsUntilNextSpawn = randf_between(_minSpawnDelay, _maxSpawnDelay);
		
		
func spawn_next_wave():
	print("Spawn wave " + str(_nextWaveIndex));
	var enemy_template = _waves[_nextWaveIndex];
	_nextWaveIndex = (_nextWaveIndex + 1) % _waves.size();	
	
	for marker in _spawnPoints:
		var point = marker.global_position;
		var enemy = enemy_template.instantiate() as Follow;
		enemy.global_position = point;
		enemy._target = _player;
		get_tree().root.add_child(enemy);
		
	
