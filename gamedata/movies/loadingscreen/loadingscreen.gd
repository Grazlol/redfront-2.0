extends Control


# Called when the node enters the scene tree for the first time.
func play_animation():
	if vario.fetch("LOADING_SCREEN_ENABLED?") == true:
		get_node("synchronizer").play("begin")
	else:
		get_node("blanchSynchronizer").start()


func _on_synchronizer_animation_finished(anim_name: StringName) -> void:
	vario.SYNCHRONIZITÄT.emit()


func _on_blanch_synchronizer_timeout() -> void:
	vario.SYNCHRONIZITÄT.emit()
