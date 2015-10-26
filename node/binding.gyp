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
						'Lockdown/sound/sound_mac.mm'
					]
				},
				{
					'target_name': 'dxpreconditiontests',
					'sources': [
						'PreConditionTests/base_precondition_test.h',
						'PreConditionTests/mac/preconditiontest_mac.h',
						'PreConditionTests/mac/preconditiontest_mac.mm',
						'PreConditionTests/mac/disk_space_test.h',
						'PreConditionTests/mac/disk_space_test.mm',
						'PreConditionTests/mac/installed_test.h',
						'PreConditionTests/mac/installed_test.mm',
						'PreConditionTests/mac/os_version_test.h',
						'PreConditionTests/mac/os_version_test.mm',
						'PreConditionTests/mac/virtual_machine_test.h',
						'PreConditionTests/mac/virtual_machine_test.mm',
						'PreConditionTests/mac/virtual_machine_detector.h',
						'PreConditionTests/mac/virtual_machine_detector.mm',
						'PreConditionTests/test_object_factory.h',
						'PreConditionTests/test_object_factory.cc'
					]
				}
			]
		}]
	]
}
