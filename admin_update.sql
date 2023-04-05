UPDATE vicidial_users set pass='Shelby2018' ,full_name='Admin' ,user_level='9' ,user_group='ADMIN' ,phone_login='' ,phone_pass='' ,delete_users='1' ,delete_user_groups='1' ,delete_lists='1' ,delete_campaigns='1' ,delete_ingroups='1' ,delete_remote_agents='1' ,load_leads='1' ,campaign_detail='1' ,ast_admin_access='1' ,ast_delete_phones='1' ,delete_scripts='1' ,modify_leads='1' ,hotkeys_active='0' ,change_agent_campaign='1' ,agent_choose_ingroups='1' ,closer_campaigns='' ,scheduled_callbacks='1' ,agentonly_callbacks='0' ,agentcall_manual='0' ,vicidial_recording='1' ,vicidial_transfers='1' ,delete_filters='1' ,alter_agent_interface_options='1' ,closer_default_blended='0' ,delete_call_times='1' ,modify_call_times='1' ,modify_users='1' ,modify_campaigns='1' ,modify_lists='1' ,modify_scripts='1' ,modify_filters='1' ,modify_ingroups='1' ,modify_usergroups='1' ,modify_remoteagents='1' ,modify_servers='1' ,view_reports='1' ,vicidial_recording_override='DISABLED' ,alter_custdata_override='NOT_ACTIVE' ,qc_enabled='0' ,qc_user_level='1' ,qc_pass='0' ,qc_finish='0' ,qc_commit='0' ,add_timeclock_log='1' ,modify_timeclock_log='1' ,delete_timeclock_log='1' ,alter_custphone_override='NOT_ACTIVE' ,vdc_agent_api_access='1' ,modify_inbound_dids='1' ,delete_inbound_dids='1' ,active='Y' ,download_lists='1' ,agent_shift_enforcement_override='DISABLED' ,manager_shift_enforcement_override='1' ,export_reports='1' ,delete_from_dnc='1' ,email='' ,territory='' ,allow_alerts='0' ,agent_choose_territories='0' ,custom_one='' ,custom_two='' ,custom_three='' ,custom_four='' ,custom_five='' ,voicemail_id='' ,agent_call_log_view_override='DISABLED' ,callcard_admin='1' ,agent_choose_blended='1' ,realtime_block_user_info='0' ,custom_fields_modify='0' ,force_change_password='N' ,agent_lead_search_override='NOT_ACTIVE' ,modify_shifts='1' ,modify_phones='1' ,modify_carriers='1' ,modify_labels='1' ,modify_statuses='1' ,modify_voicemail='1' ,modify_audiostore='1' ,modify_moh='1' ,modify_tts='1' ,preset_contact_search='NOT_ACTIVE' ,modify_contacts='1' ,modify_same_user_level='1' ,admin_hide_lead_data='0' ,admin_hide_phone_data='0' ,agentcall_email='0' ,agentcall_chat='0' ,modify_email_accounts='0' ,failed_login_count=0,alter_admin_interface_options='1' ,max_inbound_calls='0' ,modify_custom_dialplans='1' ,wrapup_seconds_override='-1' ,modify_languages='0' ,selected_language='default English' ,user_choose_language='0' ,ignore_group_on_search='0' ,api_list_restrict='0' ,api_allowed_functions=' ALL_FUNCTIONS ' ,lead_filter_id='NONE' ,admin_cf_show_hidden='0' ,user_hide_realtime='0' ,access_recordings='0' ,modify_colors='1' ,user_nickname='' ,user_new_lead_limit='-1' ,api_only_user='0' ,modify_auto_reports='0' ,modify_ip_lists='0' ,ignore_ip_list='0' ,ready_max_logout='-1' ,export_gdpr_leads='0' ,pause_code_approval='1' ,max_hopper_calls='0' ,max_hopper_calls_hour='0' ,mute_recordings='DISABLED' ,hide_call_log_info='DISABLED' ,next_dial_my_callbacks='NOT_ACTIVE' ,user_admin_redirect_url='' ,max_inbound_filter_enabled='0' ,max_inbound_filter_statuses='' ,max_inbound_filter_ingroups='' ,max_inbound_filter_min_sec='-1' ,status_group_id='' ,mobile_number='' ,two_factor_override='NOT_ACTIVE' ,manual_dial_filter='DISABLED' ,user_location='' ,download_invalid_files='0' ,user_group_two='' ,user_code='' where user='6666'
INSERT INTO vicidial_inbound_group_agents set group_rank='0' , group_weight='0' , group_id='AGENTDIRECT' , user='6666' , group_web_vars='' , group_grade='1'
UPDATE vicidial_live_inbound_agents set group_weight='0' , group_grade='1' where group_id='AGENTDIRECT' and user='6666'
INSERT INTO vicidial_inbound_group_agents set group_rank='0' , group_weight='0' , group_id='AGENTDIRECT_CHAT' , user='6666' , group_web_vars='' , group_grade='1'
UPDATE vicidial_live_inbound_agents set group_weight='0' , group_grade='1' where group_id='AGENTDIRECT_CHAT' and user='6666'

