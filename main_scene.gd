extends Node2D

# Variabel Game
var points: int = 0
var total_click: int = 0
var shape_level: int = 1
var click_power_from_level: int = 1
var click_power_from_power_up: int = 0
var click_power_from_boost: int = 0

# Power Up
var power_up_level: int = 0

# Auto Click
var auto_click_points: int = 0
var auto_click_interval: float = 5.0

# Variabel untuk Level Auto Click
var auto_click_level: int = 0
var auto_click_multiplier: int = 0  # Jumlah klik per interval

# Boost Power
var boost_power_active: bool = false
var boost_power_duration: float = 10.0

# Referensi UI
@onready var points_label: Label = $CanvasLayer/PanelContainer/MarginContainer/VBoxContainer/PointsLabel
@onready var total_click_label: Label = $CanvasLayer/PanelContainer/MarginContainer/VBoxContainer/TotalClickLabel
@onready var click_power_label: Label = $CanvasLayer/PanelContainer/MarginContainer/VBoxContainer/ClickPowerLabel
@onready var shape_sprite: Sprite2D = $UI/Shape/Shape2D 
@onready var upgrade_cost_label: Label = $CanvasLayer/TabContainer/UPGRADE/PanelContainer2/MarginContainer/HBoxContainer/VBoxContainer/UpgradeCostLabel
@onready var level_click_detail: Label = $CanvasLayer/TabContainer/UPGRADE/PanelContainer2/MarginContainer/HBoxContainer/VBoxContainer/LevelClickDetail
@onready var power_up_cost_label: Label = $CanvasLayer/TabContainer/POWERUP/PanelContainer2/MarginContainer/HBoxContainer/VBoxContainer/PowerUpCostLabel
@onready var power_up_detail: Label = $CanvasLayer/TabContainer/POWERUP/PanelContainer2/MarginContainer/HBoxContainer/VBoxContainer/PowerUpDetail
@onready var auto_click_detail: Label = $CanvasLayer/TabContainer/AUTOCLICK/PanelContainer2/MarginContainer/HBoxContainer/VBoxContainer/AutoClickDetail
@onready var auto_click_cost_label: Label = $CanvasLayer/TabContainer/AUTOCLICK/PanelContainer2/MarginContainer/HBoxContainer/VBoxContainer/AutoClickCostLabel
@onready var boost_detail: Label = $CanvasLayer/TabContainer/BOOSTER/PanelContainer2/MarginContainer/HBoxContainer/VBoxContainer/BoostDetail
@onready var boost_cost_label: Label = $CanvasLayer/TabContainer/BOOSTER/PanelContainer2/MarginContainer/HBoxContainer/VBoxContainer/BoostCostLabel
@onready var boost_button: Button = $CanvasLayer/TabContainer/BOOSTER/PanelContainer2/MarginContainer/HBoxContainer/ActivateBoost
@onready var booster_timer = $BoosterTimer
@onready var bounce_animation_player: AnimationPlayer = $UI/Shape/Shape2D/BounceAnimationPlayer
@onready var click_from_upgrade_detail: Label = $CanvasLayer/TabContainer/DETAILS/MarginContainer/VBoxContainer/UpgradeClickDetail
@onready var click_from_power_up_detail: Label = $CanvasLayer/TabContainer/DETAILS/MarginContainer/VBoxContainer/PowerUpClickDetail
@onready var click_from_auto_click_detail: Label = $CanvasLayer/TabContainer/DETAILS/MarginContainer/VBoxContainer/AutoClickClickDetail
@onready var click_from_booster_detail: Label = $CanvasLayer/TabContainer/DETAILS/MarginContainer/VBoxContainer/BoosterClickDetail

#SHAPE LEVEL LABEL
@onready var update_upgrade_cost_button: Button = $CanvasLayer/TabContainer/UPGRADE/PanelContainer2/MarginContainer/HBoxContainer/UpgradeButton
@onready var shape_level_label: Label = $CanvasLayer/TabContainer/UPGRADE/PanelContainer2/MarginContainer/HBoxContainer/VBoxContainer2/ShapeLevelLabel

