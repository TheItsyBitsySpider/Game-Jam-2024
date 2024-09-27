class_name TestCard

extends BaseCard

func play():
	print(' '.join([moniker, cost]))
	queue_free()
