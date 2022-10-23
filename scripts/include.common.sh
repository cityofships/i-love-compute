#! /usr/bin/env bash

set -u -e -o pipefail

workspace_parent_dir="${script_dir}/workspace"
workspace_dir="${workspace_parent_dir}/${script_name}"
patch_dir="${script_dir}/../patches"
install_dir="${workspace_dir}/install"

provides_hip='false'
provides_opencl='false'
provides_vulkan='false'
provides_opengl='false'
provides_egl='false'
builds_llvm='false'

usable_job_count='1'
do_pull='false'

tab=$'\t'

_error () {
	printf 'ERROR: %s\n\n' "${1}" >&2

	exit 1
}

_prefix () {
	sed -e 's/^/'"${1}"': /'
}

_cd () {
	cd "${script_dir}"

	mkdir --parents --verbose "${workspace_dir}"

	cd "${workspace_dir}"
}

_is_done () {
	[ -f "$(pwd).done" ]
}

_set_done () {
	touch "$(pwd).done"
}

_find_vulkan_icd_files () {
	if [ -d "${install_dir}/share/vulkan/icd.d" ]
	then
		find "${install_dir}/share/vulkan/icd.d" \
			-type f \
			-name '*.json' \
			| tr '\n' ':'
	fi
}

_set_custom_env () {
	true
}

_set_env () {
	local machine="$(uname -m)"

	export PATH="${install_dir}/bin:${PATH:-}"

	export LIBRARY_PATH="${install_dir}/lib/${machine}-linux-gnu:${LIBRARY_PATH:-}"
	export LIBRARY_PATH="${install_dir}/lib:${LIBRARY_PATH:-}"

	export LD_LIBRARY_PATH="${install_dir}/lib/${machine}-linux-gnu:${LD_LIBRARY_PATH:-}"
	export LD_LIBRARY_PATH="${install_dir}/lib:${LD_LIBRARY_PATH:-}"

	export PKG_CONFIG_PATH="${install_dir}/lib/${machine}-linux-gnu/pkgconfig:${PKG_CONFIG_PATH:-}"
	export PKG_CONFIG_PATH="${install_dir}/lib/pkgconfig:${PKG_CONFIG_PATH:-}"
	export PKG_CONFIG_PATH="${install_dir}/share/pkgconfig:${PKG_CONFIG_PATH:-}"

	export PYTHONUSERBASE="${install_dir}"

	export CMAKE_PREFIX_PATH="${install_dir}:${CMAKE_PREFIX_PATH:-}"

	if "${provides_opencl}"
	then
		export OPENCL_VENDOR_PATH="${install_dir}/etc/OpenCL/vendors"
	fi

	if "${provides_vulkan}"
	then
		export VK_ICD_FILENAMES="$(_find_vulkan_icd_files):${VK_ICD_FILENAMES:-}"

		# Doesn't work:
		# export VK_DRIVERS_PATH="${install_dir}/share/vulkan/icd.d:${VK_DRIVERS_PATH:-}"
	fi

	_set_custom_env
}

_update () {
	if "${do_pull}"
	then
		git pull || true
		git submodule update --init --recursive
	fi
}

_fetch_archive () {
	local url="${1}"
	local archive="$(basename "${url}")"
	local checksum="${2}"

	if [ -f "${archive}" ]
	then
		case "$(sha512sum "${archive}")" in
			"${checksum} *${archive}")
				;;
			*)
				rm "${archive}"
		esac
	fi

	if [ ! -f "${archive}" ]
	then
		wget "${url}"
	fi
	
	case "${archive}" in
		*'.tar.gz')
			tar xzvf "${archive}"
			;;
		*'.tar.bz2')
			tar xjvf "${archive}"
			;;
		*'.tar.xz')
			tar xJvf "${archive}"
			;;
		*'.zip')
			unzip "${archive}"
			;;
	esac
}

