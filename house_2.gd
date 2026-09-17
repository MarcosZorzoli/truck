extends Node3D
signal destroy

func _on_area_3d_body_entered(body) -> void:
	if body.is_in_group("npc"):
		emit_signal("destroy")
