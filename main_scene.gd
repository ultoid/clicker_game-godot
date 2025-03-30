extends Node2D

# Variabel Game
var points: int = 0
var money: int = 0
var total_click: int = 0
var shape_level: int = 1
var click_power_from_level: int = 1
var click_power_from_power_up: int = 0
var click_power_from_boost: int = 0
var money_per_click: int = 100  # 100 money per click (base)

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
@onready var money_label: Label = $CanvasLayer/PanelContainer/MarginContainer/VBoxContainer/MoneyLabel
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
@onready var boost_button: Button = $CanvasLayer/TabContainer/BOOSTER/PanelContainer2/MarginContainer/HBoxContainer/MarginContainer/ActivateBoost
@onready var booster_timer = $BoosterTimer
@onready var auto_click_timer = $AutoClickTimer
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
@onready var update_booster_button: Button = $CanvasLayer/TabContainer/BOOSTER/PanelContainer2/MarginContainer/HBoxContainer/MarginContainer/ActivateBoost
@onready var click_sound: AudioStreamPlayer2D = $UI/Shape/Shape2D/ClickSoundPlay
@onready var levelup_sound: AudioStreamPlayer2D = $CanvasLayer/TabContainer/UPGRADE/PanelContainer2/MarginContainer/HBoxContainer/UpgradeButton/LevelUpSoundPlay

# warning dialog
var warning_dialog = preload("res://warningdialog.tscn")
var warning_dialog_instance: Node2D

# IMAGE PERUBAHAN SHAPE LEVEL
var shapes: Array = [
	"res://assets/point.png", "res://assets/line.png", "res://assets/Shape-1.png", "res://assets/Shape-2.png", "res://assets/Shape-3.png",
	"res://assets/Shape-4.png", "res://assets/Shape-5.png", "res://assets/Shape-6.png", "res://assets/Shape-7.png", "res://assets/Shape-8.png",
	"res://assets/Shape-9.png", "res://assets/Shape-10.png", "res://assets/Shape-11.png", "res://assets/Shape-12.png", "res://assets/Shape-13.png",
	"res://assets/Shape-14.png", "res://assets/Shape-15.png", "res://assets/Shape-16.png", "res://assets/Shape-17.png", "res://assets/Shape-18.png",
	"res://assets/Shape-19.png", "res://assets/Shape-20.png", "res://assets/Shape-21.png", "res://assets/Shape-22.png", "res://assets/Shape-23.png",
	"res://assets/Shape-24.png", "res://assets/Shape-25.png", "res://assets/Shape-26.png", "res://assets/Shape-27.png", "res://assets/Shape-28.png",
	"res://assets/Shape-29.png", "res://assets/circle.png"]

func _ready():
	update_ui()
	auto_click_timer.wait_time = auto_click_interval

	# Instantiate warning dialog
	warning_dialog_instance = warning_dialog.instantiate()
	add_child(warning_dialog_instance)
	warning_dialog_instance.visible = false  # Sembunyikan di awal

func show_warning(message: String):
	if warning_dialog_instance:
		warning_dialog_instance.show_message(message)
		# Posisikan di layer teratas
		move_child(warning_dialog_instance, get_child_count() - 1)
	else:
		push_error("WarningDialog instance not created!")

# FORMAT MONEY: 1000 → "1.00k", 1000000 → "1m"
func format_money(amount: int) -> String:
	if amount < 10000:
		var s = str(amount)
		var result = ""
		var len = s.length()
		
		# Add commas every 3 digits from right
		for i in range(len):
			result += s[i]
			if (len - i - 1) % 3 == 0 and i != len - 1:
				result += ","
		return result
	elif amount < 100000:
		# Format with comma and 2 decimal places (10,000 → 10.00k)
		var value = float(amount) / 1000.0
		return "%.2fk" % [round(value * 100) / 100]
	elif amount < 1000000:
		# Format as whole k (100,000 → 100k)
		return "%dk" % [amount / 1000]
	elif amount < 1000000000:
		# Format as m (1,230,000 → 1.23m)
		var value = float(amount) / 1000000.0
		return "%.2fm" % [round(value * 100) / 100]
	else:
		# Format as b (1,230,000,000 → 1.23b)
		var value = float(amount) / 1000000000.0
		return "%.2fb" % [round(value * 100) / 100]