_fetch () {
	local i=0
	while [ "${i}" -lt "${#packages[@]}" ]
	do
		local name="${packages[${i}]}"
		i="$((${i} + 1))"
		local directory="${packages[${i}]}"
		i="$((${i} + 1))"
		local repository="${packages[${i}]}"
		i="$((${i} + 1))"
		local branch="${packages[${i}]}"
		i="$((${i} + 1))"
		# slug
		i="$((${i} + 1))"

		if [ "${name}" = '-' ]
		then
			continue
		fi

		if [ "${repository}" = '-' ]
		then
			continue
		fi

		_cd

		if ! [ -d "${directory}" ]
		then
			# Archive url is stored in ${repository}.
			# Archive checksum is stored in ${branch}.
			case "${repository}" in
				*'.tar.gz')
					_fetch_archive "${repository}" "${branch}"
					continue
					;;
				*'.tar.bz2')
					_fetch_archive "${repository}" "${branch}"
					continue
					;;
				*'.tar.xz')
					_fetch_archive "${repository}" "${branch}"
					continue
					;;
				*'.zip')
					_fetch_archive "${repository}" "${branch}"
					continue
					;;
			esac

			{
				echo "$(pwd)/${directory}"

				if [ "${branch}" = '-' ]
				then
					git clone --recurse-submodules "${repository}" "${directory}"
				else
					git clone --recurse-submodules --branch "${branch}" "${repository}" "${directory}"
				fi
			} | _prefix "Clone ${name}"
		fi

		{
			cd "${directory}"
			pwd

			_update
		} | _prefix "Pull ${name}"
	done
}

_pull () {
	do_pull='true'

	_fetch
}

# Must be called in the source directory to patch.
_apply_patches () {
	if [ ! -d '.git' ]
	then
		git init
		git add .
		git commit -m 'init'
		git branch -M 'master'
	fi

	case "$(git rev-parse --abbrev-ref HEAD)" in
		'patched')
			;;
		'patched/'*)
			;;
		*)
			git checkout -b 'patched'

			for patch_file in "${@}"
			do
				patch_fullpath="${patch_dir}/${patch_file}"
				patch -p1 < "${patch_fullpath}"
				git commit -am "patch: ${patch_file}"
			done
			;;
	esac
}

_mold () {
	if [ -n "${self_mold:-}" ]
	then
		"${@}"
		return
	fi

	if ! command -v 'mold' >/dev/null
	then
		"${@}"
		return
	fi

	mold --run "${@}"
}

_meson_setup_wrapper () {
	if ! [ -f 'build/compile_commands.json' ]
	then
		_mold meson setup \
			'build' \
			"${@}"
	else
		_mold meson setup \
			--reconfigure \
			'build' \
			"${@}"
	fi
}

_meson_setup () {
	_meson_setup_wrapper \
		-D'prefix'="${install_dir}" \
		-D'buildtype'="${meson_build_type}" \
		"${@}"
}

_cmake_setup () {
	_mold cmake \
		-S'.' \
		-B'build' \
		-G'Ninja' \
		-D'CMAKE_INSTALL_PREFIX'="${install_dir}" \
		-D'CMAKE_BUILD_TYPE'="${cmake_build_type}" \
		-D'BUILD_SHARED_LIBS'='ON' \
		"${@}"

	echo '*' > 'build/.gitignore'
}

_cmake_target () {
	_mold cmake \
		--build 'build' \
		--parallel "${usable_job_count}" \
		-- "${@}"
}

_cmake_compile_install () {
	_cmake_target

	_cmake_target install
}

_meson_compile_install () {
	_mold meson compile \
		-C 'build' \
		-j "${usable_job_count}"

	_mold meson install \
		-C 'build'
}

_build_generic_python () {
	# FIXME: Implement a RelWithDebInfo equivalent.

	_mold python3 'setup.py' build

	# PYTHONUSERBASE already takes care of it:
	# --prefix="${install_dir}"
	_mold python3 'setup.py' install --user
}

_build_generic_configure () {
	# FIXME: Implement a RelWithDebInfo equivalent.

	_mold ./configure \
		--prefix="${install_dir}" \
		"${@}"

	_mold make -j"${usable_job_count}"

	_mold make install
}

_build_generic_autogen () {
	# FIXME: Implement a RelWithDebInfo equivalent.

	_mold ./autogen.sh \
		--prefix="${install_dir}" \
		"${@}"

	_build_generic_configure \
		"${@}"
}

_build_generic_cmake () {
	_cmake_setup

	_cmake_compile_install
}

_build_generic_meson () {
	_meson_setup

	_meson_compile_install
}

