class_name SpawnSettings extends Resource

@export var max_enemies_per_tick: int
@export var max_enemies_per_biome: int
@export var enemy_scaling: Curve
@export var max_scaling_at_seconds: int


func sample_difficulty(offset: float) -> float:
	return enemy_scaling.sample(clampf(offset, 0, 1))
