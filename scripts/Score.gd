extends Label

var score = 0;

func _ready():
    update_score();

func _on_spawner_enemy_died(_enemy: Enemy):
    score += 1;
    update_score();

func update_score():
    text = str(score);