_get_llvm_job_count () {
	local do_force="${1}"; shift
	local llvm_job_count="${1}"; shift
	
	if ! "${builds_llvm}"
	then
		echo "${llvm_job_count}"
		return
	fi

	local mem_available_k="$(grep '^MemAvailable:' /proc/meminfo | awk '{ print $2 }')"
	local mem_available_g="$((${mem_available_k} / 1024 / 1024))"
	local mem_per_core="$((${mem_available_g} / ${job_count}))"
	local min_llvm_mem_per_core='8'

	if [ "${mem_per_core}" -lt "${min_llvm_mem_per_core}" ]
	then
		if ! "${do_force}"
		then
			llvm_job_count="$((${mem_available_g} / ${min_llvm_mem_per_core}))"

			cat >&2 <<-EOF
			WARNING: The computer has less than ${min_llvm_mem_per_core}G of available memory per CPU core.
			LLVM will be compiled will ${llvm_job_count} jobs instead of ${job_count} to prevent the computer
			to run out of memory when linking LLVM.

			Use --force to force using ${job_count} jobs when compiling LLVM.
			EOF
			sleep 5s
		fi
	fi

	echo "${llvm_job_count}"
}

_write_custom_patches () {
	true
}

# FIXME: Set generic configure build type.
meson_build_type='debugoptimized'
cmake_build_type='RelWithDebInfo'

_set_build_type () {
	case "${1}" in
		'Debug')
			cmake_build_type="${1}"
			meson_build_type='debug'
			;;
		'RelWithDebInfo')
			cmake_build_type="${1}"
			meson_build_type='debugoptimized'
			;;
		'Release')
			cmake_build_type="${1}"
			meson_build_type='release'
			;;
	esac
}

_build_basic_project () {
	local job_count="$(nproc)"
	local do_force='false'

	local build_type='Debug'

	while ! [ -z "${1:-}" ]
	do
		case "${1:-}" in
			'--pull')
				do_pull='true'
				;;
			'--force')
				do_force='true'
				;;
			'-j'|'--jobs')
				shift

				if [ -z "${1:-}" ]
				then
					_error 'Missing job count.'
				fi

				job_count="${1}"
				;;
			'-j'*)
				job_count="${1:2}"
				;;
			'--type='*)
				build_type="${1:7}"
				;;
			'-h'|'--help'|'')
				_help
				;;
			'-'*|'--'*)
				_error 'Unknown build option.'
				;;
			*)
				_error 'Unknown build parameter.'
				;;
		esac

		shift
	done

	_set_build_type "${build_type}"

	local llvm_job_count="$(_get_llvm_job_count "${do_force}" "${job_count}")"

	_set_env

	_write_custom_patches

	_fetch

	local time_log=''
	local full_time_before="$(date '+%s')"

	local i=0
	while [ "${i}" -lt "${#packages[@]}" ]
	do
		local time_before="$(date '+%s')"

		local name="${packages[${i}]}"
		i="$((${i} + 1))"
		local directory="${packages[${i}]}"
		i="$((${i} + 1))"
		# repository
		i="$((${i} + 1))"
		# branch
		i="$((${i} + 1))"
		local slug="${packages[${i}]}"
		i="$((${i} + 1))"

		if [ "${name}" = '-' ]
		then
			continue
		fi

		if [ "${slug}" = '-' ]
		then
			continue
		fi

		if [ "${name}" = 'LLVM' ]
		then
			usable_job_count="${llvm_job_count}"
		else
			usable_job_count="${job_count}"
		fi

		{
			_cd

			cd "${directory}"
			pwd

			echo "${slug}"
			"_build_${slug}"
		} | _prefix "Build ${name}"

		local time_after="$(date '+%s')"
		local time_spent="$((${time_after} - ${time_before}))"

		time_log+="${name}: ${time_spent}s"
		time_log+=$'\n'
	done

	local full_time_after="$(date '+%s')"
	local full_time_spent="$((${full_time_after} - ${full_time_before}))"

	cat <<-EOF
	Time spent on building packages:
	${time_log}
	Time spent on building all packages:
	All: ${full_time_spent}s
	EOF
}

