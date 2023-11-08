extends Sprite2D

@export var _variations: Array[Texture]


func _ready():
	var r = randi() % _variations.size()
	texture = _variations[r]
