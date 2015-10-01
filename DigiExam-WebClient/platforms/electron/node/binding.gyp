{
	'conditions': [
		['OS=="win"', {
			'targets': [
				{
					'target_name': 'dxlockdown',
					'sources': [ 'lockdown_win.cc' ]
				}
			]
		}],
		['OS=="mac"',{
			'targets': [
				{
					'target_name': 'dxlockdown',
					'sources': [
						'lockdown_mac.mm',
						'kioskwindow/kioskwindow_mac.mm',
						'sound/sound_mac.mm'
					]
				}
			]
		}]
	]
}
