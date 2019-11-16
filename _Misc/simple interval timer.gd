# executes every n time.


var cdtime = 0 #Time elapsed
var waittime = 4 #Step value


func _physics_process(delta):
	cdtime += 1
	if cdtime % waittime == 0:
		# do thing here