extends Node2D

@onready var message_label: Label = $PanelContainer/MarginContainer/VBoxContainer/Label
@onready var ok_button: Button = $PanelContainer/MarginContainer/VBoxContainer/Button

func show_message(text: String):
	message_label.text = text
	visible = true
	# Tambahkan efek visual (opsional)
	scale = Vector2(0.8, 0.8)
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1, 1), 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)

func _on_button_pressed():
	visible = false

#func _ready():
	#ok_button.pressed.connect(_on_button_pressed)
	# Atur ukuran dan posisi (opsional)
	#position = get_viewport_rect().size / 2 - (size / 2)