_build_featured_project () {
	local job_count="$(nproc)"
	local do_force='false'

	local build_type='Debug'

	local feature_list=''
	local enable_list=''
	local disable_list=''

	while ! [ -z "${1:-}" ]
	do
		case "${1:-}" in
			'--pull')
				do_pull='true'
				;;
			'--force')
				do_force='true'
				;;
			'-j'|'--jobs')
				shift

				if [ -z "${1:-}" ]
				then
					_error 'Missing job count.'
				fi

				job_count="${1}"
				;;
			'-j'*)
				job_count="${1:2}"
				;;
			'--type='*)
				build_type="${1:8}"
				;;
			'--features='*)
				feature_list="${1:11}"
				feature_list="${feature_list//,/ }"
				;;
			'--enable='*)
				enable_list="${1:9}"
				enable_list="${enable_list//,/ }"
				;;
			'--disable='*)
				disable_list="${1:10}"
				disable_list="${disable_list//,/ }"
				;;
			'-h'|'--help'|'')
				_help
				;;
			'-'*|'--'*)
				_error 'Unknown build option.'
				;;
			*)
				_error 'Unknown build parameter.'
				;;
		esac

		shift
	done

	_set_build_type "${build_type}"

	local llvm_job_count="$(_get_llvm_job_count "${do_force}" "${job_count}")"

	if [ -z "${feature_list}" ]
	then
		feature_list="${default_feature_list}"
	elif [ "${feature_list}" = 'all' ]
	then
		feature_list="${known_feature_list}"
	fi

	local feature_mode
	local feature_name
	local feature_is_unknown
	local feature_value

	local iteratable_known_feature_list="${known_feature_list//,/ }"
	local iteratable_feature_list="${feature_list//,/ }"

	for feature_name in ${iteratable_feature_list}
	do
		eval "feature_${feature_name}='true'"
	done

	for feature_mode in 'enable' 'disable'
	do
		if [ "${feature_mode}" = 'enable' ]
		then
			feature_value='true'
		else
			feature_value='false'
		fi

		for feature_name in $(eval 'echo ${'"${feature_mode}"'_list}')
		do
			feature_is_unknown='true'
			for known_feature in ${iteratable_known_feature_list}
			do
				if [ "${feature_name}" = "${known_feature}" ]
				then
					eval "feature_${feature_name}='${feature_value}'"
					feature_is_unknown='false'
				fi
			done

			if "${feature_is_unknown}"
			then
				_error "Unknown feature: ${feature_name}"
			fi
		done
	done

	local enabled_feature_list=''
	local disabled_feature_list=''
	for feature_name in ${iteratable_known_feature_list}
	do
		if eval '${feature_'"${feature_name}"'}'
		then
			enabled_feature_list+="${enabled_feature_list:+,}${feature_name}"
		else
			disabled_feature_list+="${disabled_feature_list:+,}${feature_name}"
		fi
	done

	printf 'Building features: %s\n' "${enabled_feature_list}"
	printf 'Not building features: %s\n' "${disabled_feature_list}"

	_set_env

	_write_custom_patches

	_fetch

	local time_log=''
	local full_time_before="$(date '+%s')"

	local i=0
	while [ "${i}" -lt "${#packages[@]}" ]
	do
		local time_before="$(date '+%s')"

		local name="${packages[${i}]}"
		i="$((${i} + 1))"
		local directory="${packages[${i}]}"
		i="$((${i} + 1))"
		# repository
		i="$((${i} + 1))"
		# branch
		i="$((${i} + 1))"
		local slug="${packages[${i}]}"
		i="$((${i} + 1))"

		if [ "${name}" = '-' ]
		then
			continue
		fi

		if [ "${slug}" = '-' ]
		then
			continue
		fi

		if [ "${name}" = 'LLVM' ]
		then
			usable_job_count="${llvm_job_count}"
		else
			usable_job_count="${job_count}"
		fi

		{
			_cd

			cd "${directory}"
			pwd

			echo "${slug}"
			"_build_${slug}"
		} | _prefix "Build ${name}"

		local time_after="$(date '+%s')"
		local time_spent="$((${time_after} - ${time_before}))"

		time_log+="${name}: ${time_spent}s"
		time_log+=$'\n'
	done

	local full_time_after="$(date '+%s')"
	local full_time_spent="$((${full_time_after} - ${full_time_before}))"

	cat <<-EOF
	Time spent on building packages:
	${time_log}
	Time spent on building all packages:
	All: ${full_time_spent}s
	EOF
}

_build () {
	"_build_${build_preset}" "${@}"
}

