from pollux.wrapper.initialize import (
    logo,
    check_config,
    audit_to_conduct,
    flush_old_temporary_files,
    stash_temporary_file
    
)
from pollux.wrapper.wrapper import (
    conduct_audit,
    verify_output_path,
    compute_delta
)

if __name__ == "__main__":
    logo()
    check_config()
    audit_to_conduct()
    verify_output_path()
    flush_old_temporary_files()
    stash_temporary_file()
    conduct_audit()
    compute_delta()
