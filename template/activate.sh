function update_environment_variable() {
    NAME=$1
    VALUE=$2
    if [ ! -z "${VALUE}" ]
    then
        if [ -v ${NAME} ]
        then
            export ${NAME}_OLD=$(eval echo '$'${NAME})
        fi
        export ${NAME}=${VALUE}
    fi
}

ENV_PATH=__ENV_PATH__

VIRTUAL_ENV_JL_ENV_NAME=$(basename ${ENV_PATH})
export VIRTUAL_ENV_JL_ENV_NAME

update_environment_variable "PATH" "${ENV_PATH}/usr/bin/:${PATH}"
update_environment_variable "JULIA_HOME" "${ENV_PATH}/usr/bin/"
update_environment_variable "JULIA_LOAD_PATH" __LOAD_PATH__
update_environment_variable "JULIA_PKGDIR" "${ENV_PATH}/packages"
update_environment_variable "JULIA_HISTORY" __HISTORY_FILE__
export PS1_OLD="${PS1}"
export PS1="(${VIRTUAL_ENV_JL_ENV_NAME}) ${PS1}"
