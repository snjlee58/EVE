#!/bin/bash 
#SBATCH --cpus-per-task=1
#SBATCH --gres=gpu:1
#SBATCH -p gpu_quad
#SBATCH -t 2:00:00
#SBATCH --mem=90G
#SBATCH --output=/n/groups/marks/users/sunny/EVE/slurm/slurm-%j.out
#SBATCH --error=/n/groups/marks/users/sunny/EVE/slurm/slurm-%j.err
#SBATCH --job-name="score_EVE"

#module load gcc/6.2.0
#module load cuda/10.1
#module load miniconda3/23.1.0

#eval "$(conda shell.bash hook)"
#conda env update --file /n/groups/marks/projects/FLU/personal_directories/aarushim/EVE/protein_env.yml
#conda activate protein_env
#source ~/miniconda3/etc/profile.d/conda.sh
#conda activate protein_env

source /n/groups/marks/software/anaconda_o2/bin/activate /n/groups/marks/software/anaconda_o2/envs/protein_env

export MSA_data_folder=/n/groups/marks/users/sunny/tcr/alignments/HIV_NL4-3_Gag
export MSA_list='/n/groups/marks/users/sunny/EVE/data/mappings/training/hiv1_p17.csv'
export MSA_weights_location=/n/groups/marks/users/sunny/EVE/data/weights
export VAE_checkpoint_location=/n/groups/marks/users/sunny/EVE/results/VAE_parameters
export model_name_suffix='26sept25'
export model_parameters_location='/n/groups/marks/users/sunny/EVE/EVE/default_model_params.json'
export training_logs_location=/n/groups/marks/users/sunny/EVE/logs

export computation_mode='all_singles'
export all_singles_mutations_folder='/n/groups/marks/users/sunny/EVE/data/mutations'
export mutations_location=''
export output_evol_indices_location='/n/groups/marks/users/sunny/EVE/results/evol_indices'
export output_evol_indices_filename_suffix='_singles_26sept25'
export num_samples_compute_evol_indices=20000
export distance_metric='No'
export batch_size=1024

cd /n/groups/marks/users/sunny/EVE

srun python /n/groups/marks/users/abigail/viralfamilies/EVE/compute_evol_indices.py \
        --MSA_data_folder ${MSA_data_folder} \
        --MSA_list ${MSA_list} \
        --protein_index 0 \
        --MSA_weights_location ${MSA_weights_location} \
        --VAE_checkpoint_location ${VAE_checkpoint_location} \
        --model_name_suffix ${model_name_suffix} \
        --model_parameters_location ${model_parameters_location} \
        --computation_mode ${computation_mode} \
	--all_singles_mutations_folder ${all_singles_mutations_folder} \
        --output_evol_indices_location ${output_evol_indices_location} \
        --output_evol_indices_filename_suffix ${output_evol_indices_filename_suffix} \
        --num_samples_compute_evol_indices ${num_samples_compute_evol_indices} \
        --batch_size ${batch_size} \
        --distance_metric ${distance_metric}

# Use one of the following::
#       For all singles mode: 	--all_singles_mutations_folder ${all_singles_mutations_folder} \
#	For multi-mutation mode:  --mutations_location ${mutations_location} \