_clean () {
	cd "${script_dir}"

	if [ -d "${workspace_dir}" ]
	then
		cd "${workspace_dir}"

		local i=0
		while [ "${i}" -lt "${#packages[@]}" ]
		do
			local name="${packages[${i}]}"
			i="$((${i} + 1))"
			local directory="${packages[${i}]}"
			i="$((${i} + 1))"
			local repository="${packages[${i}]}"
			i="$((${i} + 1))"
			# branch
			i="$((${i} + 1))"
			# slug
			i="$((${i} + 1))"

			if [ "${name}" = '-' ]
			then
				continue
			fi

			if [ "${repository}" = '-' ]
			then
				continue
			fi

			{
				_cd

				echo "$(pwd)/${directory}"
				rm -force --recursive --verbose "${directory}"
			} | _prefix "Clean ${name}"
		done

		cd "${script_dir}"

		rmdir --verbose "${workspace_dir}"
	fi

	if [ -d "${workspace_parent_dir}" ]
	then
		rmdir --ignore-fail-on-non-empty --verbose "${workspace_parent_dir}"
	fi
}

_shell () {
	_set_env

	_cd

	pwd | _prefix "Shell ${script_name}"

	"${SHELL}"
}

_set_custom_run_env () {
	true
}

_run_custom_command () {
	"${install_dir}${required_file}"
}

_run_common () {
	if [ "${1:-}" = '--force' ]
	then
		shift
	elif ! [ -f "${install_dir}${required_file}" ]
	then
		_error "${project_name} is not built."
	fi

	_set_env

	_set_custom_run_env
}

_run () {
	_run_common

	if [ -z "${1:-}" ]
	then
		if [ "${help_preset}" = 'basic_application' ]
		then
			_run_custom_command
		else
			_error 'Missing command.'
		fi
	else
		"${@}"
	fi

	exit
}

_run_flatpak () {
	_run_common

	if [ -z "${1:-}" ]
	then
		_error 'Missing command.'
	else
		flatpak run --filesystem=host --env=LD_LIBRARY_PATH="${LD_LIBRARY_PATH}" "${@}"
	fi
}

_help_custom_build () {
	true
}

_help_custom_run () {
	true
}

_help_common_application_run () {
	cat <<-EOF
	${tab}${script_name} run
	EOF
}

_help_basic_application () {
	uniq <<-EOF
	${script_name}: Download and build ${project_name}.

	Usage: ${script_name} [OPTION] [ACTION] [OPTION] [COMMAND]

	Option:
	${tab}-h, --help
	${tab}${tab}Print this help.

	Actions:
	${tab}pull
	${tab}${tab}Download ${project_name} or pull updates.
	${tab}build
	${tab}${tab}Build ${project_name}.
	${tab}clean
	${tab}${tab}Clean-up downloaded and built files for ${project_name}.
	${tab}shell
	${tab}${tab}Open an interactive shell in the ${project_name} workspace.
	${tab}run
	${tab}${tab}Run ${project_name} or another command with ${project_name} environment.
	${tab}run-flatpak
	${tab}${tab}Run flatpak in ${project_name} environment.

	Build options:
	${tab}--pull
	${tab}${tab}Pull updates before building.
	${tab}-jN,--jobs N
	${tab}${tab}Build with N parallel jobs (default: Availables core count).
	${tab}--type=[TYPE]
	${tab}${tab}Build as <Type> build type. Default is DebWithRelInfo,
	${tab}${tab}other options are Debug and Release.

	Run options:
	${tab}--force
	${tab}${tab}Run the command even if ${project_name} isn't installed yet.

	Commands:
	${tab}Anything you want to run in thei ${project_name} environment.

	Examples:
	${tab}${script_name} build

	$(_help_custom_build)

	$(_help_common_application_run)

	$(_help_custom_run)

	EOF

	_mention

	exit
}

_help_common_platform_run () {
	# Always add an empty line after default options

	if "${provides_opencl}"
	then
		cat <<-EOF
		${tab}${script_name} run clinfo --list

		EOF
	fi

	if "${provides_hip}"
	then
		cat <<-EOF
		${tab}${script_name} run hipconfig

		EOF
	fi

	if "${provides_vulkan}"
	then
		cat <<-EOF
		${tab}${script_name} run vulkaninfo --summary

		${tab}${script_name} run vkcube

		EOF
	fi

	if "${provides_opengl}"
	then
		cat <<-EOF
		${tab}${script_name} run glxinfo -B

		${tab}${script_name} run glxgears

		${tab}${script_name} run glxheads

		EOF
	fi

	if "${provides_egl}"
	then
		cat <<-EOF
		${tab}${script_name} run eglinfo

		EOF
	fi
}

