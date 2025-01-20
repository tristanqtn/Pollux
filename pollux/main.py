from pollux.wrapper.initialize import (
    logo,
    check_config,
    audit_to_conduct,
    flush_temporary_files,
)
from pollux.wrapper.wrapper import (
    conduct_audit,
    verify_output_path,
    terminate,
)

if __name__ == "__main__":
    logo()
    check_config()
    audit_to_conduct()
    verify_output_path()

    flush_temporary_files()

    conduct_audit()
    
    terminate()
