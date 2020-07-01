#!/bin/bash
file=$1
write="${file}_write"
read="${file}_read"
for i in {1..100}; do
    dd if=/dev/urandom of=/zpool0-z3/file.img bs=1G count=1 2> test && tail -f test >>"${file}" && sed 's/,/\./g'"${file}" >> "${write}"
done

for i in {1..100};do
    dd if=/zpool0-z3/file.img of=/dev/zero bs=1G count=1 2> test && tail -f test >>"${file}" && sed 's/,/\./g' "${file}"  >> "${read}"
done

awk '{sum += $10}END{if (NR>0) print sum/NR}' "${write}" > "${write}_RESULTS"
awk '{sum += $10}END{if (NR>0) print sum/NR}' "${read}" > "${read}_RESULTS"

echo -e "Write Bench: ${write}_RESULTS "
echo -e "Write Bench: ${read}_RESULTS "

echo DONE!
echo Have a nice Day!
