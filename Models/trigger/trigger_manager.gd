extends Node3D







func _on_timer_timeout():
	var bodies = $trigger.get_overlapping_bodies()
	if bodies.size() > 1:
		get_tree().reload_current_scene() # TODO: game over and stuff