_help_basic_platform () {
	uniq <<-EOF
	${script_name}: Download, build ${project_name} and run software with it

	Usage: ${script_name} [OPTION] [ACTION] [OPTION] [COMMAND]

	Option:
	${tab}-h, --help
	${tab}${tab}Print this help.

	Actions:
	${tab}pull
	${tab}${tab}Download ${project_name} or pull updates.
	${tab}build
	${tab}${tab}Build ${project_name}.
	${tab}clean
	${tab}${tab}Clean-up downloaded and built files for ${project_name}.
	${tab}shell
	${tab}${tab}Open an interactive shell in the ${project_name} workspace.
	${tab}run
	${tab}${tab}Run command in ${project_name} environment.
	${tab}run-flatpak
	${tab}${tab}Run flatpak in ${project_name} environment.

	Build options:
	${tab}--pull
	${tab}${tab}Pull updates before building.
	${tab}-jN,--jobs N
	${tab}${tab}Build with N parallel jobs, default: Availables core count.
	${tab}--type=[TYPE]
	${tab}${tab}Build as <Type> build type. Default is DebWithRelInfo,
	${tab}${tab}other options are Debug and Release.

	Run options:
	${tab}--force
	${tab}${tab}Run the command even if ${project_name} isn't installed yet.

	Commands:
	${tab}Anything you want.

	Examples:
	${tab}${script_name} build

	$(_help_custom_build)

	$(_help_common_platform_run)

	$(_help_custom_run)

	EOF

	_mention

	exit
}

_help_featured_platform () {
	uniq <<-EOF
	${script_name}: Download and build ${project_name} and run software with it.

	Usage: ${script_name} [OPTION] [ACTION] [OPTION] [COMMAND]

	Option:
	${tab}-h, --help
	${tab}${tab}Print this help.

	Actions:
	${tab}pull
	${tab}${tab}Download ${project_name} or pull updates.
	${tab}build
	${tab}${tab}Build ${project_name}.
	${tab}clean
	${tab}${tab}Clean-up downloaded and built files for ${project_name}.
	${tab}shell
	${tab}${tab}Open an interactive shell in the ${project_name} workspace.
	${tab}run
	${tab}${tab}Run command in ${project_name} environment.
	${tab}run-flatpak
	${tab}${tab}Run flatpak in ${project_name} environment.

	Build options:
	${tab}--pull
	${tab}${tab}Pull updates before building.
	${tab}-jN,--jobs N
	${tab}${tab}Build with N parallel jobs, default: Availables core count.
	${tab}--force
	${tab}${tab}Force using as much parallel jobs even when there may not be enough memory.
	${tab}--type=[TYPE]
	${tab}${tab}Build as <Type> build type. Default is DebWithRelInfo,
	${tab}${tab}other options are Debug and Release.
	${tab}--features=[FEATURES]
	${tab}${tab}Build those features, comma separated list, default: ${default_feature_list}.
	${tab}${tab}Special name: all, build all known features.
	${tab}--enable=[FEATURES]
	${tab}${tab}Add features to feature build list, comma separated list.
	${tab}--disable=[FEATURES]
	${tab}${tab}Remove features from feature build list, comma separated list.

	Run options:
	${tab}--force
	${tab}${tab}Run the command even if ${project_name} isn't installed yet.

	Features:
	${tab}${known_feature_list}.

	Commands:
	${tab}Anything you want,

	Examples:
	${tab}${script_name} build

	$(_help_custom_build)

	$(_help_common_platform_run)

	$(_help_custom_run)

	EOF

	_mention

	exit
}


_help() {
	"_help_${help_preset}"
}

_mention () {
	cat >&2 <<-EOF
	This tool is provided by the I love compute! initiative.

	Always backup this script for future uninstallation, future versions
	of this script may not uninstall what was installed with this one.

	Always uninstall before upgrading to an higher version of the
	distribution you use.

	Support the effort to keep OpenCL working on Linux, if this script saved
	your life, you can make a donation, see:

	${tab}https://gitlab.com/illwieckz/i-love-compute#funding

	EOF
}

_spawn () {
	case "${1:-}" in
		'pull'|'build'|'clean'|'shell'|'run'|'run-flatpak')
			action="${1}"
			;;
		'-h'|'--help'|'')
			_help
			;;
		'-'*|'--'*)
			_error 'Unknown option.'
			;;
		*)
			_error 'Unknown action.'
			;;
	esac

	shift

	"_${action//-/_}" "${@}"

	printf '\n'

	_mention
}
