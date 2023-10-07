extends Node2D

func _on_enemy_hit(body: Node2D):
	print("hit" + body.name);
	body.queue_free();	

func attack(point: Vector2):
	look_at(point);
	$WeaponSprite/WeaponAnimations.play("stab");
	
		
