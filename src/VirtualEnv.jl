module VirtualEnv

function create_environment(
    path:: AbstractString;
    julia_home = Base.JULIA_HOME,
    data_root_dir = Base.DATAROOTDIR, sys_conf_dir = Base.SYSCONFDIR,
    header_file_dir = "../include", library_dir = "../lib",
    julia_load_path = [],
    history_file_path = Nullable(),
    use_symlink = false
)
    const copy = use_symlink ? symlink : cp
    const separator = is_windows() ? ";" : ":"

    const env_name = isdirpath(path) ? dirname(path) : basename(path)
    const load_path = join(julia_load_path, separator)

    # Create new directory
    mkpath(path)
    mkpath(joinpath(path, "usr"))
    mkpath(joinpath(path, "usr", "bin"))
    mkpath(joinpath(path, "usr", "share"))
    mkpath(joinpath(path, "usr", "include"))
    mkpath(joinpath(path, "usr", "lib"))
    mkpath(joinpath(path, "etc"))
    mkpath(joinpath(path, "packages"))

    # Copy julia files
    ## executables
    copy(joinpath(julia_home, "julia"), joinpath(path, "usr", "bin", "julia"))
    chmod(joinpath(path, "usr", "bin", "julia"), 0o755)
    copy(joinpath(julia_home, "julia-debug"), joinpath(path, "usr", "bin", "julia-debug"))
    chmod(joinpath(path, "usr", "bin", "julia-debug"), 0o755)

    ## data
    copy(joinpath(julia_home, data_root_dir, "julia"), joinpath(path, "usr", "share", "julia"))
    ## sysconfig
    copy(joinpath(julia_home, sys_conf_dir, "julia"), joinpath(path, "etc", "julia"))
    ## header files
    copy(joinpath(julia_home, header_file_dir, "julia"), joinpath(path, "usr", "include", "julia"))
    ## libraries
    copy(joinpath(julia_home, library_dir, "julia"), joinpath(path, "usr", "lib", "julia"))
    for (root, _, files) in walkdir(joinpath(julia_home, library_dir))
        for file in files
            if startswith(file, "libjulia")
                copy(joinpath(root, file), joinpath(path, "usr", "lib", file))
            end
        end
    end

    # Create activate/deactivate scripts
    template_dir = joinpath(Pkg.dir("VirtualEnv"), "template")
    activate_script = readstring(joinpath(template_dir, "activate.sh"))
    open(joinpath(path, "usr", "bin", "activate"), "w") do fp
        t1 = replace(activate_script, "__ENV_NAME__", env_name)
        t2 = replace(t1, "__LOAD_PATH__", load_path)
        t3 = replace(t2, "__HISTORY_FILE__", get(history_file_path, ""))
        t4 = replace(t3, "__ENV_PATH__", abspath(path))
        write(fp, t4)
    end

    cp(joinpath(template_dir, "deactivate.sh"), joinpath(path, "usr", "bin", "deactivate"))
end
export create_environment

end
