#      __                __      __                __ 
#     / /  ___ ___ _____/ /_    / /  __ _________ / /_
#    / _ \/ -_) _ `/ __/ __/   / _ \/ // / __(_-</ __/
#   /_//_/\__/\_,_/_/  \__/   /_.__/\_,_/_/ /___/\__/ 
#               ______        __ 
#          ___ / _/ _/__ ____/ /_
#         / -_) _/ _/ -_) __/ __/
#         \__/_//_/ \__/\__/\__/ 
#------------------------------------------------------------------------
extends CPUParticles2D;

#------------------------------------------------------------------------
# keep track of when we were spawned - used later to ask to die after ageing too
# long
var birth_time : float;

#------------------------------------------------------------------------
func _ready() -> void:
	birth_time = Time.get_ticks_msec() / 1000.0;

#------------------------------------------------------------------------
func _process(delta: float) -> void:
	# gracefully delete myself after effect is done
	var now = Time.get_ticks_msec() / 1000.0;
	if ((now - birth_time) > lifetime):
		get_parent().remove_child(self);
		queue_free();
