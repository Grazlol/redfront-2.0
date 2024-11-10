extends Control

@onready var stamina: float
@onready var staminabar = get_node("staminabar")
@onready var anim = $animation

@onready var staminabarrevealed: bool
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	vario.add("PLAYER_HUD_STAMINABAR", Vector2(0,0))
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	stamina = vario.fetch_per("PLAYER_INFO_STAMINA")
	
	staminabar.global_position = vario.fetch("PLAYER_HUD_STAMINABAR")
	
	staminabar.scale.x = 0.1 * vario.fetch_per("PLAYER_INFO_STAMINA")
	
	if stamina < 9 and staminabarrevealed == false:
		anim.play("staminabar")
		staminabarrevealed = true
	elif staminabarrevealed == true and stamina > 9:
		anim.play_backwards("staminabar")
		staminabarrevealed = false
	if stamina < 5:
		get_node("staminabar/Line2").visible = true
	else:
		get_node("staminabar/Line2").visible = false
	
	if Input.is_action_just_released("inventory"):
		self.queue_free()