#POWER UP LABEL
@onready var update_powerup_cost_button: Button = $CanvasLayer/TabContainer/POWERUP/PanelContainer2/MarginContainer/HBoxContainer/PowerUpButton
@onready var powerup_level_label: Label = $CanvasLayer/TabContainer/POWERUP/PanelContainer2/MarginContainer/HBoxContainer/VBoxContainer2/PowerUpLevel

#AUTO CLICK LABEL
@onready var update_autoclick_cost_button: Button = $CanvasLayer/TabContainer/AUTOCLICK/PanelContainer2/MarginContainer/HBoxContainer/AutoClickButton
@onready var autoclick_level_label: Label = $CanvasLayer/TabContainer/AUTOCLICK/PanelContainer2/MarginContainer/HBoxContainer/VBoxContainer2/AutoClickLevelLabel

#BOOST LABEL
@onready var update_booster_button: Button = $CanvasLayer/TabContainer/BOOSTER/PanelContainer2/MarginContainer/HBoxContainer/ActivateBoost

# Array path gambar shape
var shapes: Array = [
	"res://assets/point.png",    # Level 1
	"res://assets/line.png",     # Level 2
	"res://assets/Shape-1.png",  # Level 3
	"res://assets/Shape-2.png",  # Level 4
	"res://assets/Shape-3.png",
	"res://assets/Shape-4.png",
	"res://assets/Shape-5.png",
	"res://assets/Shape-6.png",
	"res://assets/Shape-7.png",
	"res://assets/Shape-8.png",
	"res://assets/Shape-9.png",
	"res://assets/Shape-10.png",
	"res://assets/Shape-11.png",
	"res://assets/Shape-12.png",
	"res://assets/Shape-13.png",
	"res://assets/Shape-14.png",
	"res://assets/Shape-15.png",
	"res://assets/Shape-16.png",
	"res://assets/Shape-17.png",
	"res://assets/Shape-18.png",
	"res://assets/Shape-19.png",
	"res://assets/Shape-20.png",
	"res://assets/Shape-21.png",
	"res://assets/Shape-22.png",
	"res://assets/Shape-23.png",
	"res://assets/Shape-24.png",
	"res://assets/Shape-25.png",
	"res://assets/Shape-26.png",
	"res://assets/Shape-27.png",
	"res://assets/Shape-28.png",
	"res://assets/Shape-29.png", # Level 29
	"res://assets/circle.png"    # Level 30
]

