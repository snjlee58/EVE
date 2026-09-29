#!/bin/bash
#SBATCH --cpus-per-task=8
#SBATCH --gres=gpu:1
#SBATCH -p gpu_quad
#SBATCH -t 1-00:00:00
#SBATCH --mem=50G
#SBATCH --output=/n/groups/marks/users/sunny/EVE/slurm/slurm-%j.out
#SBATCH --error=/n/groups/marks/users/sunny/EVE/slurm/slurm-%j.err
#SBATCH --job-name="train_EVE_HV"
#SBATCH --array=0

#module load gcc/6.2.0
#module load cuda/10.1
#module load miniconda3/23.1.0

# source ~/miniconda3/etc/profile.d/conda.sh
# conda activate protein_env

source /n/groups/marks/software/anaconda_o2/bin/activate /n/groups/marks/software/anaconda_o2/envs/protein_env

#eval "$(conda shell.bash hook)"
#conda env update --file /n/groups/marks/users/abigail/viralfamilies/EVE/protein_env.yml
#conda activate protein_env

export MSA_data_folder=/n/groups/marks/users/sunny/tcr/alignments/HIV_NL4-3_Gag
export MSA_list='/n/groups/marks/users/sunny/EVE/data/mappings/training/hiv1_p24.csv'
export MSA_weights_location=/n/groups/marks/users/sunny/EVE/data/weights
export VAE_checkpoint_location=/n/groups/marks/users/sunny/EVE/results/VAE_parameters
export model_name_suffix='26sept25'
export model_parameters_location='/n/groups/marks/users/sunny/EVE/EVE/default_model_params.json'
export training_logs_location=/n/groups/marks/users/sunny/EVE/logs

cd /n/groups/marks/users/sunny/EVE

srun \
    python train_VAE.py \
        --MSA_data_folder ${MSA_data_folder} \
        --MSA_list ${MSA_list} \
        --protein_index $SLURM_ARRAY_TASK_ID \
        --MSA_weights_location ${MSA_weights_location} \
        --VAE_checkpoint_location ${VAE_checkpoint_location} \
        --model_name_suffix ${model_name_suffix} \
        --model_parameters_location ${model_parameters_location} \
        --training_logs_location ${training_logs_location} 