# FUNGSI UPDATE UI
func update_ui():
	#UI ATAS
	points_label.text = "Points: %d" % points
	money_label.text = "Money: %s" % format_money(money)
	total_click_label.text = "Total Click: %d" % total_click
	click_power_label.text = "Click Power: %d" % (click_power_from_level + click_power_from_power_up + click_power_from_boost)
	
	#SHAPE LEVEL UPGRADE [TAB 1]
	shape_level_label.text = "Lv.%d" % shape_level
	level_click_detail.text = "Increase click power by %d" % click_power_from_level
	update_upgrade_cost_button.text =  "+%d Power\nCost: %s" % [calculate_click_power_from_level(shape_level + 1) - calculate_click_power_from_level(shape_level), format_money(calculate_upgrade_cost(shape_level))]
	
	#POWER UP [TAB 2]
	power_up_detail.text = "Increase money per click by +%d" % money_per_click
	update_powerup_cost_button.text = "+10 Money/Click\nCost: %s" % format_money(calculate_power_up_cost(power_up_level))
	powerup_level_label.text = "Lv.%d" % power_up_level
	
	#AUTO CLICK [TAB 3]
	var auto_click_info = get_auto_click_info(auto_click_level)
	var cost = calculate_auto_click_cost(auto_click_level)
	update_autoclick_cost_button.text = str(auto_click_info.formatted_increase) + " Click/s\nCost: " + format_money(cost)
	#update_autoclick_cost_button.text = "%s Click/s\nCost: %d" % [auto_click_info.formatted_increase, format_money(cost)]
	auto_click_detail.text = "Increase auto click by %s → %s Click/s" % [auto_click_info.formatted_current, "%.2f" % auto_click_info.next_cps]
	autoclick_level_label.text = "Lv.%d" % auto_click_level
	
	#BOOST [TAB 4]
	boost_cost_label.text = "Boost Cost: %s" % format_money(20000)

	#UPDATE STATISTIC [TAB 5]
	click_from_upgrade_detail.text = "Click from Upgrade: %d Click (Level %d)" % [click_power_from_level, shape_level]
	click_from_power_up_detail.text = "Click from Power Up: +%d Click\n• Normal Power Up : +%d Click (Level %d)\n• Super Power Up : + 0 Click (Level 0)" % [click_power_from_power_up, click_power_from_power_up, power_up_level]
	click_from_auto_click_detail.text = "Click from Auto Click : %d  Click/ %d Second\n• Normal Auto Click : %d Click/ %d Second (Level %d)\n• Super Auto Click : 0 Click/ 0 Second (Level 0)" % [auto_click_multiplier, auto_click_interval, auto_click_multiplier, auto_click_interval, auto_click_level]
	click_from_booster_detail.text = "Click from Booster : +%d Click" % click_power_from_boost
	if boost_power_active:
		var boost_time_left = int(booster_timer.time_left)
		click_from_booster_detail.text += " (for %d Second)" % boost_time_left
	boost_button.disabled = boost_power_active

#FUNGSI UTILITAS
func calculate_cps(level: int) -> float:
	var multiplier = 1
	var interval = max(1.0, 10.0 - level)
	if level > 10:
		multiplier = pow(2, level - 10)
		interval = 1.0
	return multiplier / interval

