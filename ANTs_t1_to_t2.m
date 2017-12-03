T2_path=('/rfanfs/pnl-zorro/projects/ADHD/case225/T2/T2_1-Aligned.nrrd');
T1_path=('/rfanfs/pnl-zorro/projects/ADHD/case225/T1/T1_1_case225-c.nrrd');

outputPath=('/rfanfs/pnl-zorro/projects/ADHD/case225/T2/T1_in_T2.nrrd');
transformation_matrix=('/rfanfs/pnl-zorro/projects/ADHD/case225/T2/T1_in_T2_');

command=['${ANTSPATH}/ANTS 3 -m MI[' T2_path ' ' ',' ' ' T1_path ' ' ',1,32] -i 0 -o ' ' ' transformation_matrix ' ' ' --do-rigid'];
command2=['$ANTSPATH/antsApplyTransforms -d 3 -i ' ' ' T1_path ' '  '-o ' ' ' outputPath ' ' '-r ' ' ' T2_path  ' -t ' ' ' transformation_matrix 'Affine.txt'];
system(command)
system(command2)