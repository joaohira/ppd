#!/bin/bash
#SBATCH -J pi-integral
#SBATCH -p fast
#SBATCH -n 1
#SBATCH -t 01:30:00
#SBATCH --cpus-per-task=40
#SBATCH --output=%x.%j.out
#SBATCH --error=%x.%j.err

n_steps=1000000000

printf "*** pi_seq - Sequencial ***\n\t"
srun singularity run container.sif pi_seq $n_steps

printf "\n*** pi_pth - Pthreads ***\n"
for n_threads in 1 2 5 10 20 40
do
    printf "n_threads = $n_threads\n\t"
    srun singularity run container.sif pi_pth $n_steps $n_threads
done

printf "\n*** pi_omp - OpenMP ***\n"
for n_threads in 1 2 5 10 20 40
do
    printf "n_threads = $n_threads\n\t"
    export OMP_NUM_THREADS=$n_threads
    srun singularity run container.sif pi_omp $n_steps
done
