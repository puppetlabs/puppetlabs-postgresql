# @summary type for all parameters in the postgresql::server::recovery defined resource
# @see https://github.com/ikonia/puppetlabs-postgresql/blob/be/manifests/server/recovery.pp
type Postgresql::Recovery = Struct[{
    Optional[restore_command]           => String[1],
    Optional[archive_cleanup_command]   => String[1],
    Optional[recovery_end_command]      => String[1],
    Optional[recovery_target_name]      => String[1],
    Optional[recovery_target_time]      => String[1],
    Optional[recovery_target_xid]       => String[1],
    Optional[recovery_target_inclusive] => Boolean,
    Optional[recovery_target]           => String[1],
    Optional[recovery_target_timeline]  => String[1],
    Optional[recovery_target_action]    => Enum['pause', 'promote', 'shutdown'],
    Optional[pause_at_recovery_target]  => Boolean,
    Optional[standby_mode]              => String[1],
    Optional[primary_conninfo]          => String[1],
    Optional[primary_slot_name]         => Pattern[/^[a-z0-9_]+$/],
    Optional[trigger_file]              => String[1],
    Optional[promote_trigger_file]      => String[1],
    Optional[recovery_min_apply_delay]  => Integer,
    Optional[target]                    => Stdlib::Absolutepath,
}]