func get_auto_click_info(current_level: int) -> Dictionary:
	var info = {
		"interval": max(1, 10 - current_level) if current_level <= 10 else 1,
		"current_cps": 0.0,
		"next_cps": 0.0,
		"cps_increase": 0.0,
		"formatted_current": "0.00",
		"formatted_increase": "+0.00"}
	info.current_cps = calculate_cps(current_level)
	info.next_cps = calculate_cps(current_level + 1)
	info.cps_increase = info.next_cps - info.current_cps
	# Format the numbers
	info.formatted_current = "%.2f" % info.current_cps
	info.formatted_increase = "%+.2f" % info.cps_increase  # Includes + sign
	return info

func _on_booster_timer_timeout():
	# Ketika timer selesai, nonaktifkan boost
	boost_power_active = false
	boost_detail.text = "Boost: +%d Click" % click_power_from_boost
	update_booster_button.text = "ACTIVATE BOOSTER\nCost: 20,000 Poin"
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

func calculate_upgrade_cost(level: int) -> int:
	return int(1000 * pow(2.5, level - 1))

func calculate_click_power_from_level(level: int) -> int:
	return (level * (level + 1)) / 2

func calculate_power_up_cost(level: int) -> int:
	return 5000 + (level * 1000)  # Biaya linear

func calculate_auto_click_cost(level: int) -> int:
	# Fibonacci sequence adjusted for money scaling (1 point = 100 money)
	var n = level + 5  # Base offset for progression
	# Handle base cases
	if n <= 0:
		return 0
	elif n == 1:
		return 1500  # 15 points = 1500 money
	# Calculate Fibonacci sequence
	var a = 0
	var b = 1
	for _i in range(2, n + 1):
		var c = a + b
		a = b
		b = c
	# Scale to money (original point cost * 100) with multiplier
	var base_cost = b * 1500  # 15 points base = 1500 money
	return base_cost

func calculate_autoclick_power_from_level(level: int) -> Dictionary:
	# Menghasilkan dictionary berisi:
	var result = {
		"multiplier": 1,
		"interval": max(1.0, 10.0 - level)}
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
		money += money_per_click * total_click_power  # Hasilkan money
		total_click += 1
		bounce_animation_player.play("bounce")  # Jalankan animasi bounce
		click_sound.play()
		update_ui()

#UPGRADE LEVEL
func _on_upgrade_button_pressed():
	var upgrade_cost = calculate_upgrade_cost(shape_level)
	if money >= upgrade_cost:
		money -= upgrade_cost
		shape_level += 1
		levelup_sound.play()
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
		show_warning("Not enough money for upgrade!\nYou need %s more." % 
			format_money(upgrade_cost - money))

# POWER UP
func _on_power_up_button_pressed():
	var cost = calculate_power_up_cost(power_up_level)  # Biaya Power Up berdasarkan level
	if money >= cost:
		money -= cost
		power_up_level += 1  # Tingkatkan level Power Up
		money_per_click = 100 + (power_up_level * 10)
		update_ui()
	else:
		show_warning("Not enough money for buy Power Up!\n You need %s more." % format_money(cost - money))

# AUTO CLICK
func _on_auto_click_button_pressed():
	var auto_click_cost = calculate_auto_click_cost(auto_click_level)  # Nilai Fibonacci ke-n
	if money >= auto_click_cost:
		money -= auto_click_cost
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
		show_warning("Not enough money for buy Auto Click!\n You need %s more." % format_money(auto_click_cost - money))
		#print("Poin tidak cukup untuk membeli Auto Click!")

# Fungsi saat Auto Click Timer timeout
func _on_auto_click_timer_timeout():
	if auto_click_multiplier > 0:
		points += auto_click_multiplier 
		update_ui()

# BOOST
func _on_activate_boost_pressed():
	var boost_cost = 20000
	if money >= boost_cost:
		money -= boost_cost
		click_power_from_boost = 500
		boost_power_active = true
		boost_button.disabled = true
		booster_timer.start(boost_power_duration)
		update_ui()
	else:
		show_warning("Not enough money for Boost!\n You need %s more." % format_money(boost_cost - money))