# Fungsi untuk mengupdate UI
func update_ui():
	points_label.text = "Points: %d" % points
	total_click_label.text = "Total Click: %d" % total_click
	click_power_label.text = "Click Power: %d" % (click_power_from_level + click_power_from_power_up + click_power_from_boost)
	upgrade_cost_label.text = "Upgrade Cost: %d" % calculate_upgrade_cost(shape_level)
	boost_cost_label.text = "Boost Cost: %d" % 200  # Biaya Boost
	shape_level_label.text = "Lv.%d" % shape_level
	level_click_detail.text = "Increase click power by %d" % click_power_from_level
	power_up_detail.text = "Increase click power by %d Click" % [click_power_from_power_up]
	update_upgrade_cost_button.text = "+%d\nCost: %d Poin" % [calculate_click_power_from_level(shape_level+1) - calculate_click_power_from_level(shape_level), calculate_upgrade_cost(shape_level)]
	
	var power_up_cost = 50 + (power_up_level * 10)
	update_powerup_cost_button.text = "+1\nCost: %d Poin" % power_up_cost
	powerup_level_label.text = "Lv.%d" % power_up_level
	
	var auto_click_interval = max(1, 10 - auto_click_level) if auto_click_level <= 10 else 1
	
	# AUTO CLICK UPDATE
	var n = auto_click_level + 5
	var a = 0
	var b = 1
	for i in range(2, n + 1):
		var c = a + b
		a = b
		b = c
	var auto_click_cost = b * 15
	
	# Hitung CPS saat ini
	var current_cps = calculate_cps(auto_click_level)
	var next_cps = calculate_cps(auto_click_level + 1)
	var cps_increase = next_cps - current_cps
	
	# Format angka desimal (2 digit di belakang koma)
	var formatted_current = "%.2f" % current_cps
	var formatted_increase = "%.2f" % cps_increase
	
	# Update tombol upgrade
	update_autoclick_cost_button.text = "+%s Click/s\nCost: %d Poin" % [
		formatted_increase,
		auto_click_cost
	]
	
	# Update detail auto click
	auto_click_detail.text = "Increase auto click by %s → %s Click/s" % [
		formatted_current,
		"%.2f" % next_cps
	]
	auto_click_cost_label.text = "Auto Click Cost: %d" % auto_click_cost
	
	autoclick_level_label.text = "Lv.%d" % auto_click_level

		
	# Update label biaya
	auto_click_cost_label.text = "Auto Click Cost: %d" % auto_click_cost
	click_from_upgrade_detail.text = "Click from Upgrade: %d Click (Level %d)" % [click_power_from_level, shape_level]
	click_from_power_up_detail.text = "Click from Power Up: +%d Click\n• Normal Power Up : +%d Click (Level %d)\n• Super Power Up : + 0 Click (Level 0)" % [click_power_from_power_up, click_power_from_power_up, power_up_level]
	click_from_auto_click_detail.text = "Click from Auto Click : %d  Click/ %d Second\n• Normal Auto Click : %d Click/ %d Second (Level %d)\n• Super Auto Click : 0 Click/ 0 Second (Level 0)" % [auto_click_multiplier, auto_click_interval, auto_click_multiplier, auto_click_interval, auto_click_level]
	click_from_booster_detail.text = "Click from Booster : +%d Click" % click_power_from_boost
	if boost_power_active:
		var boost_time_left = int(booster_timer.time_left)
		click_from_booster_detail.text += " (for %d Second)" % boost_time_left
	boost_button.disabled = boost_power_active
	
	# Update biaya Power Up
	power_up_cost_label.text = "Power Up Cost: %d" % power_up_cost

	# Update biaya Auto Click
	auto_click_cost_label.text = "Auto Click Cost: %d" % auto_click_cost

func calculate_cps(level: int) -> float:
	var multiplier = 1
	var interval = max(1.0, 10.0 - level)
	
	if level > 10:
		multiplier = pow(2, level - 10)
		interval = 1.0
	
	return multiplier / interval

func _on_booster_timer_timeout():
	# Ketika timer selesai, nonaktifkan boost
	boost_power_active = false
	boost_detail.text = "Boost: +%d Click" % click_power_from_boost
	update_booster_button.text = "ACTIVATE BOOSTER\nCost: 500 Poin"
	boost_button.disabled = false
	click_power_from_boost = 0
	update_ui()

func start_boost():
	# Aktifkan boost dan mulai timer
	boost_power_active = true
	booster_timer.start()
	update_boost_detail()

func update_boost_detail():
	# Update teks boost detail dengan waktu tersisa
	if boost_power_active:
		var boost_time_left = int(booster_timer.time_left)
		boost_detail.text = "Boost: +%d Click (%d s remaining)" % [click_power_from_boost, boost_time_left]
		update_booster_button.text = "BOOSTER\nACTIVE"
	else:
		boost_detail.text = "Boost: +%d Click" % click_power_from_boost

func _process(delta):
	# Update teks boost detail setiap frame jika boost aktif
	if boost_power_active:
		update_boost_detail()
		update_ui()

# Fungsi utilitas
func calculate_upgrade_cost(level: int) -> int:
	return int(10 * pow(1.75, level - 1))

