#                  _     
#      _________  (_)___ 
#     / ___/ __ \/ / __ \
#    / /__/ /_/ / / / / /
#    \___/\____/_/_/ /_/
#                        a shiny thing the player can get
#-----------------------------------------------------------------------    

extends Area2D;

const MARGIN : int = 64;
var   SPAWN_AREA_WIDTH  : int;
var   SPAWN_AREA_HEIGHT : int;

#-----------------------------------------------------------------------    
func _ready() -> void:
	$AnimatedSprite2D.play("default");
	$AnimatedSprite2D.sprite_frames.set_animation_loop("default", true);
	hide();
	
	SPAWN_AREA_WIDTH  = get_viewport().size.x - (MARGIN * 2.0);
	SPAWN_AREA_HEIGHT = get_viewport().size.y - (MARGIN * 2.0);
	return;

#-----------------------------------------------------------------------    
# called when game wants to place a new coin
func spawn() -> void:
	self.position.x = randf_range(MARGIN, MARGIN + SPAWN_AREA_WIDTH);
	self.position.y = randf_range(MARGIN, MARGIN + SPAWN_AREA_HEIGHT);
	show();
	
#-----------------------------------------------------------------------    
func _on_mouse_entered() -> void:
	# we're not in play right now?
	if not(visible):
		# do nothing
		return;
		
	# cursor touched us, play sound + visual reward
	$AudioStreamPlayer2D.play();
	hide();
	if (get_parent().has_method("notify_coin_gotten")):
		get_parent().notify_coin_gotten(self.position);
	return;