INSERT INTO vicidial_server_carriers SET carrier_id='TilTxOUT', carrier_name='TilTx Outbound',registration_string='', template_id='--NONE--', account_entry="[TilTxOUT]\ndisallow=all\nallow=ulaw\ntype=friend\nhost=dynamic\ndtmfmode=rfc2833\ncontext=trunkinbound\n", protocol='SIP', globals_string='', dialplan_entry="exten => _91999NXXXXXX,1,AGI(agi://127.0.0.1:4577/call_log)\nexten => _91999NXXXXXX,2,Dial(${TESTSIPTRUNK}/${EXTEN:2},${CAMPDTO},To)\nexten => _91999NXXXXXX,3,Hangup\n", server_ip='0.0.0.0', active='Y';
INSERT INTO vicidial_server_carriers SET carrier_id='TilTxIN', carrier_name='TilTx Inbound',registration_string='', template_id='--NONE--', account_entry="[TilTxIN]\ndisallow=all\nallow=ulaw\ntype=friend\nhost=dynamic\ndtmfmode=rfc2833\ncontext=trunkinbound\n", protocol='SIP', globals_string='', dialplan_entry="exten => _91999NXXXXXX,1,AGI(agi://127.0.0.1:4577/call_log)\nexten => _91999NXXXXXX,2,Dial(${TESTSIPTRUNK}/${EXTEN:2},${CAMPDTO},To)\nexten => _91999NXXXXXX,3,Hangup\n", server_ip='0.0.0.0', active='Y';
INSERT INTO vicidial_server_carriers SET carrier_id='TilTxMAN', carrier_name='TilTx Manual',registration_string='', template_id='--NONE--', account_entry="[TilTxMAN]\ndisallow=all\nallow=ulaw\ntype=friend\nhost=dynamic\ndtmfmode=rfc2833\ncontext=trunkinbound\n", protocol='SIP', globals_string='', dialplan_entry="exten => _91999NXXXXXX,1,AGI(agi://127.0.0.1:4577/call_log)\nexten => _91999NXXXXXX,2,Dial(${TESTSIPTRUNK}/${EXTEN:2},${CAMPDTO},To)\nexten => _91999NXXXXXX,3,Hangup\n", server_ip='0.0.0.0', active='Y';
INSERT INTO vicidial_server_carriers SET carrier_id='TilTxKhomp', carrier_name='TilTx Khomp',registration_string='', template_id='--NONE--', account_entry="[TilTxKhomp]\ndisallow=all\nallow=ulaw\ntype=friend\nhost=dynamic\ndtmfmode=rfc2833\ncontext=trunkinbound\n", protocol='SIP', globals_string='', dialplan_entry="exten => _91999NXXXXXX,1,AGI(agi://127.0.0.1:4577/call_log)\nexten => _91999NXXXXXX,2,Dial(${TESTSIPTRUNK}/${EXTEN:2},${CAMPDTO},To)\nexten => _91999NXXXXXX,3,Hangup\n", server_ip='0.0.0.0', active='Y';

