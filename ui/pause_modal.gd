extends Panel

signal quit_requested
signal resume_requested


func _on_quit_pressed():
	quit_requested.emit()


func _on_resume_pressed():
	resume_requested.emit()
