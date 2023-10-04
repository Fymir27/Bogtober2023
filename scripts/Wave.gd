class_name Wave extends Resource

@export var groups: Array[GroupOfEnemies]
@export var spawn_time: int;

func spawn() -> Array[Enemy]:
    var enemies: Array[Enemy] = [];
    for group in groups:
        var enemies_of_group = group.spawn();
        enemies.append_array(enemies_of_group);

    return enemies;

