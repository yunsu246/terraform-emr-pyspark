#!/usr/bin/env bash

# bind conda to spark
# echo -e "\nexport PYSPARK_PYTHON=/usr/bin/python3" >> /etc/spark/conf/spark-env.sh
echo -e "\nexport PYSPARK_PYTHON=/home/hadoop/conda/bin/python" >> /etc/spark/conf/spark-env.sh
echo "export PYSPARK_DRIVER_PYTHON=/home/hadoop/conda/bin/python" >> /etc/spark/conf/spark-env.sh
# echo "export PYSPARK_DRIVER_PYTHON_OPTS='jupyter notebook --no-browser --port 8888 --ip=\"0.0.0.0\"'" >> /etc/spark/conf/spark-env.sh
