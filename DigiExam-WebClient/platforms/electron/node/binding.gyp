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
						'Lockdown/sound/sound_mac.mm'
					]
				},
				{
					'target_name': 'dxpreconditiontests',
					'sources': [
						'PreConditionTests/mac/preconditiontest_mac.mm',
						'PreConditionTests/mac/basePreconditiontest.h',
						'PreConditionTests/mac/diskSpaceTest.h',
						'PreConditionTests/mac/diskSpaceTest.mm',
						'PreConditionTests/mac/installedTest.h',
						'PreConditionTests/mac/installedTest.mm',
						'PreConditionTests/mac/osVersionTest.h',
						'PreConditionTests/mac/osVersionTest.mm',
						'PreConditionTests/mac/virtualMachineTest.h',
						'PreConditionTests/mac/virtualMachineTest.mm',
						'PreConditionTests/mac/OSTestObj.h',
						'PreConditionTests/mac/OSTestObj.mm'
					]
				}
			]
		}]
	]
}