func calculate_click_power_from_level(level: int) -> int:
	return (level * (level + 1)) / 2

func calculate_autoclick_power_from_level(level: int) -> Dictionary:
	# Menghasilkan dictionary berisi:
	var result = {
		"multiplier": 1,
		"interval": max(1.0, 10.0 - level)  # Minimum interval 1 detik
		}
	if level <= 10:
		# Sebelum level 10: 1 klik per interval, interval berkurang
		result.multiplier = 1
		result.interval = max(1.0, 10.0 - level)
	else:
		# Setelah level 10: multiplier meningkat eksponensial, interval tetap 1 detik
		result.multiplier = pow(2, level - 10)
		result.interval = 1.0
	return result

#CLICK SHAPE
func _on_shape_input_event(viewport: Node, event: InputEvent, shape_idx: int):
	if event is InputEventMouseButton and event.pressed:
		var total_click_power = click_power_from_level + click_power_from_power_up + click_power_from_boost
		points += total_click_power
		total_click += 1
		bounce_animation_player.play("bounce")  # Jalankan animasi bounce
		update_ui()

#UPGRADE LEVEL
func _on_upgrade_button_pressed():
	var upgrade_cost = calculate_upgrade_cost(shape_level)
	if points >= upgrade_cost:
		points -= upgrade_cost
		shape_level += 1
		click_power_from_level = calculate_click_power_from_level(shape_level)
		# Update gambar shape
		if shape_level <= shapes.size():
			var texture_path = shapes[shape_level - 1]  # Ambil path gambar dari array
			var texture = load(texture_path)  # Muat texture dari path
			if texture:
				$UI/Shape/Shape2D.texture = texture  # Set texture ke Sprite2D
			else:
				print("Gagal memuat texture dari path:", texture_path)
		else:
			print("Level shape melebihi jumlah gambar yang tersedia!")
		
		update_ui()
	else:
		print("Poin tidak cukup untuk upgrade!")

# POWER UP
func _on_power_up_button_pressed():
	var power_up_cost = 50 + (power_up_level * 10)  # Biaya Power Up berdasarkan level
	if points >= power_up_cost:
		points -= power_up_cost
		click_power_from_power_up += 1  # Kekuatan klik tetap +1 per level
		power_up_level += 1  # Tingkatkan level Power Up
		update_ui()
	else:
		print("Poin tidak cukup untuk membeli Power Up!")

# AUTO CLICK
func _on_auto_click_button_pressed():
	var n = auto_click_level + 5  # Menyesuaikan skala biaya
	var a = 0
	var b = 1
	for i in range(2, n + 1):
		var c = a + b
		a = b
		b = c
	var auto_click_cost = b * 15  # Nilai Fibonacci ke-n

	if points >= auto_click_cost:
		points -= auto_click_cost
		auto_click_level += 1
		# Gunakan fungsi baru untuk menghitung power
		var auto_click_power = calculate_autoclick_power_from_level(auto_click_level)
		auto_click_multiplier = auto_click_power["multiplier"]
		auto_click_interval = auto_click_power["interval"]
		$AutoClickTimer.wait_time = auto_click_interval
		if not $AutoClickTimer.is_stopped():
			$AutoClickTimer.start()
			update_ui()
	else:
		print("Poin tidak cukup untuk membeli Auto Click!")

# Fungsi saat Auto Click Timer timeout
func _on_auto_click_timer_timeout():
	if auto_click_multiplier > 0:
		points += auto_click_multiplier  # Tambahkan poin berdasarkan jumlah klik per interval
		update_ui()

# BOOST
func _on_activate_boost_pressed():
	var boost_cost = 200
	if points >= boost_cost:
		points -= boost_cost
		click_power_from_boost = 500
		boost_power_active = true
		boost_button.disabled = true
		booster_timer.start(boost_power_duration)
		update_ui()
	else:
		print("Not enough points for Boost!")
