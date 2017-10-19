function restore_environment_variable() {
    NAME=$1
    if [ -v ${NAME}_OLD ]
    then
        export ${NAME}=$(eval echo '$'${NAME}_OLD)
        unset ${NAME}_OLD
    fi
}

unset VIRTUAL_ENV_JL_ENV_NAME
restore_environment_variable "PATH"
restore_environment_variable "JULIA_HOME"
restore_environment_variable "JULIA_LOAD_PATH"
restore_environment_variable "JULIA_PKGDIR"
restore_environment_variable "JULIA_HISTORY"
export PS1="${PS1_OLD}"
unset PS1_OLD
