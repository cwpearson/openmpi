# openmpi

    docker stop $(docker ps -a -q)
    docker rm $(docker ps -a -q)
    docker rmi $(docker images -f dangling=true -q)

    docker-compose up --scale mpi_head=1 --scale=mpi_node=1