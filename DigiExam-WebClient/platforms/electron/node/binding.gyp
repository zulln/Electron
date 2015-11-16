{
	'conditions': [
		['OS=="win"', {
			'targets': [
				{
					'target_name': 'dxlockdown',
					'sources': [ 'Lockdown/win/lockdown_win.cc' ]
				},
				{
					'target_name': 'dxpreconditiontests',
					'sources': [
						'PreConditionTests/base_precondition_test.h',
						'PreConditionTests/win/preconditiontest_win.cc',
						'PreConditionTests/win/admin_permission_test.h',
						'PreConditionTests/win/admin_permission_test.cc',
						'PreConditionTests/win/illegal_processes_test.h',
						'PreConditionTests/win/illegal_processes_test.cc',
						'PreConditionTests/win/remote_desktop_test.h',
						'PreConditionTests/win/remote_desktop_test.cc',
						'PreConditionTests/win/virtual_machine_test.h',
						'PreConditionTests/win/virtual_machine_test.cc',
						'PreConditionTests/win/write_permission_test.h',
						'PreConditionTests/win/write_permission_test.cc',
						'PreConditionTests/test_object_factory.h',
						'PreConditionTests/test_object_factory.cc'
					]
				}
			]
		}],
		['OS=="mac"',{
			'targets': [
				{
					'target_name': 'dxlockdown',
					'sources': [
						'Lockdown/base_lockdown_task.h',
						'Lockdown/mac/lockdown_mac.h',
						'Lockdown/mac/lockdown_mac.mm',
						'Lockdown/mac/kiosk_window_mac.h',
						'Lockdown/mac/kiosk_window_mac.mm',
						'Lockdown/mac/disable_screen_capture_mac.h',
						'Lockdown/mac/disable_screen_capture_mac.mm',
						'Lockdown/mac/sound_mac.h',
						'Lockdown/mac/sound_mac.mm',
						'Lockdown/mac/clear_clipboard_mac.h',
						'Lockdown/mac/clear_clipboard_mac.mm'
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
						'PreConditionTests/mac/remote_session_test.h',
						'PreConditionTests/mac/remote_session_test.mm',
						'PreConditionTests/mac/virtual_machine_test.h',
						'PreConditionTests/mac/virtual_machine_test.mm',
						'PreConditionTests/mac/virtual_machine_detector.h',
						'PreConditionTests/mac/virtual_machine_detector.mm',
						'PreConditionTests/test_object_factory.h',
						'PreConditionTests/test_object_factory.cc'
					]
				},
				{
					'target_name': 'dxsavedialog',
					'sources': [
						'Lockdown/mac/save_file_dialog_mac.h',
						'Lockdown/mac/save_file_dialog_mac.mm'
					]
				}
			]
		}]
	]
}
