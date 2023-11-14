@tool
extends EditorScript

var material: PhysicsMaterial = preload("res://enemy_physics_material.tres")


func _run():
	var files = get_files_recursively("res://")
	for file in files:
		if !file.ends_with(".tscn"):
			continue
		var packed = load(file) as PackedScene
		var scene = packed.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
		var enemy = scene as Enemy
		if enemy == null:
			continue
		enemy.physics_material_override = material
		var result = packed.pack(enemy)
		if result == OK:
			var error = ResourceSaver.save(packed, file)
			if error != OK:
				push_error("An error occurred while saving the scene to disk.")
			else:
				print(enemy.name)


func get_files_recursively(root_path) -> PackedStringArray:
	var resource_dir = DirAccess.open(root_path)

	if resource_dir == null:
		return []
	if resource_dir.get_current_dir().contains("."):
		return []

	resource_dir.include_hidden = false
	resource_dir.include_navigational = false
	var files = resource_dir.get_files()
	var paths = add_path(root_path, files)
	for dir in resource_dir.get_directories():
		var more_paths = get_files_recursively(root_path + "/" + dir)
		paths.append_array(more_paths)
	return paths


func add_path(root_path: String, files: PackedStringArray) -> PackedStringArray:
	var paths = PackedStringArray()
	for file_name in files:
		paths.append(root_path + "/" + file_name)
	return paths
