#!/usr/bin/env nextflow
// hash:sha256:90053caaf9f997b612194ee10693efa23a8e2f155029486e7dc7dad3cfb1ecf5

// capsule - aind-analysis-job-dispatch
process capsule_aind_analysis_job_dispatch_3 {
	tag 'capsule-3709532'
	container "$REGISTRY_HOST/published/d8136da9-6ebd-4881-acac-d054ca35d3ff:v5"

	cpus 1
	memory '7.5 GB'

	cache 'deep'

	input:
	path 'capsule/data/input_files'

	output:
	path 'capsule/results/*', emit: to_capsule_han_df_mle_aind_analysis_wrapper_4_2

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=d8136da9-6ebd-4881-acac-d054ca35d3ff
	export CO_CPUS=1
	export CO_MEMORY=8053063680

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	if [[ "\$(printf '%s\n' "2.20.0" "\$(git version | awk '{print \$3}')" | sort -V | head -n1)" = "2.20.0" ]]; then
		git -c credential.helper= clone --filter=tree:0 --branch v5.0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-3709532.git" capsule-repo
	else
		git -c credential.helper= clone --branch v5.0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-3709532.git" capsule-repo
	fi
	mv capsule-repo/code capsule/code && ln -s \$PWD/capsule/code /code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run ${params.capsule_aind_analysis_job_dispatch_3_args}

	echo "[${task.tag}] completed!"
	"""
}

// capsule - han_df_mle_aind-analysis-wrapper-v2
process capsule_han_df_mle_aind_analysis_wrapper_4 {
	tag 'capsule-4788275'
	container "$REGISTRY_HOST/published/d4c1024c-a047-49ff-b92e-39e86eeaf861:v3"

	cpus 1
	memory '7.5 GB'

	publishDir "$RESULTS_PATH/$index", mode: 'copy', saveAs: { filename -> new File(filename).getName() }

	input:
	path 'capsule/data/job_dict'
	val index

	output:
	path 'capsule/results/*'

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=d4c1024c-a047-49ff-b92e-39e86eeaf861
	export CO_CPUS=1
	export CO_MEMORY=8053063680

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	if [[ "\$(printf '%s\n' "2.20.0" "\$(git version | awk '{print \$3}')" | sort -V | head -n1)" = "2.20.0" ]]; then
		git -c credential.helper= clone --filter=tree:0 --branch v3.0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-4788275.git" capsule-repo
	else
		git -c credential.helper= clone --branch v3.0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-4788275.git" capsule-repo
	fi
	mv capsule-repo/code capsule/code && ln -s \$PWD/capsule/code /code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run ${params.capsule_han_df_mle_aind_analysis_wrapper_4_args}

	echo "[${task.tag}] completed!"
	"""
}

workflow {
	// input data
	input_files_to_aind_analysis_job_dispatch_1 = Channel.fromPath("../data/input_files", type: 'any')
	index = Channel.of(1..100000)

	// run processes
	capsule_aind_analysis_job_dispatch_3(input_files_to_aind_analysis_job_dispatch_1.collect())
	capsule_han_df_mle_aind_analysis_wrapper_4(capsule_aind_analysis_job_dispatch_3.out.to_capsule_han_df_mle_aind_analysis_wrapper_4_2.flatten(), index)
}
