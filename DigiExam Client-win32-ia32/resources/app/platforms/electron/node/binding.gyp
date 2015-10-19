{
	'conditions': [
		['OS=="win"', {
			'targets': [
				{
					'target_name': 'dxlockdown',
					'sources': [ 'lockdown/lockdown_win.cc' ]
				},
				{
					'target_name': 'dxpreconditiontests',
					'sources': [
						'PreConditionTests/win/preconditiontest_win.cc'
					]
				}
			]
		}],
		['OS=="mac"',{
			'targets': [
				{
					'target_name': 'dxlockdown',
					'sources': [
						'Lockdown/lockdown_mac.mm',
						'Lockdown/kioskwindow/kioskwindow_mac.mm',
						'Lockdown/sound/sound_mac.mm'
					]
				},
				{
					'target_name': 'dxpreconditiontests',
					'sources': [
						'PreConditionTests/mac/preconditiontest_mac.mm'
					]
				}
			]
		}]
	]
}
