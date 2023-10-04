class_name GroupOfEnemies extends Resource

@export var enemy: PackedScene;
@export var count: int;

func spawn() -> Array[Enemy]:
    var enemies: Array[Enemy] = [];
    for i in range(count):
        var instance = enemy.instantiate() as Enemy;
        if (!instance):
            printerr("Invalid enemy group: " + str(enemy));
            break;
        enemies.append(instance);
    return enemies;
                
