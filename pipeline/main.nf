#!/usr/bin/env nextflow
// hash:sha256:d8b86cbbf018d1f55f7d79b716d340837765b53a0dade001c0a03e908d12315b

// capsule - han_df_mle_aind-analysis-job-dispatch-v2
process capsule_han_df_mle_aind_analysis_job_dispatch_3 {
	tag 'capsule-0849744'
	container "$REGISTRY_HOST/capsule/4717858b-f428-4929-943f-d0faa08afe66:0a9adbb6cbdc929c253a4e7e53ba7f07"

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
	git -C capsule-repo checkout 5b52b5d32ebb2c320b648f54bef37f5f96a6517c --quiet
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
	container "$REGISTRY_HOST/capsule/be26030f-2c75-4efc-a51a-3e33f03f34ad:fbbc33d6f2c2f16a1150111a02536e09"

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
	git -C capsule-repo checkout 2d9f04545b03de9ba0c2919ee4ffa36225c3a840 --quiet
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
