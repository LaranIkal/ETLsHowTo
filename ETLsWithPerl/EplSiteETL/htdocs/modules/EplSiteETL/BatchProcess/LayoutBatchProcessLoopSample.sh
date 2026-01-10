cd ..
cd ..
cd ..
cd ..
cd ..
AdditionalValues=( value1 value2 )
for var in "${AdditionalValues[@]}"
do
./hypertextperl.pl htdocs/eplsite/modules/EplSiteETL/BatchProcess/LayoutBatchProcessLoopSample.ppl Layout 001 ETLSample 2 9 9 tmp ${var}
done


