# 信号管理器
extends Node

func register(signal_name: String, target: Object, method: String):
	if !has_user_signal(signal_name): add_user_signal(signal_name)	
	# warning-ignore:return_value_discarded
	connect(signal_name, target, method)

func unregister(signal_name: String, target: Object, method: String):
	if has_user_signal(signal_name):
		# warning-ignore:return_value_discarded
		disconnect(signal_name, target, method)
