extends Control

@onready var anim = $animated
@onready var state: String
@onready var menuready = false

@onready var inv_win = $inventory
@onready var hlt_win = $health
@onready var obj_win = $objective
@onready var map_win = $map

@onready var inventory_3D_preview_screen = $inventory/actual_elements/item_info/item_3D_preview

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	vario.GAME_PAUSED = true
	anim.play("enter")
	await anim.animation_finished
	anim.play("inventory_enter")
	inventory_3D_preview_screen.texture = vario.fetch("3D_ITEM_PREVIEW")
	vario.add("MINIMAP_MODE", true)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_released("inventory") and menuready == true:
		exit()
	menuready = true
	
func _physics_process(delta: float) -> void:
	get_node("health/actual_elements/StatistiqueHexagon/persona_spinner").global_rotation_degrees += 5
	get_node("health/actual_elements/StatistiqueHexagon/persona_spinner/GPUParticles2D").position.x = randf_range(-100,100)
	
func exit() -> void:
	anim.play("exit")
	await anim.animation_finished
	vario.add("MINIMAP_MODE", false)
	vario.GAME_PAUSED = false
	vario.insert_ui("res://bin/player hud.tscn")
	self.queue_free()


func _on_inventory_button_pressed() -> void:
	if state == "inventory":
		get_node("header/inventory_button").button_pressed = true
	else:
		state = "inventory"
		inv_win.visible = true
		inv_win.mouse_filter = MOUSE_FILTER_STOP
		anim.play("inventory_enter")
		get_node("beeper").play()
		
		hlt_win.visible = false
		hlt_win.mouse_filter = MOUSE_FILTER_IGNORE
		
		obj_win.visible = false
		obj_win.mouse_filter = MOUSE_FILTER_IGNORE
		
		map_win.visible = false
		map_win.mouse_filter = MOUSE_FILTER_IGNORE
		
	get_node("header/quest_button").button_pressed = false
	get_node("header/health_button").button_pressed = false
	get_node("header/map_button").button_pressed = false


func _on_health_button_pressed() -> void:
	if state == "health":
		get_node("header/health_button").button_pressed = true
	else:
		state = "health"
		hlt_win.visible = true
		hlt_win.mouse_filter = MOUSE_FILTER_STOP
		get_node("beeper").play()
		
		inv_win.visible = false
		inv_win.mouse_filter = MOUSE_FILTER_IGNORE
		
		obj_win.visible = false
		obj_win.mouse_filter = MOUSE_FILTER_IGNORE
		
		map_win.visible = false
		map_win.mouse_filter = MOUSE_FILTER_IGNORE
		
	get_node("header/inventory_button").button_pressed = false
	get_node("header/quest_button").button_pressed = false
	get_node("header/map_button").button_pressed = false


func _on_quest_button_pressed() -> void:
	if state == "quest":
		get_node("header/quest_button").button_pressed = true
	else:
		state = "quest"
		obj_win.visible = true
		obj_win.mouse_filter = MOUSE_FILTER_STOP
		get_node("beeper").play()
		
		
		inv_win.visible = false
		inv_win.mouse_filter = MOUSE_FILTER_IGNORE
		
		hlt_win.visible = false
		hlt_win.mouse_filter = MOUSE_FILTER_IGNORE
		
		map_win.visible = false
		map_win.mouse_filter = MOUSE_FILTER_IGNORE
		
	get_node("header/inventory_button").button_pressed = false
	get_node("header/health_button").button_pressed = false
	get_node("header/map_button").button_pressed = false


func _on_map_button_pressed() -> void:
	if state == "map":
		get_node("header/map_button").button_pressed = true
	else:
		state = "map"
		map_win.visible = true
		map_win.mouse_filter = MOUSE_FILTER_STOP
		get_node("beeper").play()
		anim.play("enter_automap")
		
		inv_win.visible = false
		inv_win.mouse_filter = MOUSE_FILTER_IGNORE
		
		hlt_win.visible = false
		hlt_win.mouse_filter = MOUSE_FILTER_IGNORE
		
		obj_win.visible = false
		obj_win.mouse_filter = MOUSE_FILTER_IGNORE
		
	get_node("header/inventory_button").button_pressed = false
	get_node("header/health_button").button_pressed = false
	get_node("header/quest_button").button_pressed = false
