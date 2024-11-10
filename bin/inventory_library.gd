extends Node

@export var previewofitemin3D: ViewportTexture
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	vario.add("3D_ITEM_PREVIEW", previewofitemin3D)
	#vario.add("ITEM_TRANSPORT_HOLDER_ID",

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	for element in get_node("items").get_children():
		element.preview_3D.global_rotation_degrees.y += 0.25
	


func _on_controller_item_add(item_id: String) -> void:
	for element in get_node("items").get_children():
		if element.itemID == item_id:
			element.add_item()

func _on_controller_item_del(item_id: String) -> void:
	for element in get_node("items").get_children():
		if element.itemID == item_id:
			element.pop_item()
