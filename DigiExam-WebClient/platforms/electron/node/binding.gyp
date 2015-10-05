{
	'conditions': [
		['OS=="win"', {
			'targets': [
				{
					'target_name': 'dxlockdown',
					'sources': [ 'lockdown/lockdown_win.cc' ]
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
						'PreConditionTests/mac/DXPreConditionTest.h',
						'PreConditionTests/mac/DXBasePreConditionTest.h',
						'PreConditionTests/mac/DXBasePreConditionTest.mm',
						'PreConditionTests/mac/DXVirtualMachineDetector.h',
						'PreConditionTests/mac/DXVirtualMachineDetector.mm',
						'PreConditionTests/mac/DXVirtualMachineTest.h',
						'PreConditionTests/mac/DXVirtualMachineTest.mm',
						'PreConditionTests/mac/DXDiskSpaceTest.h',
						'PreConditionTests/mac/DXDiskSpaceTest.mm',
						'PreConditionTests/mac/DXInstalledTest.h',
						'PreConditionTests/mac/DXInstalledTest.mm',
						'PreConditionTests/mac/DXOSVersionTest.h',
						'PreConditionTests/mac/DXOSVersionTest.mm'
					]
				}
			]
		}]
	]
}
