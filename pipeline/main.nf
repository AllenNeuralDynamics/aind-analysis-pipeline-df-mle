#!/usr/bin/env nextflow
// hash:sha256:d5f0847189a7200e70e3184d8a459738ca9e2b9615706cb1f41c21f180a171cd

// capsule - han_df_mle_aind-analysis-job-dispatch-v2
process capsule_han_df_mle_aind_analysis_job_dispatch_3 {
	tag 'capsule-0849744'
	container "$REGISTRY_HOST/capsule/4717858b-f428-4929-943f-d0faa08afe66:88239447fd7917c7439a000a7869ad89"

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

	export CO_CAPSULE_ID=4717858b-f428-4929-943f-d0faa08afe66
	export CO_CPUS=1
	export CO_MEMORY=8053063680

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	if [[ "\$(printf '%s\n' "2.20.0" "\$(git version | awk '{print \$3}')" | sort -V | head -n1)" = "2.20.0" ]]; then
		git -c credential.helper= clone --filter=tree:0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-0849744.git" capsule-repo
	else
		git -c credential.helper= clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-0849744.git" capsule-repo
	fi
	git -C capsule-repo checkout 7779b58e406f0d49557ac89c4c4afca7bb98e64e --quiet
	mv capsule-repo/code capsule/code && ln -s \$PWD/capsule/code /code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run ${params.capsule_han_df_mle_aind_analysis_job_dispatch_3_args}

	echo "[${task.tag}] completed!"
	"""
}

// capsule - han_df_mle_aind-analysis-wrapper
process capsule_han_df_mle_aind_analysis_wrapper_4 {
	tag 'capsule-8973113'
	container "$REGISTRY_HOST/capsule/be26030f-2c75-4efc-a51a-3e33f03f34ad:892f7552b9c6cb0bd23b8dff5929961e"

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

	export CO_CAPSULE_ID=be26030f-2c75-4efc-a51a-3e33f03f34ad
	export CO_CPUS=1
	export CO_MEMORY=8053063680

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	if [[ "\$(printf '%s\n' "2.20.0" "\$(git version | awk '{print \$3}')" | sort -V | head -n1)" = "2.20.0" ]]; then
		git -c credential.helper= clone --filter=tree:0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-8973113.git" capsule-repo
	else
		git -c credential.helper= clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-8973113.git" capsule-repo
	fi
	git -C capsule-repo checkout 7414c46727ca5522f9b115c56915033ab8c0f10d --quiet
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
	input_files_to_han_df_mle_aind_analysis_job_dispatch_v2_1 = Channel.fromPath("../data/input_files", type: 'any')
	index = Channel.of(1..100000)

	// run processes
	capsule_han_df_mle_aind_analysis_job_dispatch_3(input_files_to_han_df_mle_aind_analysis_job_dispatch_v2_1.collect())
	capsule_han_df_mle_aind_analysis_wrapper_4(capsule_han_df_mle_aind_analysis_job_dispatch_3.out.to_capsule_han_df_mle_aind_analysis_wrapper_4_2.flatten(), index)
}
