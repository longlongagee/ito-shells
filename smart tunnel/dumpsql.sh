#!/bin/bash
sum_txt=/gmcc/bak/sum.txt
dump_dir=/gmcc/bak

if [ !  -d ${dump_dir} ];then
        mkdir -p ${dump_dir}
fi

/usr/local/server/mysql/bin/mysqldump -uroot -phuajing@123# visit > ${dump_dir}/visit_113_$(date +%Y%m%d)
echo ${dump_dir}/visit_113_$(date +%Y%m%d)  >> ${sum_txt}
sum_wc=`wc -l ${sum_txt} |cut -d ' ' -f 1 `

if [ ${sum_wc} -ge 6 ];then
        rm -rf `cat ${sum_txt} |head -1`
        sed -i '1d' ${sum_txt}
fi

