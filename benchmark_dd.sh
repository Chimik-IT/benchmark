#!/bin/bash
file=$1
dump1="${file}_write_dump"
dump2="${file}_read_dump"
dump3="${file}_write_64M_c1_dump"
gwrite="${file}_g_write"
mwrite="${file}_m_write"
read="${file}_read"
lat="${file}_lat"

for i in {1..10}; do
    dd if=/dev/zero of=/alkoven/file.img bs=1G count=1 oflag=dsync 2>> g_wtest && tail -n 1 g_wtest >>"${dump1}"
done
sed 's/,/\./g' "${dump1}">"${gwrite}"
awk '{sum += $10}END{if (NR>0) print sum/NR $11}' "${gwrite}" > "${gwrite}_RESULTS"
for i in {1..10};do
    dd if=/dev/zero of=/alkoven/file.img bs=64M count=1 oflag=dsync 2>> m_wtest && tail -n 1 m_wtest >> "${dump3}"
done
sed 's/,/\./g' "${dump3}">"${mwrite}"
awk '{sum += $10}END{if (NR>0) print sum/NR $11}' "${mwrite}" > "${mwrite}_RESULTS"
for i in {1..10};
do
    dd if=/alkoven/file.img of=/dev/zero bs=1G count=1 oflag=dsync 2>> rtest && tail -n 1 rtest >>"${dump2}"
done
sed 's/,/\./g' "${dump2}" > "${read}"
awk '{sum += $10}END{if (NR>0) print sum/NR $11}' "${read}" > "${read}_RESULTS"
dd if=/dev/zero of=/alkoven/file.img bs=512 count=1000 oflag=dsync 2>> lattest && tail -n 1 lattest >>"${lat}"

awk '{print $8 $9}' "${lat}" > "${lat}_RESULTS"

rm g_wtest
rm m_wtest
rm rtest
rm "${dump1}"
rm "${dump2}"
rm "${lat}"
rm /alkoven/file.img

echo DONE!
echo Have a nice Day!
